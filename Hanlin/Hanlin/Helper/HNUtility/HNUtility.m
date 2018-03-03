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
#import "GCNetworkReachability.h"


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


+(BOOL)checkIfInternetIsAvailable
{
    GCNetworkReachability *reachability;
    reachability = [GCNetworkReachability reachabilityForInternetConnection];
    
    if([reachability isReachable])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSMutableArray *)getDatesBetweenTwoDates:(NSDate *)startDate :(NSDate *)endDate{
    NSMutableArray *dates = [NSMutableArray array];
    NSDate *curDate = startDate;
    while([curDate timeIntervalSince1970] <= [endDate timeIntervalSince1970]) //you can also use the earlier-method
    {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:curDate];
        [dates addObject:dateString];
        
        curDate = [NSDate dateWithTimeInterval:86400 sinceDate:curDate]; //86400 = 60*60*24
    }
    return dates;
}


@end
