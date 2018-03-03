//
//  HNRegisteredEventsVC.m
//  Hanlin
//
//  Created by Balachandran on 01/02/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNRegisteredEventsVC.h"
#import "HNEventPromoDetailVC.h"
#import "HNEventPromotionCell.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import <CSLazyLoadController/CSLazyLoadController.h>
#import "HNConstants.h"
#import "JSON.h"
#import "HNUtility.h"
#import "HNServiceManager.h"

@interface HNRegisteredEventsVC ()<UITableViewDelegate, UITableViewDataSource, CSLazyLoadControllerDelegate>
{
    NSMutableDictionary *eventData;
    NSMutableArray *events;
    NSInteger selectedIndex;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnRegisteredEventsHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *ivScreenBG;
@property (weak, nonatomic) IBOutlet UIImageView *ivEventsPromotions;
@property (weak, nonatomic) IBOutlet UITableView *eventPromoTableView;
@property (nonatomic, strong) CSLazyLoadController *lazyLoadController;

@end

@implementation HNRegisteredEventsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Registered Events";
    self.lazyLoadController = [[CSLazyLoadController alloc] init];
    self.lazyLoadController.delegate = self;
    [self grabEventsInBackground];
}

#pragma mark- Service call
- (void)grabEventsInBackground
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

-(void)updateUIForEvents
{
    [_eventPromoTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [events count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HNEventPromotionCell *cell = (HNEventPromotionCell *) [tableView dequeueReusableCellWithIdentifier:@"HNEventPromotionCell"];
    
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
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *eventObj = [[NSDictionary alloc] init];
    eventObj = [[events objectAtIndex:[indexPath row]] valueForKey:@"events"];
    
    HNEventPromoDetailVC *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"HNEventPromoDetailVC"];
    newView.selectedOption=@"events";
    newView.eventId=[eventObj valueForKey:@"eventid"];
    [self.navigationController pushViewController:newView animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    HNEventPromoDetailVC *destinationVC = [segue destinationViewController];
    destinationVC.selectedOption = @"registered";
}

#pragma mark - CSLazyLoadControllerDelegate

- (CSURL *)lazyLoadController:(CSLazyLoadController *)loadController
       urlForImageAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringUrl = @"";
    stringUrl = [[[events objectAtIndex:[indexPath row]] valueForKey:@"events"] valueForKey:@"image"];
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
