//
//  HNProfileVC.m
//  Hanlin
//
//  Created by Selvam M on 1/26/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import "HNProfileVC.h"
#import "HRegisterVC.h"
#import "HNConstants.h"

@interface HNProfileVC ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLbl;
@property (weak, nonatomic) IBOutlet UILabel *userMobileLbl;
@property (weak, nonatomic) IBOutlet UILabel *userSinceLbl;
@property (weak, nonatomic) IBOutlet UILabel *userIdLbl;

@end

@implementation HNProfileVC

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //This need to be checked and refined while actual implementation
    if([segue.identifier isEqualToString:@"RegisterVCSegue"])
    {
        HRegisterVC *destinationVC = [segue destinationViewController];
        destinationVC.isFromProfile = YES;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Profile";
    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _userNameLbl.text = [defaults valueForKey:HN_LOGIN_NAME];
    _userEmailLbl.text = [defaults valueForKey:HN_LOGIN_USERNAME];
    _userMobileLbl.text = [defaults valueForKey:HN_LOGIN_PHONE];
    _userSinceLbl.text = [defaults valueForKey:HN_LOGIN_JOINDATE] ? [defaults valueForKey:HN_LOGIN_JOINDATE]: @"" ;
    _userIdLbl.text = [[NSUserDefaults standardUserDefaults] valueForKey:HN_LOGIN_USERID];
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

@end
