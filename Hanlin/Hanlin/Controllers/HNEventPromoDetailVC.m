//
//  HNEventPromoDetailVC.m
//  Hanlin
//
//  Created by Balachandran on 01/02/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNEventPromoDetailVC.h"
#import "HNConstants.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import <CSLazyLoadController/CSLazyLoadController.h>
#import "JSON.h"
#import "HNRoundedImageView.h"
#import "HNSliderView.h"
#import "HNUtility.h"
#import "HNServiceManager.h"

@interface HNEventPromoDetailVC ()<CSLazyLoadControllerDelegate, UIWebViewDelegate, HNSliderDelegate>
{
    NSDictionary *event;
    CGFloat contentHeight;
    NSMutableArray *carouselUrlArray;
    HNSliderView *sliderView;
    HNSliderView *peopleSliderView;
    NSMutableArray *datePickerArray;
}
@property (nonatomic, strong) CSLazyLoadController *lazyLoadController;
@property (weak, nonatomic) IBOutlet HNRoundedImageView *ivEventPromo;
@property (weak, nonatomic) IBOutlet UILabel *lblEventPromo;
@property (weak, nonatomic) IBOutlet UILabel *lblEventPromoDate;
@property (weak, nonatomic) IBOutlet UIButton *btnRegisterEvent;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UIButton *btnGetPromo;
@property (weak, nonatomic) IBOutlet UILabel *lblPeopleCount;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *carouselView;
@property (weak, nonatomic) IBOutlet UIScrollView *peopleCarousel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)registerForEvent:(id)sender;
- (IBAction)getPromotion:(id)sender;
- (IBAction)chooseDateAction:(id)sender;
- (IBAction)cancelEventAction:(id)sender;
@end

