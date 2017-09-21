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
#import "HotelModel.h"
#import <sqlite3.h>
@interface MyHotelViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger i;
}
@property (weak, nonatomic) IBOutlet UITableView *myHotelTabelView;
@property (weak, nonatomic) IBOutlet UIView *naivView;
@property (strong, nonatomic) NSMutableArray *nsmArr;
@property (strong, nonatomic) NSMutableArray *nsmArrType;
@property (strong, nonatomic) NSMutableArray *arr;
@property (strong, nonatomic) NSArray *arrType;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
- (IBAction)btnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation MyHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    i = 1;
    [self initializeData];
    
    [self setRefreshControl];
    //[self deleteRequest];
    _myHotelTabelView.tableFooterView = [UIView new];
   _nsmArr = [NSMutableArray new];
    _nsmArrType = [NSMutableArray new];
    _arr = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acquireRef) name:@"AlipayResult" object:nil];
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
//- (void)purchaseResultAction{
//    [_nsmArr removeAllObjects];
//    [self netRequest];
//}
//下拉刷新
- (void)setRefreshControl{
     UIRefreshControl *acquireRef = [UIRefreshControl new];
    [acquireRef addTarget:self action:@selector(acquireRef) forControlEvents:UIControlEventValueChanged];
    acquireRef.tag = 10001;
    [_myHotelTabelView addSubview:acquireRef];
}
- (void)acquireRef{
    i = 1;
    [self netRequest];
}
- (void)initializeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self netRequest];
}
- (void)netRequest{
    NSDictionary *para = @{@"business_id" : @1};
    [RequestAPI requestURL:@"/findHotelBySelf" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        //NSLog(@"responseObject = %@",responseObject);
        UIRefreshControl *ref = (UIRefreshControl *)[_myHotelTabelView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"result"] integerValue] == 1)
        {
            [_avi stopAnimating];
            _arr = responseObject[@"content"];
            //NSLog(@"%@",arr);
            if (i == 1) {
                [_nsmArr removeAllObjects];
                [_nsmArrType removeAllObjects];
            }
            for(NSDictionary *dict in _arr){
                //NSLog(@"dict = %@",dict);
                HotelModel *hotelModel = [[HotelModel alloc]initWhitDictionary:dict];
                [_nsmArr addObject:hotelModel];
                NSString *roomInfoJSONStr = dict[@"hotel_type"];
                id roomInfoObj = [roomInfoJSONStr JSONCol];
                [_nsmArrType addObject:roomInfoObj];
            }
             [_myHotelTabelView reloadData];
        }else{
            [_avi stopAnimating];
            [Utilities popUpAlertViewWithMsg:@"请求发生了错误，请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
            }];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_myHotelTabelView viewWithTag:10004];
        [ref endRefreshing];
        [Utilities forceLogoutCheck:statusCode fromViewController:self];

    }];
}
- (void)deleteRequest:(NSIndexPath *)indexPath {
    _avi = [Utilities getCoverOnView:self.view];
    HotelModel *hotelModel = _nsmArr[indexPath.row];
    NSDictionary *dict = @{@"id" : @(hotelModel.hotelId)};
    //NSLog(@"%ld",(long)hotelModel.hotelId);
    [RequestAPI requestURL:@"/deleteHotel" withParameters:dict andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //NSLog(@"delete responseObject = %@",responseObject);
        if([responseObject[@"result"] integerValue] == 1){
            [_avi stopAnimating];
           //[_myHotelTabelView reloadData];
            [self netRequest];
        }else{
            [_avi stopAnimating];
       }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities forceLogoutCheck:statusCode fromViewController:self];
    }];
}
#pragma mark - tableView
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return _nsmArr.count;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"_nsmArr.count = %lu",(unsigned long)_nsmArr.count);
    return _nsmArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *userAgent = @"";
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    

    
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
    HotelModel *hotelModel = _nsmArr[indexPath.row];
    //hotelModel = _nsmArr[indexPath.row];
    //NSLog(@"_nsmArrType = %@",_nsmArrType);
    NSArray *arrType = _nsmArrType[indexPath.row];
    NSLog(@"arrType = %@",arrType);
    //for(_arrType in _nsmArrType){
        NSLog(@"_ArrType = %@",_arrType);
    if(arrType.count == 4){
                cell.breakfastLab.text = arrType[1];
                cell.bedTypeLab.text = arrType[2];
                cell.areaLab.text = arrType[3];
        }
    
    //}
    NSURL *URL = [NSURL URLWithString:hotelModel.imgUrl];
    cell.hotelNameLab.text = hotelModel.hotel_name;
    cell.priceLab.text =  [NSString stringWithFormat:@"¥%ld",(long)hotelModel.price];
     [cell.hotelImage sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"hotelImage"]];
    //cell.hotelImage.image = [UIImage imageNamed:_tableArray[indexPath.row][@"hotelImage"]];
    //设置Cell的动画效果为3D效果
    //设置x和y的初始值为0.1；
    cell.layer.transform = CATransform3DMakeScale(0.6, 0.6, 1);
    //x和y的最终值为1
    [UIView animateWithDuration:1 animations:^{
    cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
    return cell;
}
//细胞将要出现时调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置Cell的动画效果为3D效果
    //设置x和y的初始值为0.1；
    //cell.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1);
    //x和y的最终值为1
    //[UIView animateWithDuration:1 animations:^{
    //cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    //}];
//     if(indexPath.row == _nsmArr.count - 1)
//     {
//       i ++;
//     [self netRequest];
//     }
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
            [self deleteRequest:indexPath];
            //[_nsmArr removeObjectAtIndex:indexPath.row];//删除数据
            //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];//删除行cell
            //[self netRequest];
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
