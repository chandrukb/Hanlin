//
//  HRegisterVC.h
//  Hanlin
//
//  Created by BALACHANDRAN K on 26/01/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASIHTTPRequest;

@interface HRegisterVC : UIViewController
{
    ASIHTTPRequest *request;
}

@property (retain, nonatomic) ASIHTTPRequest *request;
@property (assign) BOOL isFromProfile;
@end
