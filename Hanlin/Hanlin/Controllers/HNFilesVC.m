//
//  HNFilesVC.m
//  Hanlin
//
//  Created by Balachandran on 01/02/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNFilesVC.h"
#import "HNContentsTableViewCell.h"

@interface HNFilesVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary *filesData;
    NSMutableArray *files;
    NSMutableDictionary *videoData;
    NSMutableArray *videos;
}
@end

@implementation HNFilesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //mock data for events
    filesData = [[NSMutableDictionary alloc] init];
    [filesData setValue:@"DownloadIcon" forKey:@"btn_img"];
    [filesData setValue:@"Tips to become high roller" forKey:@"title"];
    [filesData setValue:@"10 February 2018" forKey:@"date"];
    files = [[NSMutableArray alloc] init];
    [files addObject:filesData];
    [files addObject:filesData];
    
    //mock data for promos
    videoData = [[NSMutableDictionary alloc] init];
    [videoData setValue:@"YoutubeIcon" forKey:@"btn_img"];
    [videoData setValue:@"James Ma Talk (LIVE)" forKey:@"title"];
    [videoData setValue:@"10 February 2018" forKey:@"date"];
    videos = [[NSMutableArray alloc] init];
    [videos addObject:videoData];
    [videos addObject:videoData];
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
    self.title = @"";
    self.ivFilesVideo.image = [UIImage imageNamed:@"EventImage.png"];
}

-(void)updateUIForVideos
{
    self.title = @"";
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
    }
    else
    {
        dataDict = [videos objectAtIndex:[indexPath row]];
    }
    [cell.btnAction setImage:[UIImage imageNamed:[dataDict valueForKey:@"btn_img"]] forState:UIControlStateNormal];
    cell.lblTitle.text = [dataDict valueForKey:@"title"];
    cell.lblDate.text = [dataDict valueForKey:@"date"];
    return cell;
}
@end
