//
//  HNEventPromoDetailVC.m
//  Hanlin
//
//  Created by Balachandran on 01/02/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNEventPromoDetailVC.h"

@interface HNEventPromoDetailVC ()

@end

@implementation HNEventPromoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem.backBarButtonItem setTitle:@""];
    if([self.selectedOption isEqualToString:@"promos"]){
        self.title = @"Promotion";
    }
    if([self.selectedOption isEqualToString:@"events"]){
        self.title = @"Event";
    }
    
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
