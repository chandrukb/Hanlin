//
//  HNFilesVC.h
//  Hanlin
//
//  Created by Balachandran on 01/02/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNFilesVC : UIViewController
{
    
    UIView *TopView;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *btnSegmentControl;
- (IBAction)segmentControlSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *contentTableview;
@property (weak, nonatomic) IBOutlet UIImageView *ivFilesVideo;

@end
