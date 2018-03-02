//
//  ContentsTableViewCell.h
//  Hanlin
//
//  Created by Balachandran on 01/02/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNContentsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;
- (IBAction)actionButtonClicked:(id)sender;
@end
