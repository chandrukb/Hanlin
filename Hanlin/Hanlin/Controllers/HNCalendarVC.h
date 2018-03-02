//
//  BasicViewController.h
//  Example
//
//  Created by Jonathan Tribouharet.
//

#import <UIKit/UIKit.h>
#import "HNCalendarTableViewCell.h"

#import <JTCalendar/JTCalendar.h>

@interface HNCalendarVC : UIViewController<JTCalendarDelegate>
{
    NSArray *responseArray;
}

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet UIButton *PlusBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *calendarTableView;


@end


