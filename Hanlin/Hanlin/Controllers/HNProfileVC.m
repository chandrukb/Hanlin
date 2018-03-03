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
#import <CSLazyLoadController/CSLazyLoadController.h>


@interface HNProfileVC ()<CSLazyLoadControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLbl;
@property (weak, nonatomic) IBOutlet UILabel *userMobileLbl;
@property (weak, nonatomic) IBOutlet UILabel *userSinceLbl;
@property (weak, nonatomic) IBOutlet UILabel *userIdLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (nonatomic, strong) CSLazyLoadController *lazyLoadController;


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

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _userNameLbl.text = [defaults valueForKey:HN_LOGIN_NAME];
    _userEmailLbl.text = [defaults valueForKey:HN_LOGIN_USERNAME];
    _userMobileLbl.text = [defaults valueForKey:HN_LOGIN_PHONE];
    _userSinceLbl.text = [defaults valueForKey:HN_LOGIN_JOINDATE] ? [defaults valueForKey:HN_LOGIN_JOINDATE]: @"" ;
    _userSinceLbl.text = [NSString stringWithFormat:@"会员加入 : %@",_userSinceLbl.text];
    _userIdLbl.text = [NSString stringWithFormat:@"会员证号: %@",[[NSUserDefaults standardUserDefaults] valueForKey:HN_LOGIN_USERID]];
    
    NSString *imageUrl = [defaults valueForKey:HN_LOGIN_PROFILE_IMG];
    NSLog(@"profile url: %@",[HN_ROOTURL stringByAppendingString:imageUrl]);
    UIImage *image = [self.lazyLoadController fastCacheImage:[CSURL URLWithString:[HN_ROOTURL stringByAppendingString:imageUrl]]]; // Find image in RAM memory.
    self.userImgView.image = image;
    // If there is no image download it
    if (!image) {
        NSIndexPath *indexpath = [[NSIndexPath alloc] init];
        indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.lazyLoadController startDownload:[CSURL URLWithString:[HN_ROOTURL stringByAppendingString:imageUrl] parameters:nil method:CSHTTPMethodPOST]
                                  forIndexPath:indexpath];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帐号";
    self.lazyLoadController = [[CSLazyLoadController alloc] init];
    self.lazyLoadController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Lazyloader Delegate
// Controller asks us for URL so give him image URL
- (CSURL *)lazyLoadController:(CSLazyLoadController *)loadController
       urlForImageAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *imageUrl = [defaults valueForKey:HN_LOGIN_PROFILE_IMG];
    return (imageUrl.length > 0) ? [CSURL URLWithString:[HN_ROOTURL stringByAppendingString:imageUrl]]:nil;
}

// Image has finished with downloading so update the cell
- (void)lazyLoadController:(CSLazyLoadController *)loadController
            didReciveImage:(UIImage *)image
                   fromURL:(CSURL *)url
                 indexPath:(NSIndexPath *)indexPath {
    self.userImgView.image = image;
}

@end
