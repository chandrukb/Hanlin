//
//  HNMenuVC.m
//  Hanlin
//
//  Created by BALACHANDRAN K on 27/01/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNMenuVC.h"
#import <CSLazyLoadController/CSLazyLoadController.h>
#import "HNConstants.h"

@interface HNMenuVC ()<CSLazyLoadControllerDelegate>

@property (nonatomic, strong) CSLazyLoadController *lazyLoadController;
@end

@implementation HNMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    [self.navigationItem.backBarButtonItem setTitle:@""];
    
    // Do any additional setup after loading the view.
    self.lazyLoadController = [[CSLazyLoadController alloc] init];
    self.lazyLoadController.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *imageUrl = [defaults valueForKey:HN_LOGIN_PROFILE_IMG];
    NSLog(@"profile url: %@",[HN_ROOTURL stringByAppendingString:imageUrl]);
    UIImage *image = [self.lazyLoadController fastCacheImage:[CSURL URLWithString:[HN_ROOTURL stringByAppendingString:imageUrl]]]; // Find image in RAM memory.
    self.ivProfileImage.image = image;
    // If there is not image download it
    if (!image) {
        NSIndexPath *indexpath = [[NSIndexPath alloc] init];
        indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.lazyLoadController startDownload:[CSURL URLWithString:[HN_ROOTURL_APP stringByAppendingString:imageUrl] parameters:nil method:CSHTTPMethodPOST]
                                  forIndexPath:indexpath];
    }
    self.lblFullName.text = [defaults valueForKey:HN_LOGIN_NAME];
    self.lblEmail.text = [defaults valueForKey:HN_LOGIN_USERNAME];
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
    self.ivProfileImage.image = image;  
}

@end
