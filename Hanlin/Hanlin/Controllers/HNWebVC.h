//
//  HNWebVC.h
//  Hanlin
//
//  Created by Selvam M on 1/26/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNWebVC : UIViewController

@property(nonatomic) NSString *htmlString;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