@implementation HNEventPromoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    contentHeight = 0.0f;
    
    //For image slider
    carouselUrlArray = [[NSMutableArray alloc] init];
    sliderView = [[[NSBundle mainBundle] loadNibNamed:@"HNSliderView" owner:self options:nil] firstObject];
    sliderView.delegate = self;
    [sliderView initializeLazyLoader];
    sliderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.carouselView addSubview:sliderView];
    
    [self.navigationItem.backBarButtonItem setTitle:@""];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    self.lazyLoadController = [[CSLazyLoadController alloc] init];
    self.lazyLoadController.delegate = self;
    
    if ([self.selectedOption isEqualToString: kSTRING_EVENTS]) {
        [self grabDetailsFor:kSTRING_EVENTS];
        self.title = @"Events";
    }
    else if([self.selectedOption isEqualToString: kSTRING_PROMOS])
    {
        [self grabDetailsFor:kSTRING_PROMOS];
        self.title = @"Promotions";
    }
    _pickerView.showsSelectionIndicator = YES;
    [_pickerView setHidden:YES];
    
    
    
    selectionStates = [[NSMutableDictionary alloc] init];
    
    
    // Init picker and add it to view
    CheckBoxpickerView = [[ALPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 300)];
    CheckBoxpickerView.delegate = self;
    [FooterView addSubview:CheckBoxpickerView];
    
    CheckBoxtoolbar1 = [[UIToolbar alloc] init];
    CheckBoxtoolbar1.frame=CGRectMake(0,0,SCREEN_WIDTH,40);
    // toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked)];
    
    
    [CheckBoxtoolbar1 setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    [FooterView addSubview:CheckBoxtoolbar1];
    
    CheckBoxpickerView.hidden=YES;
    CheckBoxtoolbar1.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareUIForEvent
{
    NSArray *images = [event valueForKey:@"images"];
    NSString *stringUrl = [HN_ROOTURL stringByAppendingString:[[images objectAtIndex:0] valueForKey:@"image"]];
    UIImage *image = [self.lazyLoadController fastCacheImage:[CSURL URLWithString:stringUrl]];
    self.ivEventPromo.image = image;
    
    for(NSDictionary *obj in images)
    {
        [carouselUrlArray addObject:[HN_ROOTURL stringByAppendingString:[obj valueForKey:@"image"]]];
    }
    
    BOOL shouldScroll = ([carouselUrlArray count] > 1) ? YES : NO;
    [sliderView createSliderWithImages:carouselUrlArray WithAutoScroll:shouldScroll inView:self.carouselView];
    
    NSArray *joinees = [event valueForKey:@"joinedusers"];
    [self loadJoinedUsers:joinees];
    self.lblPeopleCount.text = [NSString stringWithFormat:@"%lu people(s) registered", (unsigned long)[joinees count]];
    self.lblEventPromo.text = [event valueForKey:@"eventname"];
    self.lblEventPromoDate.text = [NSString stringWithFormat:@"%@ to %@ ",[event valueForKey:@"startdate"],[event valueForKey:@"enddate"]];
    [self.webView loadHTMLString:[event valueForKey:@"message"] baseURL:nil];
    NSArray *dateComponents = [[event valueForKey:@"startdate"] componentsSeparatedByString:@"-"];
    self.lblDay.text = dateComponents[2];
    self.lblMonth.text = dateComponents[1];
    self.lblYear.text = dateComponents[0];
    
    [_pickerView reloadAllComponents];
}

-(void)prepareUIForPromotion
{
    NSArray *images = [event valueForKey:@"images"];
    NSString *stringUrl = [HN_ROOTURL stringByAppendingString:[[images objectAtIndex:0] valueForKey:@"image"]];
    UIImage *image = [self.lazyLoadController fastCacheImage:[CSURL URLWithString:stringUrl]];
    self.ivEventPromo.image = image;
    
    for(NSDictionary *obj in images)
    {
        [carouselUrlArray addObject:[HN_ROOTURL stringByAppendingString:[obj valueForKey:@"image"]]];
    }
    
    BOOL shouldScroll = ([carouselUrlArray count] > 1) ? YES : NO;
    [sliderView createSliderWithImages:carouselUrlArray WithAutoScroll:shouldScroll inView:self.carouselView];
    
    self.lblEventPromo.text = [event valueForKey:@"name"];
    self.lblEventPromoDate.text = [event valueForKey:@"startdate"];
    [self.webView loadHTMLString:[event valueForKey:@"description"] baseURL:nil];
    NSArray *dateComponents = [[event valueForKey:@"startdate"] componentsSeparatedByString:@"-"];
    self.lblDay.text = dateComponents[2];
    self.lblMonth.text = dateComponents[1];
    self.lblYear.text = dateComponents[0];
}

-(void)loadJoinedUsers:(NSArray *)joinees
{
    self.peopleCarousel.contentSize = CGSizeMake([joinees count] * 52, 47);
    for(int i = 0; i < [joinees count]; i++)
    {
        NSDictionary *obj = [joinees objectAtIndex:i];
        UIImage *image = [self.lazyLoadController fastCacheImage:[CSURL URLWithString:[HN_ROOTURL stringByAppendingString:[obj valueForKey:@"profileimage"]]]];
        if (!image) {
            [self.lazyLoadController startDownload:[CSURL URLWithString:[HN_ROOTURL stringByAppendingString:[obj valueForKey:@"profileimage"]] parameters:nil method:CSHTTPMethodPOST]
                                      forIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        HNRoundedImageView *imageView = [[HNRoundedImageView alloc] initWithFrame:CGRectMake(50 * i, 1, 45, 45)];
        imageView.layer.cornerRadius = 22.5f;
        imageView.layer.masksToBounds = YES;
        imageView.image = image;
        [self.peopleCarousel addSubview:imageView];
    }
}

#pragma mark- webview delegate method
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    contentHeight = fittingSize.height;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
#pragma mark- end webview methods

#pragma mark- Utility methods
- (NSDate*)convertDateFromString:(NSString*)strDate{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:strDate];
    return date;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.selectedOption isEqualToString:kSTRING_PROMOS] && (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5))//
        return 0; //set the hidden cell's height to 0
    
    if([self.selectedOption isEqualToString:kSTRING_EVENTS] && (indexPath.row == 5))
        return 0; //set the hidden cell's height to 0
    
    if(([[event valueForKey:@"isregistered"]intValue]==1) && (indexPath.row == 5))
        return 0; //set the hidden cell's height to 0
    
     if(([[event valueForKey:@"isregistered"]intValue]==0) && (indexPath.row ==  6))
        return 0;
        
    if(indexPath.row == 3)
        return contentHeight;
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
#pragma mark - ending tableview data source

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)grabDetailsFor:(NSString *)itemType
//- (void)grabEventDetailInBackground
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    if([HNUtility checkIfInternetIsAvailable])
    {
        if([itemType isEqualToString:kSTRING_EVENTS])
        {
            NSDictionary *payload = [[NSDictionary alloc] initWithObjects:@[self.eventId, [defaults objectForKey:HN_LOGIN_USERID]] forKeys:@[HN_REQ_ID, HN_REQ_USERID]];
            [HNServiceManager executeRequestWithUrl:HN_GET_ALL_EVENTS completionHandler:^(NSArray *responseArray) {
                event = [responseArray[0] valueForKey:kSTRING_EVENTS];
                
                
                //Todo needs to be optimize
                NSString *startDateStr = [event valueForKey:@"startdate"];
                NSString *endDateStr = [event valueForKey:@"enddate"];
                datePickerArray = [HNUtility getDatesBetweenTwoDates:[self convertDateFromString:startDateStr] :[self convertDateFromString:endDateStr]];
                
                NSString *AlreadyJoinedDates=@"";
                if([[event valueForKey:@"isregistered"]intValue]==1)
                {
                    AlreadyJoinedDates=[[[event valueForKey:@"joined_dates"]objectAtIndex:0] objectForKey:@"joined_date"];
                    
                }
                
                for (NSString *key in datePickerArray)
                {
                    if([AlreadyJoinedDates containsString:key])
                        [selectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
                    else
                        [selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];

                }
                //
                
                [self performSelectorOnMainThread:@selector(prepareUIForEvent) withObject:nil waitUntilDone:YES];
            } ErrorHandler:^(NSError *error) {
                NSLog(@"Error : %@",error.localizedDescription);
            } payLoadDictionary:payload];
        }
        else
        {
            NSDictionary *payload = [[NSDictionary alloc] initWithObjects:@[self.promoId] forKeys:@[HN_REQ_ID]];
            [HNServiceManager executeRequestWithUrl:HN_GET_ALL_PROMOTIONS completionHandler:^(NSArray *responseArray) {
                event = [responseArray[0] valueForKey:kSTRING_PROMOTIONS];
                [self performSelectorOnMainThread:@selector(prepareUIForPromotion) withObject:nil waitUntilDone:YES];
            } ErrorHandler:^(NSError *error) {
                NSLog(@"Error : %@",error.localizedDescription);
            } payLoadDictionary:payload];
        }
    }
    else
    {
        [HNUtility showAlertWithTitle:HN_NO_INTERNET_TITLE andMessage:HN_NO_INTERNET_MSG inViewController:self cancelButtonTitle:HN_OK_TITLE];
    }
}

