//
//  AviationViewController.m
//  BusinessGetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "AviationViewController.h"
#import "CanQuoteTableViewCell.h"
#import "ExpireTableViewCell.h"
#import "HMSegmentedControl.h"
#import "QuoteViewController.h"
#import "CCActivityHUD.h"
#import "AviationModel.h"

@interface AviationViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate> {
    NSInteger expireFlag;
    
    
    NSInteger canQuotePageNum;
    BOOL canQuoteLast;
    
    NSInteger expirePageNum;
    BOOL expireLast;
    
    NSInteger pageSize;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *canQuoteTableView;//报价
@property (weak, nonatomic) IBOutlet UITableView *expireTableView;//过期
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic)HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
//@property (strong, nonatomic) CCActivityHUD *activityHUD;
@property (strong, nonatomic) NSMutableArray *canQuoteArr;
@property (strong, nonatomic) NSMutableArray *expireArr;
@end

@implementation AviationViewController

//导航栏的返回按钮只保留那个箭头，去掉后边的文字
//[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
//[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

- (void)viewDidLoad {
    [super viewDidLoad];
    _canQuoteArr = [NSMutableArray new];
    _expireArr = [NSMutableArray new];
    // Do any additional setup after loading the view.
    
    expireFlag = 1;
    
    canQuotePageNum = 1;
    expirePageNum = 1;
    pageSize = 10;
    
    //self.activityHUD = [CCActivityHUD new];
    //self.activityHUD.isTheOnlyActiveView = NO;
    //透明的，具有全覆盖效果
    //self.activityHUD.overlayType = CCActivityHUDOverlayTypeTransparent;
    
    
    //去除底部多余的线
    _canQuoteTableView.tableFooterView = [UIView new];
    _expireTableView.tableFooterView = [UIView new];
    //菜单栏
    [self setSegment];
    //刷新指示器
    [self setRefreshControl];
    [self canQuoteInitializeData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//每次将要来到这个页面（隐藏导航栏）
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
#pragma mark -setSegment菜单栏
//初始化菜单栏的方法
- (void)setSegment{
    //实例化一个segmentedControl，设置其标题
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"可报价",@"已过期"]];
    //设置segmentedControl的大小位置
    _segmentedControl.frame = CGRectMake(0, _headerView.frame.size.height, UI_SCREEN_W, 40);
    //设置segmentedControl的默认@"可报价"的位置
    _segmentedControl.selectedSegmentIndex = 0;
    //设置segmentedControl的背景色
    _segmentedControl.backgroundColor = UIColorFromRGB(75, 139, 246);
    //设置线的高度
    _segmentedControl.selectionIndicatorHeight = 3.f;
    //点击的标题下方样式
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.selectionIndicatorColor = UIColorFromRGB(198, 197, 197);
    //下滑线的位置（向下）
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //设置未选中的标题样式
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGBA(154, 154, 154, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:21.f]};
    //选中时的标题样式
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGBA(230, 230, 230, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:21.f]};
    __weak typeof(self) weakSelf = self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W * index, 0, UI_SCREEN_W, 200) animated:YES];
    }];
    
    [self.view addSubview:_segmentedControl];
}
#pragma mark - setRefreshControl刷新
//创建刷新指示器的方法
- (void) setRefreshControl {
    //可报价列表的刷新指示器
    UIRefreshControl *canQuoteRef = [UIRefreshControl new];
    [canQuoteRef addTarget:self action:@selector(canQuoteRef) forControlEvents:UIControlEventValueChanged];
    canQuoteRef.tag = 10001;
    [_canQuoteTableView addSubview:canQuoteRef];
    //已过期列表的刷新指示器
    UIRefreshControl *expireRef = [UIRefreshControl new];
    [expireRef addTarget:self action:@selector(expireRef) forControlEvents:UIControlEventValueChanged];
    expireRef.tag = 10002;
    [_expireTableView addSubview:expireRef];
}
//已获取列表下拉刷新事件
- (void) canQuoteRef {
    canQuotePageNum = 1;
    [self canQuoteRequest];
}
//未获取列表下拉刷新事件
- (void) expireRef {
    expirePageNum = 1;
    [self expireRequest];
    
}
//第一次进行网络请求的时候需要覆盖上蒙层，而下拉刷新的时候不需要这个蒙层，所有我们把第一次网络请求和下拉刷新分开
- (void) canQuoteInitializeData {
    //菊花膜（刷新器）
    _avi = [Utilities getCoverOnView:self.view];
    [self canQuoteRequest];
}
//第一次进行网络请求的时候需要覆盖上蒙层，而下拉刷新的时候不需要这个蒙层，所有我们把第一次网络请求和下拉刷新分开
- (void) expireInitializeData {
    //菊花膜（刷新器）
    _avi = [Utilities getCoverOnView:self.view];
    [self expireRequest];
}
#pragma mark - scrollView
//scrollView已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        NSInteger page = [self scrollCheck:scrollView];
        //设置_segmentedControl选中的index为page（scrollView当前显示的tableView）
        [_segmentedControl setSelectedSegmentIndex:page animated:YES];
        //NSLog(@"%ld",(long)page);
    }
}
////scrollView已经结束滑动的动画（实现点击标题_titleNumLabel里面的内容会更改）
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    if (scrollView == _scrollView) {
//        [self scrollCheck:scrollView];
//    }
//}
//判断scroolView滑到哪里了
- (NSInteger)scrollCheck: (UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / (scrollView.frame.size.width);
    //判断第一次来到这个页面
    if (expireFlag == 1 && page == 1) {
        expireFlag = 0;
        [self expireInitializeData];
        NSLog(@"第一次来到这个未获取页面");
        //[self notAcquireInitializeData];
    }
    return page;
}
#pragma mark - request网络请求
//已报价接口
- (void) canQuoteRequest {
    //创建菊花膜（点击按钮的时候，并显示在当前页面）
    //_avi = [Utilities getCoverOnView:self.view];
    //[self.activityHUD showWithText:@"加载中..." shimmering:YES];
    //参数
    NSDictionary *para = @{@"type" : @(1),@"pageNum":@(canQuotePageNum),@"pageSize":@(pageSize)};
    //网络请求
    [RequestAPI requestURL:@"/findAlldemandByType_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"哈哈:%@",responseObject);
        //当网络请求成功时停止动画
        [_avi stopAnimating];
        //结束刷新
        UIRefreshControl *ref = (UIRefreshControl *)[_canQuoteTableView viewWithTag:10001];
        [ref endRefreshing];
        //加载成功可以使用这个
        //[self.activityHUD dismiss];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSDictionary *Aviation_demand = responseObject[@"content"][@"Aviation_demand"];
            NSArray *list = Aviation_demand[@"list"];
            //下拉刷新的时候不但要把页码变为1，而且还要将数组中原有的数据清空
            if (canQuotePageNum == 1) {
                [_canQuoteArr removeAllObjects];
            }
            for(NSDictionary *dict in list){
                AviationModel *model = [[AviationModel alloc] initWiihDetailDictionary:dict];
                [_canQuoteArr addObject:model];
            
            }
            [_canQuoteTableView reloadData];
            
                        //用model的方式返回上一页
            //[self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self onCompletion:^{
            }];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        //加载失败之后可以使用这个
        //[self.activityHUD dismissWithText:nil delay:0.7 success:NO];
        [Utilities popUpAlertViewWithMsg:@"网络似乎不太给力,请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
        }];
        
        
    }];
    
}
//已过期接口
- (void) expireRequest {
    //创建菊花膜（点击按钮的时候，并显示在当前页面）
    //_avi = [Utilities getCoverOnView:self.view];
    //[self.activityHUD showWithText:@"加载中..." shimmering:YES];
    //参数
    NSDictionary *para = @{@"type" : @(0),@"pageNum":@(expirePageNum),@"pageSize":@(pageSize)};
    //网络请求
    [RequestAPI requestURL:@"/findAlldemandByType_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"哈哈:%@",responseObject);
        //当网络请求成功时停止动画
        [_avi stopAnimating];
        //结束刷新
        UIRefreshControl *ref = (UIRefreshControl *)[_expireTableView viewWithTag:10002];
        [ref endRefreshing];
        //加载成功可以使用这个
        //[self.activityHUD dismiss];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSDictionary *Aviation_demand = responseObject[@"content"][@"Aviation_demand"];
            NSArray *list = Aviation_demand[@"list"];
            //下拉刷新的时候不但要把页码变为1，而且还要将数组中原有的数据清空
            if (expirePageNum == 1) {
                [_expireArr removeAllObjects];
            }
            for(NSDictionary *dict in list){
                AviationModel *model = [[AviationModel alloc] initWiihDetailDictionary:dict];
                [_expireArr addObject:model];
                
            }
            [_expireTableView reloadData];
            
            //用model的方式返回上一页
            //[self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self onCompletion:^{
            }];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        //加载失败之后可以使用这个
        //[self.activityHUD dismissWithText:nil delay:0.7 success:NO];
        [Utilities popUpAlertViewWithMsg:@"网络似乎不太给力,请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
        }];
        
        
    }];
    
}
#pragma mark - tableViewCell
//每一组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _canQuoteTableView) {
       return _canQuoteArr.count;
    } else {
        return _expireArr.count;
    }
    
}
//每行细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _canQuoteTableView) {
        CanQuoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CanQuoteCell" forIndexPath:indexPath];
        AviationModel * aviationmodel = _canQuoteArr[indexPath.row];
        
        cell.datesLbl.text = @"8-27";//起飞时间
        cell.cityLbl.text = [NSString stringWithFormat:@"%@——%@",aviationmodel.departure,aviationmodel.destination];//城市to城市
        //cell.ticketLbl.text = @"机票";//机票
        //cell.priceLbl.text = @"价格区间";//价格区间
        cell.moneyLbl.text = [NSString stringWithFormat:@"￥:%@—%@",aviationmodel.low_price,aviationmodel.high_price];//价格在多少low_price,high_price
        cell.timeLbl.text = @"晚上8点左右";//入住时间
        cell.cabinLbl.text = aviationmodel.aviation_demand_detail;//机舱
        //cell.canQuoteImgView.image = [UIImage imageNamed:@""];
        
        return cell;
        
    } else {
        ExpireTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expireCell" forIndexPath:indexPath];
        AviationModel * aviationmodel = _expireArr[indexPath.row];
//        datesLbl;//过期起飞时间
//        cityLbl;//城市to城市
//        ticketLbl;//机票
//        priceLbl;//价格区间
//        moneyLbl;//价格在多少
//        timeLbl;//入住时间
//        expireLbl;//过期
        cell.datesLbl.text = @"8-27";//起飞时间
        cell.cityLbl.text = [NSString stringWithFormat:@"%@——%@",aviationmodel.departure,aviationmodel.destination];//城市to城市
        //cell.ticketLbl.text = @"机票";//机票
        //cell.priceLbl.text = @"价格区间";//价格区间
        cell.moneyLbl.text = [NSString stringWithFormat:@"￥:%@—%@",aviationmodel.low_price,aviationmodel.high_price];//价格在多少low_price,high_price
        cell.timeLbl.text = @"晚上8点左右";//入住时间
        //cell.cabinLbl.text = aviationmodel.aviation_demand_title;//机舱
        return cell;
    }
    
}
//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.f;
}
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中状态
    if (tableView == _canQuoteTableView) {
//        //获取要跳转过去的那个页面
//        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Quote" byIdentity:@"Quote"];
//        //执行跳转
//        [self presentViewController:signNavi animated:YES completion:nil];
        QuoteViewController *purchaseVC = [Utilities getStoryboardInstance:@"Quote" byIdentity:@"Quote1"];
        //purchaseVC.activity = _activity;
        [self.navigationController pushViewController:purchaseVC animated:NO];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
