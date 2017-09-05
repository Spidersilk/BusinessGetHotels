//
//  HotelTableViewCell.h
//  BusinessGetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hotelNameLab;
@property (weak, nonatomic) IBOutlet UILabel *breakfastLab;
@property (weak, nonatomic) IBOutlet UILabel *bedTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIImageView *hotelImage;
@end
