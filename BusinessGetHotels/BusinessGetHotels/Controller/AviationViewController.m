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
@property (strong, nonatomic) AviationModel *model;

@property (strong, nonatomic) UIImageView *canQuoteNothingImg;
@property (strong, nonatomic) UIImageView *expireNothingImg;
@end

@implementation AviationViewController

//导航栏的返回按钮只保留那个箭头，去掉后边的文字
//UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
//[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
//[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//self.navigationItem.backBarButtonItem = item;
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
    if (_canQuoteArr.count == 0) {
        [self nothingForTableView];
    } else {
        [self nothingForTableView];
    }
    [self canQuoteInitializeData];
    //调用tableview没数据是显示图片的方法
    
    
    
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
//scrollView已经结束滑动的动画(具有点击菜单栏会刷新)
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        [self scrollCheck:scrollView];
    }
}
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
//当TableView没有东西的时候，添加一个图片给它
- (void) nothingForTableView {
    _canQuoteNothingImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no_things"]];
    _canQuoteNothingImg.frame = CGRectMake((UI_SCREEN_W - 100)/2, 50, 100, 100);
    
    _expireNothingImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no_things"]];
    _expireNothingImg.frame = CGRectMake((UI_SCREEN_W - 100)/2 + UI_SCREEN_W, 50, 100, 100);
    
    [_scrollView addSubview:_canQuoteNothingImg];
    [_scrollView addSubview:_expireNothingImg];
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
            canQuoteLast = [Aviation_demand[@"isLastPage"] boolValue];
            //下拉刷新的时候不但要把页码变为1，而且还要将数组中原有的数据清空
            if (canQuotePageNum == 1) {
                [_canQuoteArr removeAllObjects];
            }
            for(NSDictionary *dict in list){
                _model = [[AviationModel alloc] initWiihDetailDictionary:dict];
                [_canQuoteArr addObject:_model];
            
            }
            //当数组有数据时将图片隐藏，反之隐藏
            if (_canQuoteArr.count == 0) {
                _canQuoteNothingImg.hidden = NO;
            }else{
                _canQuoteNothingImg.hidden = YES;
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
        //结束刷新
        UIRefreshControl *ref = (UIRefreshControl *)[_canQuoteTableView viewWithTag:10001];
        [ref endRefreshing];
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
        //NSLog(@"哈哈:%@",responseObject);
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
            expireLast = [Aviation_demand[@"isLastPage"] boolValue];
            //下拉刷新的时候不但要把页码变为1，而且还要将数组中原有的数据清空
            if (expirePageNum == 1) {
                [_expireArr removeAllObjects];
            }
            for(NSDictionary *dict in list){
                _model = [[AviationModel alloc] initWithDetailDictionary:dict];
                [_expireArr addObject:_model];
                
            }
            //当数组有数据时将图片隐藏，反之隐藏
            if (_expireArr.count == 0) {
                _expireNothingImg.hidden = NO;
            }else{
                _expireNothingImg.hidden = YES;
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
        //结束刷新
        UIRefreshControl *ref = (UIRefreshControl *)[_expireTableView viewWithTag:10002];
        [ref endRefreshing];
        //加载失败之后可以使用这个
        //[self.activityHUD dismissWithText:nil delay:0.7 success:NO];
        [Utilities popUpAlertViewWithMsg:@"网络似乎不太给力,请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
        }];
        
        
    }];
    
}
#pragma mark - tableViewCell
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _canQuoteTableView) {
        return _canQuoteArr.count;
    } else {
        return _expireArr.count;
    }
    
}
//每一组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//每行细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _canQuoteTableView) {
        CanQuoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CanQuoteCell" forIndexPath:indexPath];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
        format.AMSymbol = @"上午";
        format.PMSymbol = @"下午";
        format.dateFormat = @"yyyy-MM-dd aaa";
        AviationModel * aviationmodel = _canQuoteArr[indexPath.section];
        //cell.timeLabel.text = [Utilities dateStrFromCstampTime:callBack.callTime withDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *endTimeStr = [Utilities dateStrFromCstampTime:aviationmodel.start_time withDateFormat:@"MM-dd"];
        
        cell.datesLbl.text = [NSString stringWithFormat:@"%@",endTimeStr];//起飞时间
        cell.cityLbl.text = [NSString stringWithFormat:@"%@——%@",aviationmodel.departure,aviationmodel.destination];//城市to城市
        //cell.ticketLbl.text = @"机票";//机票
        //cell.priceLbl.text = @"价格区间";//价格区间
        cell.moneyLbl.text = [NSString stringWithFormat:@"￥:%@—%@",aviationmodel.low_price,aviationmodel.high_price];//价格在多少low_price,high_price
        
        //NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:aviationmodel.start_time/1000];
        
        NSString *timeStr = [Utilities dateStrFromCstampTime:aviationmodel.start_time withDateFormat:@"aaah"];
        cell.timeLbl.text = [NSString stringWithFormat:@"%@点左右",timeStr];//入住时间
        
        
        cell.cabinLbl.text = aviationmodel.aviation_demand_detail;//机舱
        //cell.canQuoteImgView.image = [UIImage imageNamed:@""];
        
        return cell;
        
    } else {
        ExpireTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expireCell" forIndexPath:indexPath];
        AviationModel * aviationmodel = _expireArr[indexPath.section];
        NSString *endTimeStr = [Utilities dateStrFromCstampTime:aviationmodel.start_time withDateFormat:@"MM-dd"];
        cell.datesLbl.text = [NSString stringWithFormat:@"%@",endTimeStr];//起飞时间
        cell.cityLbl.text = [NSString stringWithFormat:@"%@——%@",aviationmodel.departure,aviationmodel.destination];//城市to城市
        cell.moneyLbl.text = [NSString stringWithFormat:@"￥:%@—%@",aviationmodel.low_price,aviationmodel.high_price];//价格在多少low_price,high_price
        
        //NSString *timeStr = [Utilities dateStrFromCstampTime:aviationmodel.start_time withDateFormat:@"aaah"];
        //cell.timeLbl.text = [NSString stringWithFormat:@"%@点左右",timeStr];//入住时间
        
        NSString *timeStr = [Utilities dateStrFromCstampTime:aviationmodel.start_time withDateFormat:@"HH"];
        NSInteger time = [timeStr intValue];
        if (time >= 0 && time <= 6) {
            cell.timeLbl.text = [NSString stringWithFormat:@"凌晨%ld点左右",(long)time];//入住时间
        }else if (time > 6 && time <12 ) {
            cell.timeLbl.text = [NSString stringWithFormat:@"上午%ld点左右",(long)time];//入住时间
        }else if (time >= 12 && time < 13) {
            cell.timeLbl.text = [NSString stringWithFormat:@"中午%@点左右",timeStr];//入住时间
            
        }else if (time >= 13 && time <= 17) {
            cell.timeLbl.text = [NSString stringWithFormat:@"下午%ld点左右",time - 12];//入住时间
        }else {
            cell.timeLbl.text = [NSString stringWithFormat:@"晚上%ld点左右",time - 12];//入住时间
        }
        
        
        
        //NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:aviationmodel.start_time/1000];
        //cell.timeLbl.text = [NSString stringWithFormat:@"%@点左右",[detaildate formattedTime]];//调用NSDate+Utility的方法
        //上面比较重要
        //cell.cabinLbl.text = aviationmodel.aviation_demand_title;//机舱
        return cell;
    }
    
}
//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130.f;
}
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中状态
    if (tableView == _canQuoteTableView) {
//        //获取要跳转过去的那个页面
//        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Quote" byIdentity:@"Quote"];
//        //执行跳转
//        [self presentViewController:signNavi animated:YES completion:nil];
        QuoteViewController *quoteVC = [Utilities getStoryboardInstance:@"Quote" byIdentity:@"Quote1"];
        //将每组的数据给model，传入下一页
        _model = _canQuoteArr[indexPath.section];
        quoteVC.aviationmodel = _model;
        [self.navigationController pushViewController:quoteVC animated:NO];
    }
}
//设置一个细胞将要出现的时候要做的事情
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _canQuoteTableView) {
        //判断是不是最后一行细胞将要出现
        if (indexPath.section == _canQuoteArr.count - 1) {
            //判断还有没有下一页存在
            if (!canQuoteLast) {
                //在这里执行上拉翻页的数据操作
                canQuotePageNum++;
                [self canQuoteRequest];
                //NSLog(@"呵呵呵呵呵");
            }
        }
    }else{
        //判断是不是最后一行细胞将要出现
        if (indexPath.section == _expireArr.count - 1) {
            //判断还有没有下一页存在
            if (!expireLast) {
                //在这里执行上拉翻页的数据操作
                expirePageNum++;
                [self expireRequest];
                //NSLog(@"呵呵呵呵呵");
            }
        }
    }
