//
//  HNMenuVC.m
//  Hanlin
//
//  Created by BALACHANDRAN K on 27/01/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNMenuVC.h"

@interface HNMenuVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnRegisteredEventsHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *ivEventsPromotions;
@end

@implementation HNMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentButtonValueChanged:(id)sender {
    NSInteger selectedIndex = ((UISegmentedControl *)sender).selectedSegmentIndex;
    switch (selectedIndex) {
        case 0://selected events
        {
            [self updateUIForEvents];
        }
            break;
        case 1://selected promotions
        {
            [self updateUIForPromotions];
        }
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)updateUIForEvents
{
    self.ivEventsPromotions.image = [UIImage imageNamed:@"EventImage.png"]; self.btnRegisteredEventsHeightConstraint.constant = 40.0f;
}

-(void)updateUIForPromotions
{
    self.ivEventsPromotions.image = [UIImage imageNamed:@"PromoImage.png"]; self.btnRegisteredEventsHeightConstraint.constant = 0.0f;
}
@end
