//
//  QuoteModel.m
//  BusinessGetHotels
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "QuoteModel.h"

@implementation QuoteModel
- (id) initWhitDictionary: (NSDictionary *)dict{
    self = [super init];//self调用者本身
    if (self){
        _avition_cabin = [Utilities nullAndNilCheck:dict[@"avition_cabin"] replaceBy:@""];
        _avition_company = [Utilities nullAndNilCheck:dict[@"avition_company"] replaceBy:@""];
        _avition_demand_id = [[Utilities nullAndNilCheck:dict[@"avition_demand_id"] replaceBy:0] integerValue];
        _business_id =[[Utilities nullAndNilCheck:dict[@"business_id"] replaceBy:0] integerValue];
        _departure = [Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@""];
        _destination = [Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@""];
        _final_price = [[Utilities nullAndNilCheck:dict[@"final_price"] replaceBy:0] integerValue];
        _flight_no = [Utilities nullAndNilCheck:dict[@"flight_no"] replaceBy:@""];
        _weight = [[Utilities nullAndNilCheck:dict[@"weight"] replaceBy:0] integerValue];
        _in_time_str = [Utilities nullAndNilCheck:dict[@"in_time_str"] replaceBy:@""];
        _out_time_str = [Utilities nullAndNilCheck:dict[@"out_time_str"] replaceBy:@""];
        
    }
    return self;
}@end
