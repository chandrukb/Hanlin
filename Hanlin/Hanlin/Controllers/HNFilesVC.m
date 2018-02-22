//
//  HNFilesVC.m
//  Hanlin
//
//  Created by Balachandran on 01/02/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNFilesVC.h"
#import "HNWebVC.h"
#import "HNContentsTableViewCell.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "HNConstants.h"
#import "JSON.h"
#import "HNUtility.h"

@interface HNFilesVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary *filesData;
    NSMutableArray *files;
    NSMutableDictionary *videoData;
    NSMutableArray *videos;
}
@end

@implementation HNFilesVC

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    //This need to be checked and refined while actual implementation
    if([segue.identifier isEqualToString:@"AttachmentsWebView"])
    {
        HNWebVC *destinationVC = [segue destinationViewController];
        
        NSIndexPath *selectedIndex = [self.contentTableview indexPathForSelectedRow];
        if(_btnSegmentControl.selectedSegmentIndex==0)
        {
            destinationVC.htmlString = [NSString stringWithFormat:@"%@%@",HN_ROOTURL,files[selectedIndex.row][@"attachement"]];
        }
        else if(_btnSegmentControl.selectedSegmentIndex==1)
        {
            destinationVC.htmlString = [NSString stringWithFormat:@"%@",videos[selectedIndex.row][@"attachement"]];
        }
        destinationVC.isFromAttachments = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //mock data for events
//    filesData = [[NSMutableDictionary alloc] init];
//    [filesData setValue:@"DownloadIcon" forKey:@"btn_img"];
//    [filesData setValue:@"Tips to become high roller" forKey:@"title"];
//    [filesData setValue:@"10 February 2018" forKey:@"date"];
    files = [[NSMutableArray alloc] init];
//    [files addObject:filesData];
//    [files addObject:filesData];
    
    //mock data for promos
//    videoData = [[NSMutableDictionary alloc] init];
//    [videoData setValue:@"YoutubeIcon" forKey:@"btn_img"];
//    [videoData setValue:@"James Ma Talk (LIVE)" forKey:@"title"];
//    [videoData setValue:@"10 February 2018" forKey:@"date"];
    videos = [[NSMutableArray alloc] init];
//    [videos addObject:videoData];
//    [videos addObject:videoData];
    
    [self grabAttachmentsInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentControlSelected:(id)sender {
    NSInteger selectedIndex = ((UISegmentedControl *)sender).selectedSegmentIndex;
    switch (selectedIndex) {
        case 0://selected events
        {
            [self updateUIForFiles];
        }
            break;
        case 1://selected promotions
        {
            [self updateUIForVideos];
        }
            break;
        default:
            break;
    }
    [self.contentTableview reloadData];
}

-(void)updateUIForFiles
{
    self.navigationItem.title = @"Files";
    self.ivFilesVideo.image = [UIImage imageNamed:@"EventImage.png"];
}

-(void)updateUIForVideos
{
    self.navigationItem.title = @"Video Links";
    self.ivFilesVideo.image = [UIImage imageNamed:@"PromoImage.png"];
}

#pragma mark- TableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    if(self.btnSegmentControl.selectedSegmentIndex == 0)
    {
        rowCount = [files count];
    }
    else
    {
        rowCount = [videos count];
    }
    return rowCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNContentsTableViewCell *cell = (HNContentsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"ContentsCellIdentifier"];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    if(self.btnSegmentControl.selectedSegmentIndex == 0)
    {
        dataDict = [files objectAtIndex:[indexPath row]];
        [cell.btnAction setImage:[UIImage imageNamed:@"DownloadIcon"] forState:UIControlStateNormal];
    }
    else
    {
        dataDict = [videos objectAtIndex:[indexPath row]];
        [cell.btnAction setImage:[UIImage imageNamed:@"YoutubeIcon"] forState:UIControlStateNormal];
    }
    cell.lblTitle.text = [dataDict valueForKey:@"name"];
    cell.lblDate.text = [dataDict valueForKey:@"entrydate"];
    return cell;
}

#pragma mark- Service call
- (void)grabAttachmentsInBackground
{
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_GET_ALL_ATTACHMENTS]];
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
            
            for (NSDictionary *dict in responseArray) {
                
                if ([dict[@"filetype"] isEqualToString:@"Youtube Link"]) {
                    [videos addObject:dict];
                }
                else{
                    [files addObject:dict];
                }
            }
            [self performSelectorOnMainThread:@selector(updateUIForAttachments) withObject:nil waitUntilDone:YES];
        }
        // Use when fetching binary data
//        NSData *responseData = [request responseData];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
    }];
    [request startAsynchronous];
}

-(void)updateUIForAttachments
{
    [self.contentTableview reloadData];
}
@end
