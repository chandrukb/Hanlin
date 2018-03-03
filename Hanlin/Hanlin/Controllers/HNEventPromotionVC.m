//
//  HNEventPromotionVC.m
//  Hanlin
//
//  Created by Balachandran on 30/01/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNEventPromotionVC.h"
#import "HNEventPromotionCell.h"
#import "HNEventPromoDetailVC.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import <CSLazyLoadController/CSLazyLoadController.h>
#import "HNConstants.h"
#import "JSON.h"
#import "HNUtility.h"
#import "HNSliderView.h"
#import "HNServiceManager.h"

@interface HNEventPromotionVC ()<UITableViewDelegate, UITableViewDataSource, CSLazyLoadControllerDelegate,HNSliderDelegate>
{
    NSMutableDictionary *eventData;
    NSMutableArray *events;
    NSMutableArray *BannersObj;
    
    NSMutableDictionary *promoData;
    NSMutableArray *promos;
    NSInteger selectedIndex;
    HNSliderView *sliderView;
    HNSliderView *peopleSliderView;
    NSMutableArray *carouselUrlArray;
    
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *btnSegmentControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnRegisteredEventsHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *ivScreenBG;
@property (weak, nonatomic) IBOutlet UIImageView *ivEventsPromotions;
@property (weak, nonatomic) IBOutlet UITableView *eventPromoTableView;
@property (nonatomic, strong) CSLazyLoadController *lazyLoadController;
@property (weak, nonatomic) IBOutlet UIView *carouselView;

@end

@implementation HNEventPromotionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TopView=[[UIView alloc]init];
    TopView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 264);
    [self.view addSubview:TopView];
    
    carouselUrlArray = [[NSMutableArray alloc] init];
    sliderView = [[[NSBundle mainBundle] loadNibNamed:@"HNSliderView" owner:self options:nil] firstObject];
    sliderView.delegate = self;
    [sliderView initializeLazyLoader];
    [TopView addSubview:sliderView];
    [self.navigationItem.backBarButtonItem setTitle:@"活动"];
    self.title = @"活动";
    self.lazyLoadController = [[CSLazyLoadController alloc] init];
    self.lazyLoadController.delegate = self;
    // Do any additional setup after loading the view.
    [self.btnSegmentControl setSelectedSegmentIndex:0];
    [self segmentButtonValueChanged:self.btnSegmentControl];
    [self grabBannerInBackground];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.eventPromoTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)PrepareEventPromoBanner:(int)segment
{
    [carouselUrlArray removeAllObjects];
    for(NSDictionary *obj in BannersObj)
    {
        if(segment==1)
        {
            if([[obj valueForKey:@"type"] isEqualToString:@"promotions"])
            {
                [carouselUrlArray addObject:[HN_ROOTURL stringByAppendingString:[obj valueForKey:@"image"]]];
            }
        }
        else
        {
            if([[obj valueForKey:@"type"] isEqualToString:@"events"])
            {
                [carouselUrlArray addObject:[HN_ROOTURL stringByAppendingString:[obj valueForKey:@"image"]]];
            }
        }
    }
    BOOL shouldScroll = ([carouselUrlArray count] > 1) ? YES : NO;
    [sliderView createSliderWithImages:carouselUrlArray WithAutoScroll:shouldScroll inView:TopView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"EventPromoDetailSegue"])
    {
        HNEventPromoDetailVC *destinationVC = [segue destinationViewController];
        if(self.btnSegmentControl.selectedSegmentIndex == 0)
        {
            destinationVC.selectedOption = @"events";
            NSIndexPath *selectedIndex = [self.eventPromoTableView indexPathForSelectedRow];
            destinationVC.eventId = [[[events objectAtIndex:selectedIndex.row] valueForKey:@"events"] valueForKey:@"eventid"];
        }
        else{
            destinationVC.selectedOption = @"promos";
            NSIndexPath *selectedIndex = [self.eventPromoTableView indexPathForSelectedRow];
            destinationVC.promoId = [[[promos objectAtIndex:selectedIndex.row] valueForKey:@"promotions"] valueForKey:@"promotionid"];
        }
    }
}


- (IBAction)segmentButtonValueChanged:(id)sender {
    NSInteger selectedIndex = ((UISegmentedControl *)sender).selectedSegmentIndex;
    switch (selectedIndex) {
        case 0://selected events
        {
            if([HNUtility checkIfInternetIsAvailable])
            {
                [HNServiceManager executeRequestWithUrl:HN_GET_ALL_EVENTS completionHandler:^(NSArray *responseArray) {
                    events = [[NSMutableArray alloc] initWithArray:responseArray];
                    [self performSelectorOnMainThread:@selector(updateUIForEvents) withObject:nil waitUntilDone:YES];
                } ErrorHandler:^(NSError *error) {
                    NSLog(@"Error : %@",error.localizedDescription);
                }];
            }
            else
            {
                [HNUtility showAlertWithTitle:HN_NO_INTERNET_TITLE andMessage:HN_NO_INTERNET_MSG inViewController:self cancelButtonTitle:HN_OK_TITLE];
            }
        }
            break;
        case 1://selected promotions
        {
            if([HNUtility checkIfInternetIsAvailable])
            {
                [HNServiceManager executeRequestWithUrl:HN_GET_ALL_PROMOTIONS completionHandler:^(NSArray *responseArray) {
                    promos = [[NSMutableArray alloc] initWithArray:responseArray];
                    [self performSelectorOnMainThread:@selector(updateUIForPromotions) withObject:nil waitUntilDone:YES];
                } ErrorHandler:^(NSError *error) {
                    NSLog(@"Error : %@",error.localizedDescription);
                }];
            }
            else
            {
                [HNUtility showAlertWithTitle:HN_NO_INTERNET_TITLE andMessage:HN_NO_INTERNET_MSG inViewController:self cancelButtonTitle:HN_OK_TITLE];
            }
        }
            break;
        default:
            break;
    }
}

