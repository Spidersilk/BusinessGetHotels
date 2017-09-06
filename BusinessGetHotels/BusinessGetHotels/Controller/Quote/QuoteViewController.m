//
//  QuoteViewController.m
//  BusinessGetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "QuoteViewController.h"
#import "QuoteTableViewCell.h"
@interface QuoteViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger flag;
}
@property (weak, nonatomic) IBOutlet UIView *DatepickView;
@property (strong, nonatomic) NSMutableArray *Arr;
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
    //[self anniu];
    // Do any additional setup after loading the view.
//    _confirmBtn.enabled = NO;
//    _confirmBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
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
#pragma mark - tableview
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"quoteCell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    //NSDictionary *dict = _Arr[indexPath.row];
    
    return cell;
}
//设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130.f;
}
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //WS(weakself);
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该消息？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //[[_quoteTableView deleteRowsAtIndexPaths:@[indexPath]  removeObjectAtIndex:indexPath.row];
            /**   点击 删除 按钮的操作 */
            if (editingStyle == UITableViewCellEditingStyleDelete) { /**< 判断编辑状态是删除时. */
                
                /** 1. 更新数据源(数组): 根据indexPaht.row作为数组下标, 从数组中删除数据. */
                [self.Arr removeObjectAtIndex:indexPath.row];
                
                /** 2. TableView中 删除一个cell. */
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            }
            // [tableView deleteRowsAtIndexPaths:@[indexPath]  MessageModel *model = weakself.dataArray[indexPath.row];
            //[weakself singleDelet:model.mid];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
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
        }
        //if([_startSiteBtn.titleLabel.text isEqualToString:_endSiteBtn.titleLabel.text])
    }
}

//- (void)anniu{
//if(_startSiteBtn.titleLabel.text.length != 0 && _endSiteBtn.titleLabel.text.length != 0 && _priceTextField.text.length != 0 && _companyTextField.text.length != 0 && _flightTextField.text.length != 0 && _placeTextField.text.length != 0 && _takeoffBtn.titleLabel.text.length != 0 && _arriveBtn.titleLabel.text.length != 0 && _kgTextField.text.length != 0 ){
//    _confirmBtn.enabled =YES;
//    _confirmBtn.backgroundColor = UIColorFromRGB(74, 135, 238);
//}else{
//    _confirmBtn.enabled =NO;
//    _confirmBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
//}
//}
/*#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//执行网络请求
- (void)networkRequest {
    NSInteger price = [[NSString stringWithFormat:@"%@",_priceTextField.text] integerValue];
    NSInteger weight = [[NSString stringWithFormat:@"%@",_kgTextField.text] integerValue];
    //设置接口入参
    NSDictionary *prarmeter = @{@"business_id" : @2,@"aviation_demand_id" : @1, @"final_price" : @(price), @"weight":@(weight), @"aviation_company" : _companyTextField.text, @"aviation_cabin" : _placeTextField.text, @"in_time_str" : _takeoffBtn.titleLabel.text, @"out_time_str" : _arriveBtn.titleLabel.text,@"departure" : _startSiteBtn.titleLabel.text, @"destination" : _endSiteBtn.titleLabel.text, @"flight_no" : _flightTextField.text};
        //开始请求
        [RequestAPI requestURL:@"/offer_edu" withParameters:prarmeter andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
            //成功以后要做的事情
            NSLog(@"responseObject = %@",responseObject);
            //[self endAnimation];
            if ([responseObject[@"result"] integerValue] == 1) {
               
            }else{
                //业务逻辑失败的情况下
                NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
                [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            }
                 } failure:^(NSInteger statusCode, NSError *error) {
            //失败以后要做的事情
            //NSLog(@"statusCode = %ld",(long)statusCode);
            //[self endAnimation];
            [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        }];
    }
         

//出发地的按钮事件
- (IBAction)startSiteAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 0;
    [self performSegueWithIdentifier:@"QuoteToCity" sender:self];
}
//目的地的按钮事件
- (IBAction)endSiteAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    [self performSegueWithIdentifier:@"QuoteToCity" sender:self];
}
//起飞时间的按钮事件
- (IBAction)takeoffTime:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 0;
    _aviView.hidden = NO;
    _DatepickView.hidden = NO;
    _quoteToolbar.hidden = NO;
    _quoteDatePicker.hidden = NO;
}
//到达时间的按钮事件
- (IBAction)arriveTime:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    _aviView.hidden = NO;
    _DatepickView.hidden = NO;
    _quoteToolbar.hidden = NO;
    _quoteDatePicker.hidden = NO;
}
//确定按钮事件
- (IBAction)confirmAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self networkRequest];
    }
//toolbar上的取消按钮事件
- (IBAction)cancel:(UIBarButtonItem *)sender {
    _aviView.hidden = YES;
    _DatepickView.hidden = YES;
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
    _DatepickView.hidden = YES;
    _quoteToolbar.hidden = YES;
    _quoteDatePicker.hidden = YES;
}
#pragma mark - 键盘收起
//按键盘上的Return键收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _priceTextField || textField == _companyTextField || textField == _flightTextField || textField == _placeTextField || textField == _kgTextField){
        [textField resignFirstResponder];
    }
    return YES;
}
//键盘收回
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}

@end
