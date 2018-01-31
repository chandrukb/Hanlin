//
//  HNEventPromotionVC.m
//  Hanlin
//
//  Created by Balachandran on 30/01/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNEventPromotionVC.h"
#import "HNEventPromotionCell.h"

@interface HNEventPromotionVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary *eventData;
    NSMutableArray *events;
    NSMutableDictionary *promoData;
    NSMutableArray *promos;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *btnSegmentControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnRegisteredEventsHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *ivScreenBG;
@property (weak, nonatomic) IBOutlet UIImageView *ivEventsPromotions;
@property (weak, nonatomic) IBOutlet UITableView *eventPromoTableView;
@end

@implementation HNEventPromotionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.eventPromoTableView registerClass:[HNEventPromotionCell class] forCellReuseIdentifier:@"EventPromoCell"];
    
    //mock data for events
    eventData = [[NSMutableDictionary alloc] init];
    [eventData setValue:@"profile_image.png" forKey:@"event_img"];
    [eventData setValue:@"How to be successful like James Ma" forKey:@"event_title"];
    [eventData setValue:@"10 February 2018" forKey:@"event_date"];
    events = [[NSMutableArray alloc] init];
    [events addObject:eventData];
    
    //mock data for promos
    promoData = [[NSMutableDictionary alloc] init];
    [promoData setValue:@"profile_image.png" forKey:@"promo_img"];
    [promoData setValue:@"Buy One Free One Buffet Dinner" forKey:@"promo_title"];
    [promoData setValue:@"10 February 2018" forKey:@"promo_date"];
    promos = [[NSMutableArray alloc] init];
    [promos addObject:promoData	];
    
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
    [self.eventPromoTableView reloadData];
}

-(void)updateUIForEvents
{
    self.title = @"Event";
    self.ivEventsPromotions.image = [UIImage imageNamed:@"EventImage.png"]; self.btnRegisteredEventsHeightConstraint.constant = 40.0f;
}

-(void)updateUIForPromotions
{
    self.title = @"Promotion";
    self.ivEventsPromotions.image = [UIImage imageNamed:@"PromoImage.png"]; self.btnRegisteredEventsHeightConstraint.constant = 0.0f;
}

#pragma mark- TableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    if(self.btnSegmentControl.selectedSegmentIndex == 0)
    {
        rowCount = [events count];
    }
    else
    {
        rowCount = [promos count];
    }
    return rowCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNEventPromotionCell *cell = (HNEventPromotionCell *) [tableView dequeueReusableCellWithIdentifier:@"EventPromoCell"];
    if(self.btnSegmentControl.selectedSegmentIndex == 0)
    {
        cell.ivEventPromo.image = [UIImage imageNamed:[[events objectAtIndex:[indexPath row]] valueForKey:@"event_img"]];
        cell.lblTitle.text = [[events objectAtIndex:[indexPath row]] valueForKey:@"event_title"];
        cell.lblDate.text = [[events objectAtIndex:[indexPath row]] valueForKey:@"event_date"];
    }
    else
    {
        cell.ivEventPromo.image = [UIImage imageNamed:[[promos objectAtIndex:[indexPath row]] valueForKey:@"promo_img"]];
        cell.lblTitle.text = [[promos objectAtIndex:[indexPath row]] valueForKey:@"promo_title"];
        cell.lblDate.text = [[promos objectAtIndex:[indexPath row]] valueForKey:@"promo_date"];
    }
    return cell;

}

@end
