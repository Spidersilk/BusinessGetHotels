//
//  QuoteViewController.m
//  BusinessGetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Phoenix. All rights reserved.
//


#import "QuoteViewController.h"
#import "QuoteTableViewCell.h"
#import "QuoteModel.h"
@interface QuoteViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger flag;
    NSInteger QuotePageNum;
}


@property (readonly) NSTimeInterval startTime;
@property (readonly) NSTimeInterval endTime;
@property (strong, nonatomic) UIImageView *QuoteNothingImg;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (strong, nonatomic) NSString *thatDate;
@property (strong, nonatomic) NSString *City;
@property (strong, nonatomic) QuoteModel *quotemodel;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (strong, nonatomic) NSMutableArray *Arr;
@property (strong, nonatomic) NSArray *titleArr;
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yPosition;



@end

@implementation QuoteViewController

- (void)viewDidLoad {
    QuotePageNum = 1;
    _endTime = 6505549517000;
    flag = 0;
    _Arr = [NSMutableArray new];
    _titleArr = @[@"选择出发地",@"选择目的地",@"选择起飞日期 时间",@"选择到达日期 时间"];
    //Datepicker设置最小时间
    _quoteDatePicker.minimumDate = [NSDate dateWithHoursFromNow:4];
    [super viewDidLoad];
    [self naviConfing];
    [self initializeData];
    //创建刷新指示器
    UIRefreshControl *ref = [UIRefreshControl new];
    [ref addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    ref.tag = 10005;
    [_quoteTableView addSubview:ref];
    //监听接收城市名
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCityState:) name:@"ResetHome" object:nil];
    //去除底部多余的线
    _quoteTableView.tableFooterView = [UIView new];
}
//将要来到此页面（显示导航栏）
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:0 animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfing {
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _Arr.count;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"quoteCell" forIndexPath:indexPath];
    cell.companyLabel.text = _quotemodel.avition_company;
    cell.flightLabel.text = _quotemodel.flight_no;
    cell.placeLabel.text = _quotemodel.avition_cabin;
    cell.startSiteLabel.text = _aviationmodel.departure;
    cell.endSiteLabel.text = _aviationmodel.destination;
    cell.kgLabel.text = [NSString stringWithFormat:@"%ld",(long)_quotemodel.weight];
    cell.takeoffLabel.text = _takeoffBtn.titleLabel.text;
    cell.arriveLabel.text = _arriveBtn.titleLabel.text;
    cell.priceLabel.text = [NSString stringWithFormat:@"%ld",(long)_quotemodel.final_price];
    return cell;
}
//设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.f;
}
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该消息？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self DeleteNetworkRequest];
            [_quoteTableView reloadData];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
