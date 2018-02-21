//
//  HNUtility.m
//  Hanlin
//
//  Created by Selvam M on 1/25/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import "HNUtility.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "HNConstants.h"

@implementation HNUtility

//-(void)addShadowToView:(UIView *) inView
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:inView.bounds];
//    view.layer.masksToBounds = NO;
//    view.layer.shadowColor = [UIColor blackColor].CGColor;
//    view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
//    view.layer.shadowOpacity = 0.5f;
//    view.layer.shadowPath = shadowPath.CGPath;
//}

+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress {
    
    //Create a regex string
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    
    //Create predicate with format matching your regex string
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:
                              @"SELF MATCHES %@", stricterFilterString];
    
    //return true if email address is valid
    return [emailTest evaluateWithObject:emailAddress];
}

// Using NSRegularExpression

+ (BOOL) isValidEmail:(NSString*) emailAddress {
    
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc]
                                  initWithPattern:regExPattern
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailAddress
                                                     options:0
                                                       range:NSMakeRange(0, [emailAddress length])];
    return (regExMatches == 0) ? NO : YES ;
}


//+(BOOL)checkIfInternetIsAvailable
//{
//    BOOL reachable = NO;
//    NetworkStatus netStatus = [HN_APP_DELEGATE.internetReachability currentReachabilityStatus];
//    if(netStatus == ReachableViaWWAN || netStatus == ReachableViaWiFi)
//    {
//        reachable = YES;
//    }
//    else
//    {
//        reachable = NO;
//    }
//    return reachable;
//}


@end
