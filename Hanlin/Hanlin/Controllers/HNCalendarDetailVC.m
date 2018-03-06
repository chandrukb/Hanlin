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
#import "HNUtility.h"

@interface HNCalendarDetailVC ()
{
    NSMutableDictionary *eventData;
    NSMutableArray *events;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *startdate;

@end

@implementation HNCalendarDetailVC

@synthesize GetSelecteddate,GetEvents;


-(void)viewDidLayoutSubviews
{
    Deletebutton.frame=CGRectMake(Submitbutton.frame.origin.x, Submitbutton.frame.origin.y+60, Submitbutton.frame.size.width, Submitbutton.frame.size.height);
    
    CheckBoxtoolbar1.frame=CGRectMake(0, self.startdate.frame.origin.y-40, SCREEN_WIDTH, 40);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startdate.backgroundColor = [UIColor whiteColor];
    self.startdate.hidden = YES;
    _HeaderDateLbl.text = GetSelecteddate;
    
    if(GetEvents)
    {
        _eventnameTf.text = [GetEvents valueForKey:@"title"];
        _LocationTf.text = [GetEvents valueForKey:@"location"];
        _timeTf.text = [GetEvents valueForKey:@"eventdate"];
        
        
        Deletebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [Deletebutton addTarget:self
                         action:@selector(DeleteEvent)
               forControlEvents:UIControlEventTouchUpInside];
        [Deletebutton setTitle:@"删除事件" forState:UIControlStateNormal];
        Deletebutton.frame = CGRectMake(0.0, 0.0, 0.0, 0.0);
        Deletebutton.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:84.0/255.0 blue:166.0/255.0 alpha:1.0f];
        [self.view addSubview:Deletebutton];
    }
    
    
    CheckBoxtoolbar1 = [[UIToolbar alloc] init];
    CheckBoxtoolbar1.frame=CGRectMake(0,0,SCREEN_WIDTH,40);
    // toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(updateLabelFromPicker:)];
    
    
    [CheckBoxtoolbar1 setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    [self.view addSubview:CheckBoxtoolbar1];
    
    CheckBoxtoolbar1.hidden=YES;
    
   
    //[self.view bringSubviewToFront:self.startdate];
}
- (IBAction)ShowTimePicker:(id)sender {
    self.startdate.hidden = NO;
    CheckBoxtoolbar1.hidden=NO;
}

- (IBAction)updateLabelFromPicker:(id)sender {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    _timeTf.text = [NSString stringWithFormat:@"%@ %@",GetSelecteddate,[dateFormatter stringFromDate:self.startdate.date]];
    self.startdate.hidden=YES;
    CheckBoxtoolbar1.hidden=YES;
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
        self.startdate.hidden = YES;
        CheckBoxtoolbar1.hidden=YES;
    }
}

-(void)ValidateUI:(NSString *)Message
{
    [HNUtility showAlertWithTitle:@"Error" andMessage:Message inViewController:self cancelButtonTitle:HN_OK_TITLE];
}


-(void)DeleteEvent
{
    
        NSURL *url;
        url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_EDIT_MY_EVENTS]];
        
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue: [GetEvents valueForKey:@"id"] forKey:@"usereventid"];
    [request setPostValue: @"del" forKey:@"action"];
    
    
    [request setCompletionBlock:^{
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
            }
            [HNUtility showAlertWithTitle:HN_APP_NAME andMessage:message inViewController:self cancelButtonTitle:HN_OK_TITLE];
            request = nil;
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        request = nil;
    }];
    [request startAsynchronous];
}

- (IBAction)SubmitMyEvents:(id)sender
{
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_GET_MY_EVENTS]];
    
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
            }
            [HNUtility showAlertWithTitle:HN_APP_NAME andMessage:message inViewController:self cancelButtonTitle:HN_OK_TITLE];
            request = nil;
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        request = nil;
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
