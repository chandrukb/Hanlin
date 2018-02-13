//
//  HNEventPromoDetailVC.m
//  Hanlin
//
//  Created by Balachandran on 01/02/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNEventPromoDetailVC.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "HNConstants.h"
#import <CSLazyLoadController/CSLazyLoadController.h>
#import "JSON.h"
#import "HNRoundedImageView.h"

@interface HNEventPromoDetailVC ()<CSLazyLoadControllerDelegate>
{
//    NSMutableDictionary *event;
}
@property (nonatomic, strong) CSLazyLoadController *lazyLoadController;
@property (weak, nonatomic) IBOutlet HNRoundedImageView *ivEventPromo;
@property (weak, nonatomic) IBOutlet UILabel *lblEventPromo;
@property (weak, nonatomic) IBOutlet UILabel *lblEventPromoDate;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnRegisterEvent;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UIButton *btnGetPromo;
@property (weak, nonatomic) IBOutlet UILabel *lblPeopleCount;

- (IBAction)registerForEvent:(id)sender;
- (IBAction)getPromotion:(id)sender;
@end

@implementation HNEventPromoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.backBarButtonItem setTitle:@""];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    self.lazyLoadController = [[CSLazyLoadController alloc] init];
    self.lazyLoadController.delegate = self;
    
    if ([self.selectedOption isEqualToString: @"events"]) {
//        [self grabEventDetailInBackground];
        [self prepareUIForEvent];
        self.title = @"Events";
    }
    else if([self.selectedOption isEqualToString: @"promos"])
    {
        self.title = @"Promotions";
    }
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareUIForEvent
{
    self.ivEventPromo.image = self.imgEventPromo;
    self.lblEventPromo.text = [self.event valueForKey:@"eventname"];
    self.lblEventPromoDate.text = [self.event valueForKey:@"startdate"];
    self.lblMessage.text = [self.event valueForKey:@"message"];
    NSArray *dateComponents = [[self.event valueForKey:@"startdate"] componentsSeparatedByString:@"-"];
    self.lblDay.text = dateComponents[2];
    self.lblMonth.text = dateComponents[1];
    self.lblYear.text = dateComponents[0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
//    NSInteger rowCount = 0;
//    if([self.selectedOption isEqualToString:@"events"])
//    {
//        rowCount = 6;
//    }
//    else
//    {
//        rowCount = 4;
//    }
    return 6;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if([self.selectedOption isEqualToString:@"promos"] && (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5))//
        return 0; //set the hidden cell's height to 0
    
    if([self.selectedOption isEqualToString:@"events"] && indexPath.row == 5)
        return 0; //set the hidden cell's height to 0
    
    if([self.selectedOption isEqualToString:@"registered"] && (indexPath.row ==  4 || indexPath.row == 5))
        return 0; //set the hidden cell's height to 0
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


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
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_GET_ALL_EVENTS]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue: @"9" forKey:@"id"];
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
            self.event = [responseArray[0] valueForKey:@"events"];
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

    NSString *stringUrl = [self.event valueForKey:@"image"];
    return [CSURL URLWithString:stringUrl];
}

- (void)lazyLoadController:(CSLazyLoadController *)loadController
            didReciveImage:(UIImage *)image
                   fromURL:(CSURL *)url
                 indexPath:(NSIndexPath *)indexPath {
//    self..image = image;
//    [cell setNeedsLayout];
}

- (IBAction)registerForEvent:(id)sender {
}

- (IBAction)getPromotion:(id)sender {
}
@end
