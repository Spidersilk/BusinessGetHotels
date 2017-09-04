//
//  QuoteViewController.m
//  BusinessGetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "QuoteViewController.h"

@interface QuoteViewController (){
    NSInteger flag;
}
@property (weak, nonatomic) IBOutlet UIView *aviView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *arriveBtn;
@property (weak, nonatomic) IBOutlet UIButton *takeoffBtn;
@property (weak, nonatomic) IBOutlet UIButton *startSiteBtn;
@property (weak, nonatomic) IBOutlet UIButton *endSiteBtn;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *flightTextField;
@property (weak, nonatomic) IBOutlet UITextField *placeTextField;
@property (weak, nonatomic) IBOutlet UITextField *kgTextField;
- (IBAction)startSiteAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)endSiteAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)takeoffTime:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)arriveTime:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)confirmAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *quoteTableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *quoteDatePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *quoteToolbar;
- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)sureAction:(UIBarButtonItem *)sender;

@end

@implementation QuoteViewController

- (void)viewDidLoad {
    flag = 0;
    [super viewDidLoad];
    [self naviConfing];
    [self anniu];
    // Do any additional setup after loading the view.
    _confirmBtn.enabled = NO;
    _confirmBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCityState:) name:@"ResetHome" object:nil];
}
//将要来到此页面（显示导航栏）
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfing
{
    //self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    self.navigationItem.title = @"报价";
    //设置导航条的风格颜色
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(45, 120, 255);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    //设置导航条按钮的分格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //是否需要毛玻璃的效果
    //self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    //导航栏的返回按钮只保留那个箭头，去掉后边的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = item;
}
- (void) checkCityState:(NSNotification *)note {
    NSString *cityStr = note.object;
    if (![cityStr isEqualToString:_startSiteBtn.titleLabel.text] || ![cityStr isEqualToString:_endSiteBtn.titleLabel.text]) {
        if(flag == 0){
            //修改城市按钮标题
            [_startSiteBtn setTitle:cityStr forState:UIControlStateNormal];
            //修改用户选择的城市
            [Utilities removeUserDefaults:@"UserCity"];
            [Utilities setUserDefaults:@"UserCity" content:cityStr];
            //重新进行网络请求
            //[self networkRequest];
        }else{
            //修改城市按钮标题
            [_endSiteBtn setTitle:cityStr forState:UIControlStateNormal];
            //修改用户选择的城市
            [Utilities removeUserDefaults:@"UserCity"];
            [Utilities setUserDefaults:@"UserCity" content:cityStr];
            //重新进行网络请求
            //[self networkRequest];
        }
    }
}
- (void)anniu{
if(_startSiteBtn.titleLabel.text.length != 0 && _endSiteBtn.titleLabel.text.length != 0 && _priceTextField.text.length != 0 && _companyTextField.text.length != 0 && _flightTextField.text.length != 0 && _placeTextField.text.length != 0 && _takeoffBtn.titleLabel.text.length != 0 && _arriveBtn.titleLabel.text.length != 0 && _kgTextField.text.length != 0 ){
    _confirmBtn.enabled =YES;
    _confirmBtn.backgroundColor = UIColorFromRGB(74, 135, 238);
}else{
    _confirmBtn.enabled =NO;
    _confirmBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
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
//出发地的按钮事件
- (IBAction)startSiteAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 0;
}
//目的地的按钮事件
- (IBAction)endSiteAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
}
//起飞时间的按钮事件
- (IBAction)takeoffTime:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 0;
    _quoteToolbar.hidden = NO;
    _quoteDatePicker.hidden = NO;
    _aviView.hidden = NO;
}
//到达时间的按钮事件
- (IBAction)arriveTime:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    _quoteToolbar.hidden = NO;
    _quoteDatePicker.hidden = NO;
    _aviView.hidden = NO;
}
//确定按钮事件
- (IBAction)confirmAction:(UIButton *)sender forEvent:(UIEvent *)event {
    }
//toolbar上的取消按钮事件
- (IBAction)cancel:(UIBarButtonItem *)sender {
    _aviView.hidden = YES;
    _quoteToolbar.hidden = YES;
    _quoteDatePicker.hidden = YES;
}
//toolbar上的确定按钮事件
- (IBAction)sureAction:(UIBarButtonItem *)sender {
    NSDate *date = _quoteDatePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *theDate = [formatter stringFromDate:date];
    if(flag == 0){
        [_takeoffBtn setTitle:theDate forState:UIControlStateNormal];
    }else{
         [_arriveBtn setTitle:theDate forState:UIControlStateNormal];
    }
    _aviView.hidden = YES;
    _quoteToolbar.hidden = YES;
    _quoteDatePicker.hidden = YES;
}
@end
