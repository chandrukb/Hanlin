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

@interface HNEventPromoDetailVC ()<CSLazyLoadControllerDelegate, UIWebViewDelegate, HNSliderDelegate>
{
    NSDictionary *event;
    CGFloat contentHeight;
    NSMutableArray *carouselUrlArray;
    HNSliderView *sliderView;
    HNSliderView *peopleSliderView;
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

- (IBAction)registerForEvent:(id)sender;
- (IBAction)getPromotion:(id)sender;
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
    
    if ([self.selectedOption isEqualToString: @"events"]) {
        [self grabEventDetailInBackground];
        self.title = @"Events";
    }
    else if([self.selectedOption isEqualToString: @"promos"])
    {
        [self grabPromotionDetailInBackground];
        self.title = @"Promotions";
    }
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
    self.lblEventPromoDate.text = [event valueForKey:@"startdate"];
    [self.webView loadHTMLString:[event valueForKey:@"message"] baseURL:nil];
    NSArray *dateComponents = [[event valueForKey:@"startdate"] componentsSeparatedByString:@"-"];
    self.lblDay.text = dateComponents[2];
    self.lblMonth.text = dateComponents[1];
    self.lblYear.text = dateComponents[0];
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
//    NSMutableArray *peoples = [[NSMutableArray alloc] init];
    self.peopleCarousel.contentSize = CGSizeMake([joinees count] * 52, 47);
    for(int i = 0; i < [joinees count]; i++)
    {
        NSDictionary *obj = [joinees objectAtIndex:i];
//        [peoples addObject:[HN_ROOTURL stringByAppendingString:[obj valueForKey:@"profileimage"]]];
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
//    peopleSliderView = [[[NSBundle mainBundle] loadNibNamed:@"HNSliderView" owner:self options:nil] firstObject];
//    peopleSliderView.delegate = self;
//    [peopleSliderView hidePageIndicator:YES];
//    [peopleSliderView initializeLazyLoader];
//    peopleSliderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.peopleCarousel addSubview:peopleSliderView];
//    BOOL shouldScroll = ([peoples count] > 1) ? YES : NO;
//    [peopleSliderView createSliderWithImages:peoples WithAutoScroll:shouldScroll inView:self.peopleCarousel];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.selectedOption isEqualToString:@"promos"] && (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5))//
        return 0; //set the hidden cell's height to 0
    
    if([self.selectedOption isEqualToString:@"events"] && indexPath.row == 5)
        return 0; //set the hidden cell's height to 0
    
    if([self.selectedOption isEqualToString:@"registered"] && (indexPath.row ==  4 || indexPath.row == 5))
        return 0; //set the hidden cell's height to 0
    
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

- (void)grabEventDetailInBackground
{
//    if([HNUtility checkIfInternetIsAvailable])
//    {
        NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_GET_ALL_EVENTS]];
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue: self.eventId forKey:@"id"];
        [request setCompletionBlock:^{
            if (request.responseStatusCode == 400) {
                NSLog(@"Invalid code");
            } else if (request.responseStatusCode == 403) {
                NSLog(@"Code already used");
            } else if (request.responseStatusCode == 200) {
                NSString *resString = [request responseString];
                NSArray *responseArray = [resString JSONValue];
                event = [responseArray[0] valueForKey:@"events"];
                [self prepareUIForEvent];
            }
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
        }];
        [request startAsynchronous];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet!!!"
//                                                       message:@"Unable to connect to the internet."
//                                                      delegate:nil
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

- (void)grabPromotionDetailInBackground
{
//    if([HNUtility checkIfInternetIsAvailable])
//    {
        NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_GET_ALL_PROMOTIONS]];
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue: self.promoId forKey:@"id"];
        [request setCompletionBlock:^{
            if (request.responseStatusCode == 400) {
                NSLog(@"Invalid code");
            } else if (request.responseStatusCode == 403) {
                NSLog(@"Code already used");
            } else if (request.responseStatusCode == 200) {
                NSString *resString = [request responseString];
                NSArray *responseArray = [resString JSONValue];
                event = [responseArray[0] valueForKey:@"promotions"];
                [self prepareUIForPromotion];
            }
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
        }];
        [request startAsynchronous];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet!!!"
//                                                       message:@"Unable to connect to the internet."
//                                                      delegate:nil
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

-(void)registerUserForEvent:(NSString *)eventId
{
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_JOIN_EVENT]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:HN_LOGIN_USERID] forKey:@"userid"];
    [request setPostValue:eventId forKey:@"eventid"];
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event App" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event App" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
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

- (IBAction)registerForEvent:(id)sender {
    [self registerUserForEvent:[event valueForKey:@"eventid"]];
}

- (IBAction)getPromotion:(id)sender {
}

@end
