//
//  HotelModel.m
//  BusinessGetHotels
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "HotelModel.h"

@implementation HotelModel
- (id)initWhitDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self){
        _business_id = [[Utilities nullAndNilCheck:dict[@"business_id"] replaceBy:0] integerValue];
        _hotelId = [[Utilities nullAndNilCheck:dict[@"id"] replaceBy:0] integerValue];
        _hotel_name = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@""];
        _price = [[Utilities nullAndNilCheck:dict[@"price"] replaceBy:0] integerValue];
        _hotel_type = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@""];
        _imgUrl = [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@""];
                   }
    return self;
}
@end
