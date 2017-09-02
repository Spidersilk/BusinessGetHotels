//
//  CanQuoteTableViewCell.h
//  BusinessGetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CanQuoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *datesLbl;//起飞时间
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;//城市to城市
@property (weak, nonatomic) IBOutlet UILabel *ticketLbl;//机票
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;//价格区间
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;//价格在多少
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;//入住时间
@property (weak, nonatomic) IBOutlet UILabel *cabinLbl;//机舱
@end
