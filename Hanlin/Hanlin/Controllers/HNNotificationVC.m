//
//  HNNotificationVC.m
//  Hanlin
//
//  Created by Selvam M on 1/27/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNNotificationVC.h"
#import "HNWebVC.h"
#import "HNNotificationsCell.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "HNConstants.h"
#import "JSON.h"
#import "HNUtility.h"

@interface HNNotificationVC (){
    NSMutableArray *notificationsArray;
}

@end

@implementation HNNotificationVC

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"HNWebViewSegue"])
    {
        HNWebVC *destinationVC = [segue destinationViewController];
        
        NSIndexPath *selectedIndex = [self.notificationTableView indexPathForSelectedRow];
        destinationVC.htmlString = [[[notificationsArray objectAtIndex:selectedIndex.row] valueForKey:@"newsletter"] valueForKey:@"description"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Notifications";
    notificationsArray = [[NSMutableArray alloc]init];
    [self grabNotificationsInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate and Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return notificationsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"notificationCell";
    HNNotificationsCell *cell = (HNNotificationsCell *) [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    NSDictionary *notificationObj = [[NSDictionary alloc] init];
    notificationObj = [[notificationsArray objectAtIndex:[indexPath row]] valueForKey:@"newsletter"];
    
    cell.notificationTextLbl.text = [NSString stringWithFormat:@"%@ %@",[notificationObj valueForKey:@"title"],[notificationObj valueForKey:@"entrydate"]];
    return cell;
}

#pragma mark- Service call
- (void)grabNotificationsInBackground
{
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_GET_ALL_NOTIFICATIONS]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        //handle the request
        if (request.responseStatusCode == 400) {
            NSLog(@"Invalid code");
        } else if (request.responseStatusCode == 403) {
            NSLog(@"Code already used");
        } else if (request.responseStatusCode == 200) {
            NSString *resString = [request responseString];
            NSArray *responseArray = [resString JSONValue];
            notificationsArray = [[NSMutableArray alloc] initWithArray:responseArray];
            [self performSelectorOnMainThread:@selector(updateUIForNotifications) withObject:nil waitUntilDone:YES];
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

-(void)updateUIForNotifications
{
    [self.notificationTableView reloadData];
}

@end
