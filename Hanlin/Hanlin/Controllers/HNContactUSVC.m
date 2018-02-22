//
//  HNContactUSVC.m
//  Hanlin
//
//  Created by Selvam M on 1/27/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import "HNContactUSVC.h"
#import "HNConstants.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "JSON.h"
#import "HNUtility.h"
#import "HNTextField.h"

@interface HNContactUSVC ()
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactNumberTxtField;

@end

@implementation HNContactUSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _descriptionTextView.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendBtnAction:(id)sender {
    [self prepareRequest];
}

#pragma mark- Textfield delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  true;
}

-(void)prepareRequest
{
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    // Start request
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_CONTACTUS]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //    [request setPostValue:self.tfFullname.text forKey:HN_REQ_NAME];
    //    [request setPostValue:self.tfEmail.text forKey:HN_REQ_EMAIL];
    //    [request setPostValue:self.tfContactNumber.text forKey:HN_REQ_PHONE];
    //    [request setPostValue:self.tfPassword.text forKey:HN_REQ_PASSWORD];
    
    [request setPostValue:@"11" forKey:HN_REQ_USERID];
    [request setPostValue:_descriptionTextView.text forKey:HN_REQ_MESSAGE];
    [request setPostValue:_contactNumberTxtField.text forKey:HN_REQ_PHONE];
    [request setPostValue:_companyNameTxtField.text forKey:HN_REQ_COMPANY];
    [request setPostValue:_addressTextField.text forKey:HN_REQ_ADDRESS];
    
    
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event App" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event App" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        NSLog(@"dictionary value: %@", response);
        //to do: present an alert to the user and navigate to the login or the home screen
    } else {
        NSLog(@"Unexpected error");
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error : %@",error.localizedDescription);
}

@end
