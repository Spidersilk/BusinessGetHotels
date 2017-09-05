//
//  MyHotelViewController.m
//  BusinessGetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "MyHotelViewController.h"
#import "HotelTableViewCell.h"
#import "ReleaseViewController.h"
@interface MyHotelViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myHotelTabelView;
@property (weak, nonatomic) IBOutlet UIView *naivView;
@property (strong, nonatomic) NSMutableArray *tableArray;
- (IBAction)btnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation MyHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myHotelTabelView.tableFooterView = [UIView new];
    _tableArray = [NSMutableArray new];
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    NSDictionary *dict = @{@"name" :[Utilities nullAndNilCheck:[[StorageMgr singletonStorageMgr] objectForKey:@"roomName"] replaceBy:@"无锡大酒店"] ,@"breakfast" :[Utilities nullAndNilCheck:[[StorageMgr singletonStorageMgr] objectForKey:@"breakfast"] replaceBy:@"含早"] , @"describe" : [Utilities nullAndNilCheck:[[StorageMgr singletonStorageMgr] objectForKey:@"bed"] replaceBy:@"大床房"], @"area" : [Utilities nullAndNilCheck:[[StorageMgr singletonStorageMgr] objectForKey:@"area"] replaceBy:@"平方:108平米"], @"price" : [Utilities nullAndNilCheck:[[StorageMgr singletonStorageMgr] objectForKey:@"price"] replaceBy:@"¥888"], @"hotelImage" : @"hotels"};
    _tableArray = [NSMutableArray arrayWithObjects:dict,dict,dict,dict,dict,nil];
    [_myHotelTabelView reloadData];
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
    
    //[_tableArray addObject:dict];
    //cell.hotelNameLabel.text = _tableArray[indexPath.row][@"name"];
    cell.hotelNameLab.text = _tableArray[indexPath.row][@"name"];
    cell.breakfastLab.text = _tableArray[indexPath.row][@"breakfast"];
    cell.bedTypeLab.text = _tableArray[indexPath.row][@"describe"];
    cell.areaLab.text = _tableArray[indexPath.row][@"area"];
    cell.priceLab.text = _tableArray[indexPath.row][@"price"];
    cell.hotelImage.image = [UIImage imageNamed:_tableArray[indexPath.row][@"hotelImage"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//编辑类型
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该条发布？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_tableArray removeObjectAtIndex:indexPath.row];//删除数据
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];//删除行cell
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)btnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    ReleaseViewController *release = [Utilities getStoryboardInstance:@"HotelIssued" byIdentity:@"Release"];
    [self.navigationController pushViewController:release animated:YES];
}
@end