//        NSArray *array =  tableView.indexPathsForVisibleRows;
//        NSIndexPath *firstIndexPath = array[0];
//        NSLog(@"fdasf---%ld---%lu",(long)firstIndexPath.row,(unsigned long)array.count);
//        //设置anchorPoint
//        cell.layer.anchorPoint = CGPointMake(0, 0.5);
//        //为了防止cell视图移动，重新把cell放回原来的位置
//        cell.layer.position = CGPointMake(0, cell.layer.position.y);
//    
//        //设置cell 按照z轴旋转90度，注意是弧度
//        if (firstIndexPath.row < indexPath.row) {
//            cell.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1.0);
//        }else{
//            cell.layer.transform = CATransform3DMakeRotation(- M_PI_2, 0, 0, 1.0);
//        }
//    
//        cell.alpha = 0.0;
//    
//        [UIView animateWithDuration:1 animations:^{
//            cell.layer.transform = CATransform3DIdentity;
//            cell.alpha = 1.0;
//        }];
    
    
    
//        cell.alpha = 0.5;
//    
//        CGAffineTransform transformScale = CGAffineTransformMakeScale(0.3,0.8);
//        CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(0.5, 0.6);
//    
//        cell.transform = CGAffineTransformConcat(transformScale, transformTranslate);
//    
//        [tableView bringSubviewToFront:cell];
//        [UIView animateWithDuration:.4f
//                              delay:0
//                            options:UIViewAnimationOptionAllowUserInteraction
//                         animations:^{
//    
//                             cell.alpha = 1;
//                             //清空 transform
//                             cell.transform = CGAffineTransformIdentity;
//    
//                         } completion:nil];
    
    
//        CATransform3D rotation;//3D旋转
//            rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
//            //逆时针旋转
//            rotation.m34 = 1.0/ -600;
//    
//            cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//            cell.layer.shadowOffset = CGSizeMake(10, 10);
//            cell.alpha = 0;
//    
//            cell.layer.transform = rotation;
//    
//            [UIView beginAnimations:@"rotation" context:NULL];
//            //旋转时间
//            [UIView setAnimationDuration:0.8];
//            cell.layer.transform = CATransform3DIdentity;
//            cell.alpha = 1;
//            cell.layer.shadowOffset = CGSizeMake(0, 0);
//            [UIView commitAnimations];
    
//    // 从锚点位置出发，逆时针绕 Y 和 Z 坐标轴旋转90度
//    CATransform3D transform3D = CATransform3DMakeRotation(M_PI_2, 0.0, 1.0, 1.0);
//    
//    // 定义 cell 的初始状态
//    cell.alpha = 0.0;
//    cell.layer.transform = transform3D;
//    cell.layer.anchorPoint = CGPointMake(0.0, 0.5); // 设置锚点位置；默认为中心点(0.5, 0.5)
//    
//    // 定义 cell 的最终状态，执行动画效果
//    // 方式一：普通操作设置动画
//    [UIView beginAnimations:@"transform" context:NULL];
//    [UIView setAnimationDuration:0.5];
//    cell.alpha = 1.0;
//    cell.layer.transform = CATransform3DIdentity;
//    CGRect rect = cell.frame;
//    rect.origin.x = 0.0;
//    cell.frame = rect;
//    [UIView commitAnimations];
    
    
    //设置Cell的动画效果为3D效果
    //设置x和y的初始值为0.1；
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    //x和y的最终值为1
    [UIView animateWithDuration:1 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
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
