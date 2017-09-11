//
//  ReleaseViewController.m
//  BusinessGetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "ReleaseViewController.h"

@interface ReleaseViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger i;
}
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
- (IBAction)selectAct:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITextField *roomNameLab;
@property (weak, nonatomic) IBOutlet UITextField *breakfastLab;
@property (weak, nonatomic) IBOutlet UITextField *bedLab;
@property (weak, nonatomic) IBOutlet UITextField *areaLab;
@property (weak, nonatomic) IBOutlet UITextField *priceLab;
@property (weak, nonatomic) IBOutlet UITextField *premiumLab;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) NSArray *pickArr;
@property (strong, nonatomic) NSMutableArray *hotelMuArr;
- (IBAction)canceAct:(UIBarButtonItem *)sender;
- (IBAction)determineAct:(UIBarButtonItem *)sender;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;

    _hotelMuArr = [NSMutableArray new];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self uilayout];
    i = 1;
    [self selectnetRequest];
    //刷新第1列
    [_pickerView reloadComponent:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
//设置有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//一列设置多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSLog(@"_pickArr = %lu", (unsigned long)_pickArr.count);
    return _hotelMuArr.count;
}
//每行的标题
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSLog(@"_pickArr = %lu", (unsigned long)_pickArr.count);
  //  i = 1;
    return _hotelMuArr[row];
}
- (void)naviConfig{
    //设置导航栏标题文字
    self.navigationItem.title = @"酒店发布";
    //设置导航条的风格颜色
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(75, 139, 246);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条按钮的分格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //是否需要毛玻璃的效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航条右上角创建一个按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(payAction)];
    self.navigationItem.rightBarButtonItem = right;
    //导航栏的返回按钮只保留那个箭头，去掉后边的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}
- (void)uilayout{
    //设置按钮的边框
    [_selectBtn.layer setMasksToBounds:YES];
    [_selectBtn.layer setBorderWidth:0.7];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 75/255.0, 139/255.0, 246/255.0, 1 });
    [_selectBtn.layer setBorderColor:colorref];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//选择酒店网络接口
- (void)selectnetRequest{
    _avi = [Utilities getCoverOnView:self.view];
            [RequestAPI requestURL:@"/searchHotelName" withParameters:nil andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"sleectresponseObject = %@",responseObject);
                [_avi stopAnimating];
        if([responseObject[@"result"] integerValue] == 1)
        {
            _pickArr = responseObject[@"content"];
            NSLog(@"_pickArr = %lu", (unsigned long)_pickArr.count);
            for(NSDictionary *dict in _pickArr){
                NSString *str = dict[@"hotel_name"];
                [_hotelMuArr addObject:str];
            }
            [_pickerView reloadAllComponents];

        }else{
            [_avi stopAnimating];
            [Utilities popUpAlertViewWithMsg:@"请求发生了错误，请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
            }];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities forceLogoutCheck:statusCode fromViewController:self];
        
    }];
//    i ++;
}

- (void)netRequest{
     NSURL *URL = [NSURL URLWithString:@"http://img5.imgtn.bdimg.com/it/u=1934652595,421345666&fm=23&gp=0.jpg"];
    NSString *str = [NSString stringWithFormat:@"%@", URL];
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para = @{@"business_id" : @1,@"hotel_name" : _selectBtn.titleLabel.text,@"hotel_type" : [NSString stringWithFormat:@"%@,%@,%@", _breakfastLab.text,_bedLab.text,_areaLab.text],@"room_imgs" : str,@"price" : _priceLab.text};
    [RequestAPI requestURL:@"/addHotel" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if([responseObject[@"result"] integerValue] == 1)
        {
            [_avi stopAnimating];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该条发布？" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:NO];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [_avi stopAnimating];
            [Utilities popUpAlertViewWithMsg:@"请求发生了错误，请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
            }];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities forceLogoutCheck:statusCode fromViewController:self];
        
    }];

}
- (void)payAction{
   /* if(_roomNameLab.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请填写房间名称" andTitle:nil onView:self];
        return;
    }
    if(_breakfastLab.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请填写是否含早" andTitle:nil onView:self onCompletion:^{
        }];
        return;
    }
    if(_bedLab.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请填写床型" andTitle:nil onView:self onCompletion:^{
        }];
        return;
    }
    if(_areaLab.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请填写房间面积" andTitle:nil onView:self onCompletion:^{
        }];
        return;
    }
    if(_priceLab.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请填写价格" andTitle:nil onView:self onCompletion:^{
        }];
        return;
    }
    if(_premiumLab.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请填写周末节假日加价" andTitle:nil onView:self onCompletion:^{
        }];
        return;
    }
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if( [_priceLab.text rangeOfCharacterFromSet:notDigits].location != NSNotFound){
        [Utilities popUpAlertViewWithMsg:@"请设置正确的价格" andTitle:nil onView:self];
        return;
    }*/
    [self netRequest];
}
- (IBAction)canceAct:(UIBarButtonItem *)sender {
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}

- (IBAction)determineAct:(UIBarButtonItem *)sender {
    //拿到某一列选中的行号
    NSInteger row = [_pickerView selectedRowInComponent:0];
    //根据上面拿到的行号,找到对应得数据（选中行的标题）
    NSString *title = _hotelMuArr[row];
    //NSInteger rowSecond = [_pickerView selectedRowInComponent:1];
    //NSString *str = [NSString initWithFormat:@"%@%@",title,titleSecond];
    [_selectBtn setTitle:title forState:UIControlStateNormal];
    _selectBtn.titleLabel.text = title;
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}
- (IBAction)selectAct:(UIButton *)sender forEvent:(UIEvent *)event {
    _toolBar.hidden = NO;
    _pickerView.hidden = NO;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _roomNameLab || textField == _breakfastLab || textField == _bedLab|| textField == _areaLab || textField == _priceLab || textField == _premiumLab) {
        [textField resignFirstResponder];
        return YES;
    }
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}
@end