-(void)registerUserForEvent:(NSString *)eventId
{
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_JOIN_EVENT]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:HN_LOGIN_USERID] forKey:HN_REQ_USERID];
    [request setPostValue:eventId forKey:@"eventid"];
   // NSString *joinDateStr = [NSString stringWithFormat:@"%@",[datePickerArray objectAtIndex:0]];
    [request setPostValue:JoiningDates forKey:@"joindate"];
    
    
    
   
    
    [request setCompletionBlock:^{
        if (request.responseStatusCode == 400) {
            NSLog(@"Invalid code");
        } else if (request.responseStatusCode == 403) {
            NSLog(@"Code already used");
        } else if (request.responseStatusCode == 200) {
            NSString *resString = [request responseString];
            NSArray *responseArray = [resString JSONValue];
            NSDictionary *response = responseArray[0];
            BOOL responseStatus = [[response valueForKey:HN_RES_SUCCESS] boolValue];
            NSString * message = [response valueForKey:HN_RES_MSG];
            if(responseStatus == true)
            {
                [self grabDetailsFor:kSTRING_EVENTS];
                [HNUtility showAlertWithTitle:HN_APP_NAME andMessage:message inViewController:self cancelButtonTitle:HN_OK_TITLE];
            }
            else
            {
                [HNUtility showAlertWithTitle:HN_APP_NAME andMessage:message inViewController:self cancelButtonTitle:HN_OK_TITLE];
            }
            request = nil;
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error : %@",error.localizedDescription);
        request = nil;
    }];
    [request startAsynchronous];
}

