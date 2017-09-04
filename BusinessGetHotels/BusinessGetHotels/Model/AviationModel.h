//
//  AviationModel.h
//  BusinessGetHotels
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AviationModel : NSObject
@property (strong, nonatomic) NSString *aviation_demand_title;//航空公司
@property (strong, nonatomic) NSString *departure;//出发地
@property (strong, nonatomic) NSString *destination;//目的地
@property (strong, nonatomic) NSString *low_price;//价格区间前
@property (strong, nonatomic) NSString *high_price;//价格区间后
@property (strong, nonatomic) NSString *aviation_demand_detail;//航空需求细节
@property (nonatomic) NSTimeInterval start_time;//入住时间
@property (nonatomic) NSTimeInterval out_time;//离店时间
@property (strong, nonatomic) NSString *room_img;//房间图片
@property (nonatomic) NSInteger price; //价格
@property (nonatomic) NSInteger longitude;//经度
@property (nonatomic) NSInteger latitude;//纬度
@property (nonatomic) NSInteger hotelID; //酒店id

@property (strong, nonatomic) NSString *hotel_facilitys;//酒店设施
@property (strong, nonatomic) NSString *hotel_types;//房间类型
@property (strong, nonatomic) NSString *remark;
@property (strong, nonatomic) NSString *hotel_imgs;

- (instancetype) initWiihDetailDictionary: (NSDictionary *)dict;
@end
