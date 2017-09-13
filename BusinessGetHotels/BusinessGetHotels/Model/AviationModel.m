//
//  AviationModel.m
//  BusinessGetHotels
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "AviationModel.h"

@implementation AviationModel
- (instancetype) initWiihDetailDictionary: (NSDictionary *)dict {
   
    self = [super init];//self调用者本身
    if (self){
        _aviation_demand_title = [Utilities nullAndNilCheck:dict[@"aviation_demand_title"] replaceBy:@"航空公司"];//航空公司
        _departure = [Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@"出发地"];//出发地
        _destination = [Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@"目的地"];//目的地
        _low_price = [Utilities nullAndNilCheck:dict[@"low_price"] replaceBy:@""];//价格区间前
        _high_price = [Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:@""];//价格区间后
        _aviation_demand_detail = [Utilities nullAndNilCheck:dict[@"aviation_demand_detail"] replaceBy:@""];//航空需求
        _start_time_str = [Utilities nullAndNilCheck:dict[@"start_time_str"] replaceBy:@""];////2017-05-08 13:07:52
        _start_time = [dict[@"start_time"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 :(NSTimeInterval)[dict[@"start_time"] integerValue];
        _aviation_demand_id = [[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@""] integerValue];
    }
    return self;
}
- (instancetype) initWithDetailDictionary: (NSDictionary *)dict {
    self = [super init];//self调用者本身
    if (self){
        _aviation_demand_title = [Utilities nullAndNilCheck:dict[@"aviation_demand_title"] replaceBy:@"航空公司"];//航空公司
        _departure = [Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@"出发地"];//出发地
        _destination = [Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@"目的地"];//目的地
        _low_price = [Utilities nullAndNilCheck:dict[@"low_price"] replaceBy:@""];//价格区间前
        _high_price = [Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:@""];//价格区间后
        _aviation_demand_detail = [Utilities nullAndNilCheck:dict[@"aviation_demand_detail"] replaceBy:@""];//航空需求
        _start_time_str = [Utilities nullAndNilCheck:dict[@"start_time_str"] replaceBy:@""];////2017-05-08 13:07:52
        _start_time = [dict[@"start_time"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 :(NSTimeInterval)[dict[@"start_time"] integerValue];
    }
    return self;
}
@end