//获取城市名
- (void) checkCityState:(NSNotification *)note {
    NSString *cityStr = note.object;
        if(flag == 0){
                //修改城市按钮标题
                [_startSiteBtn setTitle:cityStr forState:UIControlStateNormal];
                _City = cityStr;
            if(![_startSiteBtn.titleLabel.text isEqualToString:@"选择出发地"]){
                [_startSiteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _startSiteBtn.backgroundColor = [UIColor whiteColor];
            }
        }else{
            if(![_City isEqualToString:cityStr]){
               //修改城市按钮标题
                [_endSiteBtn setTitle:cityStr forState:UIControlStateNormal];
                if(![_endSiteBtn.titleLabel.text isEqualToString:@"选择目的地"]){
                    [_endSiteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    _endSiteBtn.backgroundColor = [UIColor whiteColor];
                }
            }
        }
}
//当TableView没有东西的时候，添加一个图片给它
- (void) nothingForTableView {
    _QuoteNothingImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"no_things"]];
    _QuoteNothingImg.frame = CGRectMake((UI_SCREEN_W-100)/2, 100, 100, 100);
    [_quoteTableView addSubview:_QuoteNothingImg];
}
#pragma mark - 网络请求
- (void)initializeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self refreshPage];
    if (_Arr.count == 0) {
        [self nothingForTableView];
    }else{
        [self refreshPage];
    }
}
//刷新指示器的事件
- (void)refreshPage{
    [self checkNetworkRequest];
}
//执行网络请求
- (void)networkRequest {
    NSInteger price = [[NSString stringWithFormat:@"%@",_priceTextField.text] integerValue];
    NSInteger weight = [[NSString stringWithFormat:@"%@",_kgTextField.text] integerValue];
    //设置接口入参
    NSDictionary *prarmeter = @{@"business_id" : @2,@"aviation_demand_id" : @(_aviationmodel.aviation_demand_id), @"final_price" : @(price), @"weight":@(weight), @"aviation_company" : _companyTextField.text, @"aviation_cabin" : _placeTextField.text, @"in_time_str" : _takeoffBtn.titleLabel.text, @"out_time_str" : _arriveBtn.titleLabel.text,@"departure" : _startSiteBtn.titleLabel.text, @"destination" : _endSiteBtn.titleLabel.text, @"flight_no" : _flightTextField.text};
        //开始请求
        [RequestAPI requestURL:@"/offer_edu" withParameters:prarmeter andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
            //成功以后要做的事情
            [_avi stopAnimating];
            NSLog(@"responseObject = %@",responseObject);
            //[self endAnimation];
            if ([responseObject[@"result"] integerValue] == 1) {
                    [self checkNetworkRequest];
            }else{
                //业务逻辑失败的情况下
                NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
                [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            }
                 } failure:^(NSInteger statusCode, NSError *error) {
            //失败以后要做的事情
            //NSLog(@"statusCode = %ld",(long)statusCode);
            [_avi stopAnimating];
            [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        }];
    }

- (void)checkNetworkRequest {
    //设置接口入参
    NSDictionary *prarmeter = @{@"Id" : @(_aviationmodel.aviation_demand_id)};
    //开始请求
    [RequestAPI requestURL: @"/selectOffer_edu" withParameters:prarmeter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //成功以后要做的事情
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_quoteTableView viewWithTag:10005];
        [ref endRefreshing];
        NSLog(@"haha = %@",responseObject);
        //[self endAnimation];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSDictionary *content = responseObject[@"content"];
            if (QuotePageNum == 1) {
                [_Arr removeAllObjects];
            }
            NSLog(@"数组值：%@",content);
            for(NSDictionary *dict in content){
                _quotemodel = [[QuoteModel alloc]initWhitDictionary:dict];
                [_Arr addObject:_quotemodel];
            }
            //当数组有数据时将图片隐藏，反之隐藏
            if (_Arr.count == 0) {
                _QuoteNothingImg.hidden = NO;
            }else{
                _QuoteNothingImg.hidden = YES;
            }
            [_quoteTableView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_quoteTableView viewWithTag:10005];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}
//删除报价接口
- (void)DeleteNetworkRequest {
    //设置接口入参
    NSDictionary *prarmeter = @{@"Id" : @(_quotemodel.Id)};
    //NSLog(@"id = %ld",(long)_quotemodel.Id);
    //开始请求
    [RequestAPI requestURL: @"/deleteOfferById_edu" withParameters:prarmeter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //成功以后要做的事情
        NSLog(@"delete = %@",responseObject);
        //[self endAnimation];
        if ([responseObject[@"result"] integerValue] == 1) {
            [self checkNetworkRequest];
            [_quoteTableView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}

#pragma mark - 按钮事件
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
    [self layoutConstraints:0];
    [self addTapGestureRecognizer:_aviView];
    [self.view endEditing:YES];
    // [_takeoffBtn addTarget: self action:@selector(hideKeyboard) forControlEvents: UIControlEventTouchUpInside];
}
//到达时间的按钮事件
- (IBAction)arriveTime:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    _aviView.hidden = NO;
    [self layoutConstraints:0];
    [self addTapGestureRecognizer:_aviView];
    [self.view endEditing:YES];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *moDate = [formatter dateFromString:_thatDate];
    _quoteDatePicker.minimumDate = [NSDate dateWithTimeInterval:60*60 sinceDate:moDate];
}

//确定按钮事件
- (IBAction)confirmAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //判断某个字符串中是否每个字符都是数字(invertedSet:反向设置，Digits：数字)
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if([_startSiteBtn.titleLabel.text isEqualToString:@"选择出发地"]){
       [Utilities popUpAlertViewWithMsg:@"请选择出发地" andTitle:nil onView:self];
        return;
    }
    if([_endSiteBtn.titleLabel.text isEqualToString:@"选择目的地"]){
        [Utilities popUpAlertViewWithMsg:@"请选择目的地" andTitle:nil onView:self];
        return;
    }
    if(_priceTextField.text.length == 0 || [_priceTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound){
        [Utilities popUpAlertViewWithMsg:@"请正确填写报价" andTitle:nil onView:self];
        return;
    }
    if(_companyTextField.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请填写航空公司" andTitle:nil onView:self];
        return;
    }
    if(_flightTextField.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请填写航班" andTitle:nil onView:self];
        return;
    }
    if(_placeTextField.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请填写舱位" andTitle:nil onView:self];
        return;
    }
    if([_takeoffBtn.titleLabel.text isEqualToString:@"选择起飞日期 时间"]){
        [Utilities popUpAlertViewWithMsg:@"请选择起飞日期" andTitle:nil onView:self];
        return;
    }
    if([_arriveBtn.titleLabel.text isEqualToString:@"选择到达日期 时间"]){
        [Utilities popUpAlertViewWithMsg:@"请选择到达日期" andTitle:nil onView:self];
        return;
    }
    if(_kgTextField.text.length == 0 || [_kgTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound){
        [Utilities popUpAlertViewWithMsg:@"请正确填写行李重量" andTitle:nil onView:self];
        return;
    }
    [self networkRequest];
    
    //清空文本
    _priceTextField.text = @"";
    _companyTextField.text = @"";
    _flightTextField.text = @"";
    _placeTextField.text = @"";
    _kgTextField.text = @"";
    
    //[_startSiteBtn setTitle:@"选择出发地" forState:UIControlStateNormal];
    [_startSiteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _startSiteBtn.selected = NO;
    //[_endSiteBtn setTitle:@"选择目的地" forState:UIControlStateNormal];
    [_endSiteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _endSiteBtn.selected = NO;
    //[_takeoffBtn setTitle:@"选择起飞日期 时间" forState:UIControlStateNormal];
    [_takeoffBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _takeoffBtn.selected = NO;
    //[_arriveBtn setTitle:@"选择到达日期 时间" forState:UIControlStateNormal];
    [_arriveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _arriveBtn.selected = NO;
    
}

//toolbar上的取消按钮事件
- (IBAction)cancel:(UIBarButtonItem *)sender {
    _aviView.hidden = YES;
    //调用Datepicker动画
    [self layoutConstraints:-260];
    
}
//toolbar上的确定按钮事件
- (IBAction)sureAction:(UIBarButtonItem *)sender {
    NSDate *date = _quoteDatePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *theDate = [formatter stringFromDate:date];
    if(flag == 0){
        //日期转换时间戳
        _startTime = [date timeIntervalSince1970]*1000;
        _thatDate = theDate;
        //设置按钮时间
        [_takeoffBtn setTitle:theDate forState:UIControlStateNormal];
        if (_startTime >= _endTime) {
            //当前时间后推一天
            NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
            NSString *nextdate =[formatter stringFromDate:nextDate];
            //设置按钮时间
            [_arriveBtn setTitle:nextdate forState:UIControlStateNormal];
        }
        
    }else{
        //日期转换时间戳
        _endTime = [date timeIntervalSince1970]*1000;
        //设置按钮时间
        [_arriveBtn setTitle:theDate forState:UIControlStateNormal];
    }
    if(![_takeoffBtn.titleLabel.text isEqualToString:@"选择起飞日期 时间"]){
        [_takeoffBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _takeoffBtn.backgroundColor = [UIColor whiteColor];
    }
    if(![_arriveBtn.titleLabel.text isEqualToString:@"选择到达日期 时间"]){
        [_arriveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _arriveBtn.backgroundColor = [UIColor whiteColor];
    }
    _aviView.hidden = YES;
    [self layoutConstraints:-260];
}
//Datepicker动画
- (void)layoutConstraints:(CGFloat)space {
    CGFloat distance = 0;
    if (space == 0) {
        distance = _yPosition.constant;
    } else {
        distance = 260 - _yPosition.constant;
    }
    //CGFloat percentage = distance / 200.f;
    [UIView animateWithDuration:0.3 animations:^{
        _yPosition.constant = space;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)tapClick: (UITapGestureRecognizer *)tap {
//    if (tap.state == UIGestureRecognizerStateRecognized) {
//        NSLog(@"%@",@"你单击了");
        [self layoutConstraints:-260];
        _aviView.hidden = YES;
//}
}
- (void)addTapGestureRecognizer: (id)any{
    //初始化一个单击手势，设置它的响应事件为tapClick:
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    //用户交互启用
    _aviView.userInteractionEnabled = YES;
    //将手势添加给入参
    [any addGestureRecognizer:tap];
    
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
