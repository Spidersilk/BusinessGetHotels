//
//  ExpireTableViewCell.h
//  BusinessGetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpireTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *expireImgView;
@property (weak, nonatomic) IBOutlet UILabel *datesLbl;//过期起飞时间
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;//城市to城市
@property (weak, nonatomic) IBOutlet UILabel *ticketLbl;//机票
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;//价格区间
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;//价格在多少
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;//入住时间
@property (weak, nonatomic) IBOutlet UILabel *expireLbl;//过期
@end
