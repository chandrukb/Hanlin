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
#import "HNSliderView.h"
#import "HNServiceManager.h"

@interface HNFilesVC ()<UITableViewDelegate, UITableViewDataSource,HNSliderDelegate>
{
    NSMutableDictionary *filesData;
    NSMutableArray *files;
    NSMutableDictionary *videoData;
    NSMutableArray *videos;
    
    NSMutableArray *BannersObj;
    HNSliderView *sliderView;
    HNSliderView *peopleSliderView;
    NSMutableArray *carouselUrlArray;
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

- (void)layoutSubviews
{
    
  //  self.ivFilesVideo.frame =CGRectMake(0, 0, self.ivFilesVideo.frame.size.width, 104);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    TopView=[[UIView alloc]init];
    TopView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 264);
    [self.view addSubview:TopView];
    
    carouselUrlArray = [[NSMutableArray alloc] init];
    sliderView = [[[NSBundle mainBundle] loadNibNamed:@"HNSliderView" owner:self options:nil] firstObject];
    sliderView.delegate = self;
    [sliderView initializeLazyLoader];
   // sliderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [TopView addSubview:sliderView];
    
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
    [self grabBannerInBackground];
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
    self.navigationItem.title = @"档案";
   // self.ivFilesVideo.image = [UIImage imageNamed:@"EventImage.png"];
}

-(void)updateUIForVideos
{
    self.navigationItem.title = @"视频链接";
   // self.ivFilesVideo.image = [UIImage imageNamed:@"PromoImage.png"];
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
    if([HNUtility checkIfInternetIsAvailable])
    {
        [HNServiceManager executeRequestWithUrl:HN_GET_ALL_ATTACHMENTS completionHandler:^(NSArray *responseArray) {
            for (NSDictionary *dict in responseArray) {
                
                if ([dict[@"filetype"] isEqualToString:@"Youtube Link"]) {
                    [videos addObject:dict];
                }
                else{
                    [files addObject:dict];
                }
            }
            [self performSelectorOnMainThread:@selector(updateUIForAttachments) withObject:nil waitUntilDone:YES];
        } ErrorHandler:^(NSError *error) {
            NSLog(@"Error : %@",error.localizedDescription);
        }];
    }
    else
    {
        [HNUtility showAlertWithTitle:HN_NO_INTERNET_TITLE andMessage:HN_NO_INTERNET_MSG inViewController:self cancelButtonTitle:HN_OK_TITLE];
    }
}

- (void)grabBannerInBackground
{
    if([HNUtility checkIfInternetIsAvailable])
    {
        [HNServiceManager executeRequestWithUrl:HN_GET_ALL_BANNERS completionHandler:^(NSArray *responseArray) {
            BannersObj = [[NSMutableArray alloc] initWithArray:responseArray];
            [self performSelectorOnMainThread:@selector(PrepareBannerUI) withObject:nil waitUntilDone:YES];
        } ErrorHandler:^(NSError *error) {
            NSLog(@"Error : %@",error.localizedDescription);
        }];
    }
    else
    {
        [HNUtility showAlertWithTitle:HN_NO_INTERNET_TITLE andMessage:HN_NO_INTERNET_MSG inViewController:self cancelButtonTitle:HN_OK_TITLE];
    }
}

-(void)updateUIForAttachments
{
    [self.contentTableview reloadData];
}

-(void)PrepareBannerUI
{
    for(NSDictionary *obj in BannersObj)
    {
        if([[obj valueForKey:@"type"] isEqualToString:@"files"])
        {
            [carouselUrlArray addObject:[HN_ROOTURL stringByAppendingString:[obj valueForKey:@"image"]]];
        }
    }
    BOOL shouldScroll = ([carouselUrlArray count] > 1) ? YES : NO;
    [sliderView createSliderWithImages:carouselUrlArray WithAutoScroll:shouldScroll inView:TopView];
}

@end
