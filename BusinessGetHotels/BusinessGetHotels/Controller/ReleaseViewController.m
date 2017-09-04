//
//  ReleaseViewController.m
//  BusinessGetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "ReleaseViewController.h"

@interface ReleaseViewController ()
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
- (IBAction)canceAct:(UIBarButtonItem *)sender;
- (IBAction)determineAct:(UIBarButtonItem *)sender;

@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self uilayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
- (void)payAction{
    
}
- (IBAction)canceAct:(UIBarButtonItem *)sender {
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}

- (IBAction)determineAct:(UIBarButtonItem *)sender {
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}
- (IBAction)selectAct:(UIButton *)sender forEvent:(UIEvent *)event {
    _toolBar.hidden = NO;
    _pickerView.hidden = NO;
}
@end