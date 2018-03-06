//
//  HNEventPromoDetailVC.h
//  Hanlin
//
//  Created by Balachandran on 01/02/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALPickerView.h"


@interface HNEventPromoDetailVC : UITableViewController<ALPickerViewDelegate>
{
    ALPickerView *CheckBoxpickerView;
    NSMutableDictionary *selectionStates;
    UIToolbar *CheckBoxtoolbar1;
    IBOutlet UIView *FooterView;
    NSString *JoiningDates;
}
@property(nonatomic) NSString *selectedOption;
//@property(nonatomic) NSDictionary *event;
@property(nonatomic, strong) UIImage *imgEventPromo;
@property(nonatomic) NSString *eventId;
@property(nonatomic) NSString *promoId;
@end
