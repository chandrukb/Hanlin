//
//  HLoginVC.m
//  Hanlin
//
//  Created by BALACHANDRAN K on 26/01/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import "HLoginVC.h"
#import "HNConstants.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "JSON.h"
#import "HNUtility.h"

@interface HLoginVC ()<UITextFieldDelegate>
{
    NSArray *textFields;
    BOOL keyboardIsShown;
}
@end

@implementation HLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    textFields = [[NSArray alloc] initWithObjects:self.tfUsername,self.tfPassword, nil];
    [self prepareUIForLogin];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString: @"ShowMenuFromLogin"])
    {
        
    }
}


- (IBAction)onLoginClicked:(id)sender {
//    if([self.tfUsername validate] & [self.tfPassword validate]){
//        //Success
//        if([HNUtility checkIfInternetIsAvailable])
//        {
//            [self prepareRequest];
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet!!!"
//                                                           message:@"Unable to connect to the internet."
//                                                          delegate:nil
//                                                 cancelButtonTitle:@"OK"
//                                                 otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }
    [self prepareRequest];
}

- (IBAction)onRegisterClicked:(id)sender {
}

-(void)prepareUIForLogin
{
    //    [self.ivProfileImage addGestureRecognizer:self.tagGesture];
    //    for(UITextField *field in textFields)
    //    {
    //        field.textContentType = UITextContentTypeEmailAddress;
    //    }
}

#pragma mark- Textfield delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger fieldIndex = [textFields indexOfObject:textField];
    if(fieldIndex < [textFields count] - 1)
    {
        [textField resignFirstResponder];
        [[textFields objectAtIndex:fieldIndex+1] becomeFirstResponder];
    }
    else
    [textField resignFirstResponder];
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}

#pragma mark-Service call methods
-(void)prepareRequest
{
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    // Start request
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_LOGIN_USER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUseKeychainPersistence:YES];
    [request setPostValue:self.tfUsername.text forKey:HN_USERNAME];
    [request setPostValue:self.tfPassword.text forKey:HN_REQ_PASSWORD];    
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //handle the request
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
            [self saveLoginDetailsToPersistance:response];
            [self performSegueWithIdentifier:@"ShowMenuFromLogin" sender:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event App" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }        
    } else {
        NSLog(@"Unexpected error");
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error : %@",error.localizedDescription);
}

-(void) saveLoginDetailsToPersistance:(NSDictionary *)userDetails
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[userDetails valueForKey:HN_LOGIN_USERID] forKey:HN_LOGIN_USERID];
    [defaults setValue:[userDetails valueForKey:HN_LOGIN_NAME] forKey:HN_LOGIN_NAME];
    [defaults setValue:[userDetails valueForKey:HN_LOGIN_USERNAME] forKey:HN_LOGIN_USERNAME];
    [defaults setValue:[userDetails valueForKey:HN_LOGIN_PHONE] forKey:HN_LOGIN_PHONE];
    [defaults setValue:[userDetails valueForKey:HN_LOGIN_JOINDATE] forKey:HN_LOGIN_JOINDATE];
    [defaults setValue:[userDetails valueForKey:HN_LOGIN_PROFILE_IMG] forKey:HN_LOGIN_PROFILE_IMG];
    
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
@end
