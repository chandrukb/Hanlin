//
//  HNShadowView.m
//  Hanlin
//
//  Created by Balachandran on 29/01/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNShadowView.h"

@implementation HNShadowView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.shadowOffset = self.shadowOffset;
    self.layer.shadowColor = self.shadowColor.CGColor;
    self.layer.shadowRadius = self.shadowRadius;
    self.layer.shadowOpacity = self.shadowOpacity;
}


@end
