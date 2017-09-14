//
//  ReleaseViewController.m
//  BusinessGetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "ReleaseViewController.h"
@interface ReleaseViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger i;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *imgButton;
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
@property (strong, nonatomic) UIImagePickerController *imagePC;//UIImagePickerController是系统提供的用来获取图片和视频的接口
- (IBAction)canceAct:(UIBarButtonItem *)sender;
- (IBAction)determineAct:(UIBarButtonItem *)sender;
- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
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
    [_imgButton addTarget:self action:@selector(avatarAction:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    //注册观察键盘的变化
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

/*//当文本框开始编辑的时候调用
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 50);
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}

//当文本框开始结束编辑的时候调用
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}*/
//移动UIView
- (void)transformView:(NSNotification *)aNSNotification{
    //获取键盘弹出前的Rect
    NSValue *keyBoardBeginBounds = [[aNSNotification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect = [keyBoardBeginBounds CGRectValue];
    //获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds = [[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect = [keyBoardEndBounds CGRectValue];
    //获取键盘位置变化前后纵坐标Y的变化值
    CGFloat deltaY=(endRect.origin.y-beginRect.origin.y)/1.65;
    //NSLog(@"看看这个变化的Y值:%f",deltaY);
    //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _roomNameLab || textField == _breakfastLab || textField == _bedLab|| textField == _areaLab || textField == _priceLab || textField == _premiumLab) {
        [textField resignFirstResponder];
        return YES;
    }
    return YES;
}
//手势的事件，手势添加在根视图上，响应手势后结束根视图编辑状态达到收起键盘的目的
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}
//键盘收回
/*- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [_scrollView endEditing:YES];
}*/
//当选择完媒体文件后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //根据UIImagePickerControllerEditedImage这个键去拿到我们选中的已经编辑过的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //将上面拿到的图片设置为按钮的背景图片
    [_imgButton setBackgroundImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//当进入到媒体文件取消选择后调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //用model的方式返回上一页
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)pickImage:(UIImagePickerControllerSourceType)sourceType {
    NSLog(@"按钮被按了");
    //判断当前选择的图片选择器控制器类型是否可用
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        //神奇的nil
        _imagePC = nil;
        //初始化一个图片选择器控制器对象
        _imagePC = [[UIImagePickerController alloc] init];
        //签协议
        _imagePC.delegate = self;
        //设置图片选择器控制器类型
        _imagePC.sourceType = sourceType;
        //设置选中的媒体文件是否可以被编辑
        _imagePC.allowsEditing = YES;
        //设置可以被选择的媒体文件的类型
        _imagePC.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:_imagePC animated:YES completion:nil];
    } else {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:sourceType == UIImagePickerControllerSourceTypeCamera ? @"您当前的设备没有照相功能" : @"您当前的设备无法打开相册" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:confirmAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

- (void)avatarAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSLog(@"可以开始选取头像了");
    //设置弹话框的样式
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self pickImage:UIImagePickerControllerSourceTypeCamera];//调用摄像头
    }];
    UIAlertAction *choosePhoto = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self pickImage:UIImagePickerControllerSourceTypePhotoLibrary];//调用图片库UIImagePickerControllerSourceTypeSavedPhotosAlbum 则调用iOS设备中的胶卷相机的图片.
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:choosePhoto];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
//设置有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//一列设置多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //NSLog(@"_pickArr = %lu", (unsigned long)_pickArr.count);
    return _hotelMuArr.count;
}
//每行的标题
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //NSLog(@"_pickArr = %lu", (unsigned long)_pickArr.count);
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
        //NSLog(@"sleectresponseObject = %@",responseObject);
                [_avi stopAnimating];
        if([responseObject[@"result"] integerValue] == 1)
        {
            _pickArr = responseObject[@"content"];
            //NSLog(@"_pickArr = %lu", (unsigned long)_pickArr.count);
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
        //NSLog(@"responseObject = %@",responseObject);
        if([responseObject[@"result"] integerValue] == 1)
        {
            [_avi stopAnimating];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜你发布成功!" preferredStyle:UIAlertControllerStyleAlert];
            
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
   if(_roomNameLab.text.length == 0){
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
    }
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


@end
