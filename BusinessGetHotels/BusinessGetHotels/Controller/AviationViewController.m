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

@interface AviationViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate> {
    NSInteger notAcquireFlag;
    NSInteger followFlag;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *canQuoteTableView;//报价
@property (weak, nonatomic) IBOutlet UITableView *expireTableView;//过期
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic)HMSegmentedControl *segmentedControl;
@end

@implementation AviationViewController

//导航栏的返回按钮只保留那个箭头，去掉后边的文字
//[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
//[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    notAcquireFlag = 1;
    followFlag = 1;
    
    //去除底部多余的线
    _canQuoteTableView.tableFooterView = [UIView new];
    _expireTableView.tableFooterView = [UIView new];
    //菜单栏
    [self setSegment];
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
    if (notAcquireFlag == 1 && page == 1) {
        notAcquireFlag = 0;
        NSLog(@"第一次来到这个未获取页面");
        //[self notAcquireInitializeData];
    }
    //判断第一次来到这个页面
    if (followFlag == 1 && page == 2) {
        followFlag = 0;
        NSLog(@"第一次来到这个跟进页面");
        //[self followInitializeData];
    }
    return page;
}
#pragma mark - tableViewCell
//每一组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
//每行细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _canQuoteTableView) {
        CanQuoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CanQuoteCell" forIndexPath:indexPath];
        cell.datesLbl.text = @"8-27";//起飞时间
        cell.cityLbl.text = @"无锡——北京";//城市to城市
        cell.ticketLbl.text = @"机票";//机票
        cell.priceLbl.text = @"价格区间";//价格区间
        cell.moneyLbl.text = @"￥:500-800";//价格在多少
        cell.timeLbl.text = @"晚上8点左右";//入住时间
        cell.cabinLbl.text = @"好运来头等舱";//机舱
        cell.imgView.image = [UIImage imageNamed:@""];
        
        return cell;
        
    } else {
        ExpireTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expireCell" forIndexPath:indexPath];
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
