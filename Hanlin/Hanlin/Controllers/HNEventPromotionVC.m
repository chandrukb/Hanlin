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

@interface HNEventPromotionVC ()<UITableViewDelegate, UITableViewDataSource, CSLazyLoadControllerDelegate>
{
    NSMutableDictionary *eventData;
    NSMutableArray *events;
    NSMutableDictionary *promoData;
    NSMutableArray *promos;
    NSInteger selectedIndex;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *btnSegmentControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnRegisteredEventsHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *ivScreenBG;
@property (weak, nonatomic) IBOutlet UIImageView *ivEventsPromotions;
@property (weak, nonatomic) IBOutlet UITableView *eventPromoTableView;
@property (nonatomic, strong) CSLazyLoadController *lazyLoadController;
@end

@implementation HNEventPromotionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.backBarButtonItem setTitle:@"Events"];
    self.title = @"Events";
    self.lazyLoadController = [[CSLazyLoadController alloc] init];
    self.lazyLoadController.delegate = self;
    // Do any additional setup after loading the view.
    [self.btnSegmentControl setSelectedSegmentIndex:0];
    [self segmentButtonValueChanged:self.btnSegmentControl];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.eventPromoTableView reloadData];
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
    
    //This need to be checked and refined while actual implementation
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
//            if([HNUtility checkIfInternetIsAvailable])
//            {
//                [self grabEventsInBackground];
//            }
//            else
//            {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet!!!"
//                                                               message:@"Unable to connect to the internet."
//                                                              delegate:nil
//                                                     cancelButtonTitle:@"OK"
//                                                     otherButtonTitles:nil, nil];
//                [alert show];
//            }
            [self grabEventsInBackground];
            [self updateUIForEvents];
        }
            break;
        case 1://selected promotions
        {
//            if([HNUtility checkIfInternetIsAvailable])
//            {
//                [self grabPromotionsInBackground];
//            }
//            else
//            {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Internet!!!"
//                                                               message:@"Unable to connect to the internet."
//                                                              delegate:nil
//                                                     cancelButtonTitle:@"OK"
//                                                     otherButtonTitles:nil, nil];
//                [alert show];
//            }
            [self grabPromotionsInBackground];
            [self updateUIForPromotions];
        }
            break;
        default:
            break;
    }
}

-(void)updateUIForEvents
{
    self.title = @"Events";
    self.ivEventsPromotions.image = [UIImage imageNamed:@"EventImage.png"]; self.btnRegisteredEventsHeightConstraint.constant = 40.0f;
    [self.eventPromoTableView reloadData];
}

-(void)updateUIForPromotions
{
    self.title = @"Promotions";
    self.ivEventsPromotions.image = [UIImage imageNamed:@"PromoImage.png"]; self.btnRegisteredEventsHeightConstraint.constant = 0.0f;
    [self.eventPromoTableView reloadData];
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
}

#pragma mark- Service call
- (void)grabEventsInBackground
{
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_GET_ALL_EVENTS]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
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
            events = [[NSMutableArray alloc] initWithArray:responseArray];
            [self performSelectorOnMainThread:@selector(updateUIForEvents) withObject:nil waitUntilDone:YES];
        }
        // Use when fetching binary data
        NSData *responseData = [request responseData];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
    }];
    [request startAsynchronous];
}


- (void)grabPromotionsInBackground
{
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_GET_ALL_PROMOTIONS]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
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
            promos = [[NSMutableArray alloc] initWithArray:responseArray];
        }
        [self performSelectorOnMainThread:@selector(updateUIForPromotions) withObject:nil waitUntilDone:YES];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
    }];
    [request startAsynchronous];
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
@end