-(void)cancelUserForEvent:(NSString *)eventId
{
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_CANCEL_EVENT]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:HN_LOGIN_USERID] forKey:HN_REQ_USERID];
    [request setPostValue:eventId forKey:@"eventid"];
    [request setPostValue:@"del" forKey:@"action"];
    [request setCompletionBlock:^{
        if (request.responseStatusCode == 400) {
            NSLog(@"Invalid code");
        } else if (request.responseStatusCode == 403) {
            NSLog(@"Code already used");
        } else if (request.responseStatusCode == 200) {
            NSString *resString = [request responseString];
            NSArray *responseArray = [resString JSONValue];
            NSDictionary *response = responseArray[0];
            BOOL responseStatus = [[response valueForKey:HN_RES_SUCCESS] boolValue];
            NSString * message = [response valueForKey:HN_RES_MSG];
            if(responseStatus == true)
            {
                [self grabDetailsFor:kSTRING_EVENTS];
                [HNUtility showAlertWithTitle:HN_APP_NAME andMessage:message inViewController:self cancelButtonTitle:HN_OK_TITLE];
            }
            else
            {
                [HNUtility showAlertWithTitle:HN_APP_NAME andMessage:message inViewController:self cancelButtonTitle:HN_OK_TITLE];
            }
            request = nil;
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error : %@",error.localizedDescription);
        request = nil;
    }];
    [request startAsynchronous];
}
#pragma mark - CSLazyLoadControllerDelegate

- (CSURL *)lazyLoadController:(CSLazyLoadController *)loadController
       urlForImageAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *stringUrl = [event valueForKey:@"image"];
    return [CSURL URLWithString:stringUrl];
}

- (void)lazyLoadController:(CSLazyLoadController *)loadController
            didReciveImage:(UIImage *)image
                   fromURL:(CSURL *)url
                 indexPath:(NSIndexPath *)indexPath {
}

#pragma mark -
#pragma mark PickerView delegate methods

#pragma mark ALPickerView delegate methods

- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView {
    return [datePickerArray count];
}

- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row {
    return [datePickerArray objectAtIndex:row];
}

- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row {
    return [[selectionStates objectForKey:[datePickerArray objectAtIndex:row]] boolValue];
}

- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row {
    // Check whether all rows are checked or only one
    if (row == -1)
        for (id key in [selectionStates allKeys])
            [selectionStates setObject:[NSNumber numberWithBool:YES] forKey:key];
    else
        [selectionStates setObject:[NSNumber numberWithBool:YES] forKey:[datePickerArray objectAtIndex:row]];
    
    
   
}

#pragma mark -
#pragma mark Button Action  methods

- (IBAction)registerForEvent:(id)sender {
    
    NSMutableArray *TmpWorks=[[NSMutableArray alloc]init];
    
    for(int i=0;i<[selectionStates allValues].count;i++)
    {
        if([[selectionStates allValues][i] boolValue]==YES)
        {
                [TmpWorks addObject:[selectionStates allKeys][i]];
        }
    }
    
    if(TmpWorks.count==0)
    {
        [HNUtility showAlertWithTitle:HN_APP_NAME andMessage:@"Please select date" inViewController:self cancelButtonTitle:HN_OK_TITLE];
        return;
    }
    else
    {
        JoiningDates=[TmpWorks componentsJoinedByString:@","];
        JoiningDates=[JoiningDates stringByReplacingOccurrencesOfString:@"," withString:@"||"];
        [self registerUserForEvent:[event valueForKey:HN_REQ_ID]];

    }
    
}

- (IBAction)getPromotion:(id)sender {
}

- (IBAction)chooseDateAction:(id)sender {
    /*
    NSLog(@"Choose Date Action Called");
    [_pickerView setHidden:NO];
//    [self.tableView reloadData];
    [_pickerView reloadAllComponents];
     */
    CheckBoxtoolbar1.hidden=NO;
    CheckBoxpickerView.hidden=NO;
    //[FooterView bringSubviewToFront:CheckBoxpickerView];
    [CheckBoxpickerView reloadAllComponents];
}

-(void)doneClicked
{
    
    CheckBoxpickerView.hidden=YES;
    CheckBoxtoolbar1.hidden=YES;
}

- (IBAction)cancelEventAction:(id)sender {
    [self cancelUserForEvent:[event valueForKey:HN_REQ_ID]];
}

@end
