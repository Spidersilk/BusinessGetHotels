//
//  HotelModel.h
//  BusinessGetHotels
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelModel : NSObject
@property (strong, nonatomic) NSString *hotel_name;
@property (nonatomic) NSInteger price;
@property (nonatomic) NSInteger business_id;
@property (nonatomic) NSInteger hotelId;
@property (strong, nonatomic) NSString *hotel_type;
@property (strong, nonatomic) NSString *imgUrl;
- (id) initWhitDictionary: (NSDictionary *)dict;
@end
