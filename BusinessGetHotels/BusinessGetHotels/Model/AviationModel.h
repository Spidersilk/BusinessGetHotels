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
@property (strong, nonatomic) NSString *start_time_str;//2017-05-08 13:07:52
@property (nonatomic) NSTimeInterval start_time; //开始时间


- (instancetype) initWiihDetailDictionary: (NSDictionary *)dict;
- (instancetype) initWithDetailDictionary: (NSDictionary *)dict;
@end
