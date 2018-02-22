//
//  AppDelegate.h
//  Hanlin
//
//  Created by Balachandran on 23/01/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *strDeviceToken;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *strDeviceToken;
//@property (nonatomic) Reachability *hostReachability;
//@property (nonatomic) Reachability *internetReachability;
//@property (nonatomic) Reachability *wifiReachability;

@end

