//
//  QuoteViewController.m
//  BusinessGetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "QuoteViewController.h"

@interface QuoteViewController ()
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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _confirmBtn.enabled = NO;
    _confirmBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}
//目的地的按钮事件
- (IBAction)endSiteAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
//起飞时间的按钮事件
- (IBAction)takeoffTime:(UIButton *)sender forEvent:(UIEvent *)event {
    _quoteToolbar.hidden = NO;
    _quoteDatePicker.hidden = NO;
}
//到达时间的按钮事件
- (IBAction)arriveTime:(UIButton *)sender forEvent:(UIEvent *)event {
    _quoteToolbar.hidden = NO;
    _quoteDatePicker.hidden = NO;
}
//确定按钮事件
- (IBAction)confirmAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if(_startSiteBtn.titleLabel.text.length != 0 && _endSiteBtn.titleLabel.text.length != 0 && _priceTextField.text.length != 0 && _companyTextField.text.length != 0 && _flightTextField.text.length != 0 && _placeTextField.text.length != 0 && _takeoffBtn.titleLabel.text.length != 0 && _arriveBtn.titleLabel.text.length != 0 && _kgTextField.text.length != 0 ){
        _confirmBtn.enabled =YES;
        _confirmBtn.backgroundColor = UIColorFromRGB(74, 135, 238);
    }else{
        _confirmBtn.enabled =NO;
        _confirmBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
    }
}
//toolbar上的取消按钮事件
- (IBAction)cancel:(UIBarButtonItem *)sender {
    _quoteToolbar.hidden = YES;
    _quoteDatePicker.hidden = YES;
}
//toolbar上的确定按钮事件
- (IBAction)sureAction:(UIBarButtonItem *)sender {
    _quoteToolbar.hidden = YES;
    _quoteDatePicker.hidden = YES;
}
@end
