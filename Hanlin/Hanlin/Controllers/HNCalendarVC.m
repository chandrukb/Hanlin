//
//  BasicViewController.m
//  Example
//
//  Created by Jonathan Tribouharet.
//

#import "HNCalendarVC.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import <CSLazyLoadController/CSLazyLoadController.h>
#import "HNConstants.h"
#import "JSON.h"
#import "HNCalendarDetailVC.h"


@interface HNCalendarVC (){
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    NSDate *_dateSelected;
    
    NSMutableDictionary *eventData;
    NSMutableArray *events;
}

@end

@implementation HNCalendarVC

-(void)viewWillAppear:(BOOL)animated
{
    _dateSelected=[NSDate date];
    [self grabEventDetailInBackground];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _PlusBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    [self.navigationItem.backBarButtonItem setTitle:@""];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    [self createMinAndMaxDate];
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
}

#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    [_calendarManager setDate:_todayDate];
}

- (IBAction)didChangeModeTouch
{
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    
    CGFloat newHeight = 300;
    if(_calendarManager.settings.weekModeEnabled){
        newHeight = 85.;
    }
    
    self.calendarContentViewHeight.constant = newHeight;
    [self.view layoutIfNeeded];
}

#pragma mark - CalendarManager delegate

// Example of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    [self UpdateSelectedDateList];
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UIView *)menuItemView date:(NSDate *)date
{
    NSDateFormatter *dateFormatter;
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy";
    [(UILabel *)menuItemView setTextColor:[UIColor whiteColor]];
    [(UILabel *)menuItemView setText:[[dateFormatter stringFromDate:date] uppercaseString]];
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 6 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-6];
    
    // Max date will be 6 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:6];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return dateFormatter;
}

- (NSDateFormatter *)dateFormatterFromServer
{
    static NSDateFormatter *dateFormatterFromServer;
    if(!dateFormatterFromServer){
        dateFormatterFromServer = [NSDateFormatter new];
        dateFormatterFromServer.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return dateFormatterFromServer;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    return NO;
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    for(id a in responseArray)
    {
        NSDate *randomDate=[[self dateFormatterFromServer] dateFromString:[[a objectForKey:@"userevents"]valueForKey:@"eventdate"]];
        
        if(randomDate!=nil)
        {
            NSString *key = [[self dateFormatter] stringFromDate:randomDate];
            
            if(!_eventsByDate[key]){
                _eventsByDate[key] = [NSMutableArray new];
            }
            [_eventsByDate[key] addObject:randomDate];
        }
        // Use the date as key for eventsByDate
        // eventObj = [[events objectAtIndex:[indexPath row]] objectForKey:@"userevents"];
    }
    [_calendarManager reload];
}

- (void)grabEventDetailInBackground
{
    events=[[NSMutableArray alloc]init];
    NSDateFormatter* MonthdateFormatter = [[NSDateFormatter alloc]init];
    [MonthdateFormatter setDateFormat:@"MM"];
    
    NSDateFormatter* YearFormatter = [[NSDateFormatter alloc]init];
    [YearFormatter setDateFormat:@"yyyy"];
    
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_GET_MY_EVENTS]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue: [[NSUserDefaults standardUserDefaults] valueForKey:HN_LOGIN_USERID] forKey:@"userid"];
    [request setCompletionBlock:^{
        //handle the request
        if (request.responseStatusCode == 400) {
            NSLog(@"Invalid code");
        } else if (request.responseStatusCode == 403) {
            NSLog(@"Code already used");
        } else if (request.responseStatusCode == 200) {
            NSString *resString = [request responseString];
            responseArray = [resString JSONValue];
            
            NSLog(@"==>%@",responseArray);
            [self UpdateSelectedDateList];
            [self createRandomEvents];
            request = nil;
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        request = nil;
    }];
    [request startAsynchronous];
}

-(void)UpdateSelectedDateList
{
    [events removeAllObjects];
    NSString *keySelectedDate = [[self dateFormatter] stringFromDate:_dateSelected];
    for(id a in responseArray)
    {
        if([[[a objectForKey:@"userevents"]objectForKey:@"eventdate"] containsString:keySelectedDate])
        {
            [events addObject:a];
        }
    }
    [_calendarManager reload];
    [self.calendarTableView reloadData];
}

#pragma mark- TableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNCalendarTableViewCell *cell = (HNCalendarTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"HNCalendarTableViewCell"];
    
    NSDictionary *eventObj = [[NSDictionary alloc] init];
    eventObj = [[events objectAtIndex:[indexPath row]] objectForKey:@"userevents"];
    
    cell.lblTitle.text = [eventObj valueForKey:@"title"];
    cell.lblDate.text = [eventObj valueForKey:@"eventdate"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDictionary *eventObj = [[NSDictionary alloc] init];
    eventObj = [[events objectAtIndex:[indexPath row]] objectForKey:@"userevents"];
    
    HNCalendarDetailVC *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"HNCalendarDetailVC"];
    newView.GetSelecteddate=[dateFormatter stringFromDate:_dateSelected];
    newView.GetEvents=eventObj;
    [self.navigationController pushViewController:newView animated:YES];
}

-(IBAction)AddNewEvent:(id)sender
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    HNCalendarDetailVC *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"HNCalendarDetailVC"];
    newView.GetSelecteddate=[dateFormatter stringFromDate:_dateSelected];
    [self.navigationController pushViewController:newView animated:YES];
}

@end
