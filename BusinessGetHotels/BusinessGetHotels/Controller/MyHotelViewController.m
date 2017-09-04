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
- (IBAction)btnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation MyHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    _myHotelTabelView.tableFooterView = [UIView new];
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
}

//这个方法专门做导航条的控制
- (void)naviConfig{

}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
    cell.hotelNameLab.text = @"无锡大酒店";
    cell.breakfastLab.text = @"描述: 含早 大床";
    cell.areaLab.text = @"108平米";
    cell.priceLab.text = @"价格¥:888";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //当前的编辑是否属于删除行为
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //要删除cell必须先删除表格视图对应的数据中这一行的数据内容
        //[self deleteDataAtIndexPath:indexPath];
        //[_tableArray removeObjectAtIndex:indexPath.row];
        //删除界面上的cell
        //[tableView deleteSections:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}
/*
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        
    }];
    
    //    rowActionSec.backgroundColor = [UIColor colorWithHexString:@"f38202"];
    rowAction.backgroundColor = [UIColor purpleColor];
    
    UITableViewRowAction *rowaction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    rowaction.backgroundColor = [UIColor grayColor];
    NSArray *arr = @[rowAction,rowaction];
    return arr;
}*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    ReleaseViewController *release = [Utilities getStoryboardInstance:@"HotelIssued" byIdentity:@"Release"];
    [self.navigationController pushViewController:release animated:YES];
}
@end
