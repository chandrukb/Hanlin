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
#import "HNServiceManager.h"

@interface HLoginVC ()<UITextFieldDelegate>
{
    NSArray *textFields;
    BOOL keyboardIsShown;
}
@end

@implementation HLoginVC


-(void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    // Do any additional setup after loading the view.
    textFields = [[NSArray alloc] initWithObjects:self.tfUsername,self.tfPassword, nil];
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
    // For testing
    //  _tfUsername.text= @"craja.btech@icloud.com";
    //  _tfPassword.text = @"123456";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString: HN_SEGUE_LOGIN_TO_MENU])
    {
        
    }
}

- (IBAction)onLoginClicked:(id)sender {
    if([self.tfUsername validate] & [self.tfPassword validate]){
        if([HNUtility checkIfInternetIsAvailable])
        {
            //[self prepareRequest];
            [HNServiceManager loginWithUsername:self.tfUsername.text andPassword:self.tfPassword.text completionHandler:^(NSDictionary *response) {
                BOOL responseStatus = [[response valueForKey:HN_RES_SUCCESS] boolValue];
                NSString * message = [response valueForKey:HN_RES_MSG];
                if(responseStatus == true)
                {
//                    [self saveLoginDetailsToPersistance:response];
                    [HNUtility saveLoginDetailsToPersistance:response];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

                    [defaults setValue:[response valueForKey:@"username"] forKey:HN_LOGIN_USERNAME];

                    [self performSegueWithIdentifier:HN_SEGUE_LOGIN_TO_MENU sender:self];
                }
                else
                {
                    [HNUtility showAlertWithTitle:HN_APP_NAME andMessage:message inViewController:self cancelButtonTitle:HN_OK_TITLE];
                }
            }
            ErrorHandler:^(NSError *error) {
                   NSLog(@"Error : %@",error.localizedDescription);
            }];
        }
        else
        {
            [HNUtility showAlertWithTitle:HN_NO_INTERNET_TITLE andMessage:HN_NO_INTERNET_MSG inViewController:self cancelButtonTitle:HN_OK_TITLE];
        }
    }
}

- (IBAction)onRegisterClicked:(id)sender {

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

//#pragma mark-Service call methods
//-(void)prepareRequest
//{
//    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
//    // Start request
//    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_LOGIN_USER]];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setUseKeychainPersistence:YES];
//    [request setPostValue:self.tfUsername.text forKey:HN_USERNAME];
//    [request setPostValue:self.tfPassword.text forKey:HN_REQ_PASSWORD];
//    //    [request setPostValue:@"sabareesh8@gmail.com" forKey:HN_USERNAME];
//    //    [request setPostValue:@"123456" forKey:HN_REQ_PASSWORD];
//    [request setDelegate:self];
//    [request startAsynchronous];
//}

//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    //handle the request
//    if (request.responseStatusCode == 400) {
//        NSLog(@"Invalid code");
//    } else if (request.responseStatusCode == 403) {
//        NSLog(@"Code already used");
//    } else if (request.responseStatusCode == 200) {
//        NSString *resString = [request responseString];
//        NSArray *responseArray = [resString JSONValue];
//        NSDictionary *response = responseArray[0];
//        BOOL responseStatus = [[response valueForKey:HN_RES_SUCCESS] boolValue];
//        NSString * message = [response valueForKey:HN_RES_MSG];
//        if(responseStatus == true)
//        {
//            [self saveLoginDetailsToPersistance:response];
//            [self performSegueWithIdentifier:@"ShowMenuFromLogin" sender:self];
//        }
//        else
//        {
//            [HNUtility showAlertWithTitle:HN_APP_NAME andMessage:message inViewController:self cancelButtonTitle:HN_OK_TITLE];
//        }
//    } else {
//        NSLog(@"Unexpected error");
//    }
//
//}

//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    NSError *error = [request error];
//    NSLog(@"Error : %@",error.localizedDescription);
//}

//-(void) saveLoginDetailsToPersistance:(NSDictionary *)userDetails
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setValue:[userDetails valueForKey:HN_LOGIN_USERID] forKey:HN_LOGIN_USERID];
//    [defaults setValue:[userDetails valueForKey:HN_LOGIN_NAME] forKey:HN_LOGIN_NAME];
//    [defaults setValue:[userDetails valueForKey:HN_LOGIN_USERNAME] forKey:HN_LOGIN_USERNAME];
//    [defaults setValue:[userDetails valueForKey:HN_LOGIN_PHONE] forKey:HN_LOGIN_PHONE];
//    [defaults setValue:[userDetails valueForKey:HN_LOGIN_JOINDATE] forKey:HN_LOGIN_JOINDATE];
//    [defaults setValue:[userDetails valueForKey:HN_LOGIN_PROFILE_IMG] forKey:HN_LOGIN_PROFILE_IMG];
//
//}


@end
