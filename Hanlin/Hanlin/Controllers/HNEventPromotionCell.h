//
//  HNEventPromotionCell.h
//  Hanlin
//
//  Created by Balachandran on 30/01/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNRoundedImageView.h"

@interface HNEventPromotionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet HNRoundedImageView *ivEventPromo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end
