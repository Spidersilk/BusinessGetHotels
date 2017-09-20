//
//  CityTableViewController.m
//  BusinessGetHotels
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "CityTableViewController.h"
#import "AirfieldTableViewController.h"

@interface CityTableViewController ()
@property (strong, nonatomic) NSDictionary *cities;
@property (strong, nonatomic) NSArray *keys;
@end

@implementation CityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInitialize];
    [self naviConfig];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条的标题
    self.navigationItem.title = @"选择城市";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(75, 135, 246);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
   self.navigationItem.leftBarButtonItem = left;
   
}
//用model的方式返回上一页
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];//用push返回上一页
}
- (void) dataInitialize {
    //创建文件管理器
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //获取要获取的文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"airfield" ofType:@"plist"];
    //判断路径下是否存在文件
    if ([fileMgr fileExistsAtPath:filePath]) {
        //将文件内容读取为对应文件
        NSDictionary *fileContent = [NSDictionary dictionaryWithContentsOfFile:filePath];
        //判断读取到的内容是否存在（判断文件是否损坏）
        if (fileContent) {
            NSLog(@"fileContent:%@",fileContent);
            _cities = fileContent;
            //获取字典所有的键
            NSArray *rawKeys = [fileContent allKeys];
            //根据拼音首字母进行能够识别多音字的升序排序（localizedStandardCompare很棒的一个方法）
            _keys = [rawKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
        }
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"这是数组的长度：%lu",(unsigned long)_keys.count);
    return _keys.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell" forIndexPath:indexPath];
    //获取当前正在渲染的组的名称
    NSString *key = _keys[indexPath.row];
    cell.textLabel.text =key;
    return cell;
}
//设置组的头标题文字
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 //   return _keys[section];
//}
//设置section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}
//按住细胞以后（取消选择）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    //获取当前正在渲染的组的名称
//    NSString *key = _keys[indexPath.section];
//    //根据组的名称作为键，来查询到对应的值（这个值就是这一市数组）
//    NSArray *sectionCities = _cities[key];
//    NSDictionary *city = sectionCities[indexPath.row];
    
    //[self dismissViewControllerAnimated:NO completion:nil];
    
     AirfieldTableViewController *quoteVC = [Utilities getStoryboardInstance:@"Quote" byIdentity:@"Air"];
    //将每组的数据给model，传入下一页
    NSString *keys = _keys[indexPath.row];
    quoteVC.key = keys;
    [self.navigationController pushViewController:quoteVC animated:NO];
}
////设置右侧快捷键的栏
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return _keys;
//}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
////#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
////#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (IBAction)CityAction:(UIButton *)sender forEvent:(UIEvent *)event {
   // NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
    //NSNotification *note = [NSNotification notificationWithName:@"ResetHome" object:[[StorageMgr singletonStorageMgr] objectForKey:@"LocCity"]];
    //[noteCenter postNotification:note];
    //结合线程的通知，表示先让通知接收者完成它收到通知要做的事以后再执行别的任务
    //[noteCenter performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
    //返回上一页
   // [self dismissViewControllerAnimated:YES completion:nil];
//}
@end
