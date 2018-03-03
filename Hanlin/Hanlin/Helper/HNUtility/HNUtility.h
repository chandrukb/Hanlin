//
//  HNUtility.h
//  Hanlin
//
//  Created by Selvam M on 1/25/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HNUtility : NSObject
//-(void)addShadowToView:(UIView *) inView;
+ (NSMutableArray *)getDatesBetweenTwoDates:(NSDate *)startDate :(NSDate *)endDate;
+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
+(BOOL)checkIfInternetIsAvailable;
@end
