//
//  HNCalendarDetailVC.m
//  Hanlin
//
//  Created by RAJA JIMSEN on 21/02/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNCalendarDetailVC.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "HNConstants.h"
#import "JSON.h"

@interface HNCalendarDetailVC ()
{
    NSMutableDictionary *eventData;
    NSMutableArray *events;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *startdate;

@end

@implementation HNCalendarDetailVC

@synthesize GetSelecteddate,GetEvents;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startdate.backgroundColor = [UIColor darkGrayColor];

    
    self.startdate.hidden=YES;
    
    
    _HeaderDateLbl.text=GetSelecteddate;
    
    if(GetEvents)
    {
        _eventnameTf.text=[GetEvents valueForKey:@"title"];
        _LocationTf.text=[GetEvents valueForKey:@"location"];
        _timeTf.text=[GetEvents valueForKey:@"eventdate"];
        
    }
    
    //[self.view bringSubviewToFront:self.startdate];
    // Do any additional setup after loading the view.
}
- (IBAction)ShowTimePicker:(id)sender {
    
    self.startdate.hidden=NO;
}

- (IBAction)updateLabelFromPicker:(id)sender {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    _timeTf.text = [NSString stringWithFormat:@"%@ %@",GetSelecteddate,[dateFormatter stringFromDate:self.startdate.date]];
    self.startdate.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!self.startdate.isHidden)
    {
        self.startdate.hidden=YES;

    }
}

-(void)ValidateUI:(NSString*)Message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:Message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (IBAction)SubmitMyEvents:(id)sender
{
    
    NSURL *url;
    url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_GET_MY_EVENTS]];

    if(GetEvents)
    {
        url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_EDIT_MY_EVENTS]];

    }
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue: _eventnameTf.text forKey:@"title"];
    [request setPostValue: _LocationTf.text forKey:@"location"];
    [request setPostValue: _timeTf.text forKey:@"eventdate"];
    
    if(_eventnameTf.text.length==0 || _LocationTf.text.length==0 || _timeTf.text.length==0)
    {
        [self ValidateUI:@"Please fill all fields"];
        return;
    }
    
    if(GetEvents)
    {
        [request setPostValue: [GetEvents valueForKey:@"id"] forKey:@"usereventid"];

    }
    else
    {
        [request setPostValue: [[NSUserDefaults standardUserDefaults] valueForKey:HN_LOGIN_USERID] forKey:@"userid"];

    }
    
    [request setCompletionBlock:^{
        //        // Use when fetching text data
        //        NSString *responseString = [request responseString];
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
                [self.navigationController popViewControllerAnimated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hanlin App" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
