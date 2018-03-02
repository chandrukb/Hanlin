//
//  HNMenuVC.h
//  Hanlin
//
//  Created by BALACHANDRAN K on 27/01/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNRoundedImageView.h"

@interface HNMenuVC : UIViewController
@property (weak, nonatomic) IBOutlet HNRoundedImageView *ivProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *lblFullName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

@end
