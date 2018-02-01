//
//  HLoginVC.m
//  Hanlin
//
//  Created by BALACHANDRAN K on 26/01/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import "HLoginVC.h"

@interface HLoginVC ()<UITextFieldDelegate>

@end

@implementation HLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onLoginClicked:(id)sender {
}

- (IBAction)onRegisterClicked:(id)sender {
}

#pragma mark- Textfield delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    [textField resignFirstResponder];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}
@end
