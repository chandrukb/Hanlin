//
//  HNRoundeImageView.h
//  Hanlin
//
//  Created by Selvam M on 1/27/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface HNRoundedImageView : UIImageView

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable BOOL masksToBounds;

@end