-(void)updateUIForEvents
{
    self.title = @"活动";
    self.btnRegisteredEventsHeightConstraint.constant = 40.0f;
    [self.eventPromoTableView reloadData];
    [self PrepareEventPromoBanner:0];
}

-(void)updateUIForPromotions
{
    self.title = @"促销";
    self.btnRegisteredEventsHeightConstraint.constant = 0.0f;
    [self.eventPromoTableView reloadData];
    [self PrepareEventPromoBanner:1];
}

#pragma mark- TableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    if(self.btnSegmentControl.selectedSegmentIndex == 0)
    {
        rowCount = [events count];
    }
    else
    {
        rowCount = [promos count];
    }
    return rowCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNEventPromotionCell *cell = (HNEventPromotionCell *) [tableView dequeueReusableCellWithIdentifier:@"EventPromoCell"];
    if(self.btnSegmentControl.selectedSegmentIndex == 0)
    {
        NSDictionary *eventObj = [[NSDictionary alloc] init];
        eventObj = [[events objectAtIndex:[indexPath row]] valueForKey:@"events"];
        cell.lblTitle.text = [eventObj valueForKey:@"eventname"];
        cell.lblDate.text = [eventObj valueForKey:@"startdate"];
        
        NSString *stringUrl = [HN_ROOTURL stringByAppendingString:[eventObj valueForKey:@"image"]];
        UIImage *image = [self.lazyLoadController fastCacheImage:[CSURL URLWithString:stringUrl]];
        cell.ivEventPromo.image = image;
        if (!image && !tableView.dragging) {
            [self.lazyLoadController startDownload:[CSURL URLWithString:stringUrl parameters:nil method:CSHTTPMethodPOST]
                                      forIndexPath:indexPath];
        }
    }
    else
    {
        NSDictionary *promoObj = [[NSDictionary alloc] init];
        promoObj = [[promos objectAtIndex:[indexPath row]] valueForKey:@"promotions"];
        cell.lblTitle.text = [promoObj valueForKey:@"name"];
        cell.lblDate.text = [promoObj valueForKey:@"startdate"];
        
        NSString *stringUrl = [HN_ROOTURL stringByAppendingString:[promoObj valueForKey:@"image"]];
        UIImage *image = [self.lazyLoadController fastCacheImage:[CSURL URLWithString:stringUrl]];
        cell.ivEventPromo.image = image;
        if (!image && !tableView.dragging) {
            [self.lazyLoadController startDownload:[CSURL URLWithString:stringUrl parameters:nil method:CSHTTPMethodPOST]
                                      forIndexPath:indexPath];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"EventPromoDetailSegue" sender:nil];
}

#pragma mark- Service call

- (void)grabBannerInBackground
{
    if([HNUtility checkIfInternetIsAvailable])
    {
        [HNServiceManager executeRequestWithUrl:HN_GET_ALL_BANNERS completionHandler:^(NSArray *responseArray) {
            BannersObj = [[NSMutableArray alloc] initWithArray:responseArray];
            [self performSelectorOnMainThread:@selector(PrepareEventPromoBanner:) withObject:nil waitUntilDone:YES];
        } ErrorHandler:^(NSError *error) {
            NSLog(@"Error : %@",error.localizedDescription);
        }];
    }
    else
    {
        [HNUtility showAlertWithTitle:HN_NO_INTERNET_TITLE andMessage:HN_NO_INTERNET_MSG inViewController:self cancelButtonTitle:HN_OK_TITLE];
    }
}

#pragma mark- end service call

#pragma mark - CSLazyLoadControllerDelegate

- (CSURL *)lazyLoadController:(CSLazyLoadController *)loadController
       urlForImageAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringUrl = @"";
    if(self.btnSegmentControl.selectedSegmentIndex == 0)
    {
        stringUrl = [[[events objectAtIndex:[indexPath row]] valueForKey:@"events"] valueForKey:@"image"];
    }
    else
    {
        stringUrl = [[[promos objectAtIndex:[indexPath row]] valueForKey:@"promotions"] valueForKey:@"image"];
    }
    return [CSURL URLWithString:stringUrl];
}

- (void)lazyLoadController:(CSLazyLoadController *)loadController
            didReciveImage:(UIImage *)image
                   fromURL:(CSURL *)url
                 indexPath:(NSIndexPath *)indexPath {
    HNEventPromotionCell *cell = [self.eventPromoTableView cellForRowAtIndexPath:indexPath];
    cell.ivEventPromo.image = image;
    [cell setNeedsLayout];
}

- (IBAction)showRegisteredEvents:(id)sender {
    NSLog(@"registered events clicked");
    [self performSegueWithIdentifier:@"RegisteredEventsSegue" sender:nil];
}

@end
