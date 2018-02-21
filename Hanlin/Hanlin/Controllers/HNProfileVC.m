//
//  HNProfileVC.m
//  Hanlin
//
//  Created by Selvam M on 1/26/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import "HNProfileVC.h"
#import "HRegisterVC.h"

@interface HNProfileVC ()

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
