//
//  HNChangePasswordVC.m
//  Hanlin
//
//  Created by Selvam M on 2/25/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNChangePasswordVC.h"
#import "HNTextField.h"

@interface HNChangePasswordVC (){
    BOOL keyboardIsShown;
}
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblInvalidPassword;
@property (weak, nonatomic) IBOutlet HNTextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentPassword;
@property (weak, nonatomic) IBOutlet HNTextField *tfCurrentPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblInvalidCurrentPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblVerifyPassword;
@property (weak, nonatomic) IBOutlet HNTextField *tfVerifyPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblInvalidVerifyPassword;
- (IBAction)updatePasswordAction:(id)sender;

@end

@implementation HNChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUIForRegistration];
    // Do any additional setup after loading the view.
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareUIForRegistration
{
    // Add regex for validating characters limit
    [self.tfCurrentPassword addRegx:@"^.{6,12}$" withMsg:@"Password characters limit should be between 6-12"];
    // Add regex for validating alpha numeric characters
    [self.tfCurrentPassword addRegx:@"[A-Za-z0-9]{6,12}" withMsg:@"Password must contain alpha numeric characters."];
    
    // Add regex for validating characters limit
    [self.tfPassword addRegx:@"^.{6,12}$" withMsg:@"Password characters limit should be between 6-12"];
    // Add regex for validating alpha numeric characters
    [self.tfPassword addRegx:@"[A-Za-z0-9]{6,12}" withMsg:@"Password must contain alpha numeric characters."];
    
    // Add regex for validating characters limit
    [self.tfVerifyPassword addRegx:@"^.{6,12}$" withMsg:@"Password characters limit should be between 6-12"];
    // Add regex for validating alpha numeric characters
    [self.tfVerifyPassword addRegx:@"[A-Za-z0-9]{6,12}" withMsg:@"Password must contain alpha numeric characters."];
    
}

#pragma mark- UITextField Delegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)iRange replacementString:(NSString *)iText {
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSInteger fieldIndex = [textFields indexOfObject:textField];
//    if(fieldIndex < [textFields count] - 1)
//    {
//        [textField resignFirstResponder];
//        [[textFields objectAtIndex:fieldIndex+1] becomeFirstResponder];
//    }
//    else
//        [textField resignFirstResponder];
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark- Keyboard notification methods
- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    // resize the scrollview
    CGRect viewFrame = self.scrollView.frame;
    viewFrame.size.height += keyboardSize.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    // resize the view
    CGRect viewFrame = self.scrollView.frame;
    viewFrame.size.height -= keyboardSize.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    keyboardIsShown = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)updatePasswordAction:(id)sender {
}
@end
