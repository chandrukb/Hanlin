//
//  HLoginVC.h
//  Hanlin
//
//  Created by BALACHANDRAN K on 26/01/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLoginVC : UIViewController
{
    
}
//Username field properties
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UILabel *err_lblUsername;
@property (weak, nonatomic) IBOutlet UIView *usernameBorderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameContainerHeightConstraint;

//Password field properties
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UILabel *err_lblPassword;
@property (weak, nonatomic) IBOutlet UIView *passwordBorderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordContainerHeightConstraint;

//Button outlets
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UILabel *lblOr;

//Action Methods
- (IBAction)onLoginClicked:(id)sender;
- (IBAction)onRegisterClicked:(id)sender;

@end
