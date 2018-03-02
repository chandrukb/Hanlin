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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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
    
    if((_tfCurrentPassword.text.length==0)||(_tfPassword.text.length==0)||(_tfVerifyPassword.text.length==0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event App" message:@"Please enter valid password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if(![_tfPassword.text isEqualToString:_tfVerifyPassword.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hanlin App" message:@"New password and Confirm Password mismatch" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_RESET_PASSWORD]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:HN_LOGIN_USERID] forKey:@"userid"];
    [request setPostValue:_tfCurrentPassword.text forKey:@"oldpassword"];
    [request setPostValue:_tfVerifyPassword.text forKey:@"newpassword"];
    
    [request setCompletionBlock:^{
        if (request.responseStatusCode == 400) {
            NSLog(@"Invalid code");
        } else if (request.responseStatusCode == 403) {
            NSLog(@"Code already used");
        } else if (request.responseStatusCode == 200) {
            NSString *resString = [request responseString];
            NSArray *responseArray = [resString JSONValue];
            NSDictionary *response = responseArray[0];
            BOOL responseStatus = [[response valueForKey:@"success"] boolValue];
            NSString * message = [response valueForKey:@"msg"];
            if(responseStatus == true)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hanlin App" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hanlin App" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
    }];
    [request startAsynchronous];
}
@end
