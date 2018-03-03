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
+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
+(BOOL)checkIfInternetIsAvailable;
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(nullable id)delegate cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSArray *) otherButtons;
+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message inViewController:(UIViewController *)inVC cancelButtonTitle:(NSString *)cancelTitle;
+(void) saveLoginDetailsToPersistance:(NSDictionary *)userDetails;
@end
