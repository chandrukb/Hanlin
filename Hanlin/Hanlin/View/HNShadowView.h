//
//  HNShadowView.h
//  Hanlin
//
//  Created by Balachandran on 29/01/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface HNShadowView : UIView
    @property (nonatomic) IBInspectable CGSize shadowOffset;
    @property (nonatomic) IBInspectable UIColor *shadowColor;
    @property (nonatomic) IBInspectable CGFloat shadowRadius;
    @property(nonatomic) IBInspectable float shadowOpacity;
@end
