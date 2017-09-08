//
//  QuoteModel.h
//  BusinessGetHotels
//
//  Created by admin on 2017/9/8.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuoteModel : NSObject
@property (strong, nonatomic) NSString *avition_cabin;//舱位
@property (strong, nonatomic) NSString *avition_company;//航空公司
@property (nonatomic) NSInteger avition_demand_id; //航空需求id
@property (nonatomic) NSInteger business_id;//商家ID
@property (strong, nonatomic) NSString *departure; //出发地
@property (strong, nonatomic) NSString *destination;//到达地
@property (nonatomic) NSInteger final_price;//价格
@property (strong, nonatomic) NSString *flight_no;//航班号
@property (nonatomic) NSInteger weight;//重量
@property (strong, nonatomic) NSString *in_time_str;//出发时间
@property (strong, nonatomic) NSString *out_time_str;//到达时间
- (id) initWhitDictionary: (NSDictionary *)dict;
@end
