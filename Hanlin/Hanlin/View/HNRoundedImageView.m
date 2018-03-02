//
//  HNRoundeImageView.m
//  Hanlin
//
//  Created by Selvam M on 1/27/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import "HNRoundedImageView.h"

@implementation HNRoundedImageView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.masksToBounds = self.masksToBounds;
}


@end
