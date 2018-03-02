//
//  HNCalendarDetailVC.h
//  Hanlin
//
//  Created by RAJA JIMSEN on 21/02/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNCalendarDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *eventnameTf;
@property (weak, nonatomic) IBOutlet UITextField *timeTf;

@property (weak, nonatomic) IBOutlet UITextField *LocationTf;
@property (weak, nonatomic) IBOutlet UILabel *HeaderDateLbl;

@property (nonatomic,strong)  NSString *GetSelecteddate;
@property (nonatomic,strong)  NSDictionary *GetEvents;
@end
