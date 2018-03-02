//
//  HNMenuVC.m
//  Hanlin
//
//  Created by BALACHANDRAN K on 27/01/18.
//  Copyright © 2018 BALACHANDRAN K. All rights reserved.
//

#import "HNMenuVC.h"
#import "AppDelegate.h"
#import <CSLazyLoadController/CSLazyLoadController.h>
#import "HNConstants.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "JSON.h"
#import "HNUtility.h"

@interface HNMenuVC ()<CSLazyLoadControllerDelegate>

@property (nonatomic, strong) CSLazyLoadController *lazyLoadController;
@end

@implementation HNMenuVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    [self.navigationItem.backBarButtonItem setTitle:@""];
    
    //Notification register device token call
    [self prepareRequest];
    
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
        [self.lazyLoadController startDownload:[CSURL URLWithString:[HN_ROOTURL stringByAppendingString:imageUrl] parameters:nil method:CSHTTPMethodPOST]
                                  forIndexPath:indexpath];
    }
    self.lblFullName.text = [defaults valueForKey:HN_LOGIN_NAME];
    self.lblEmail.text = [defaults valueForKey:HN_LOGIN_USERNAME];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-Service call methods
-(void)prepareRequest
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    // Start request
    NSURL *url = [NSURL URLWithString:[HN_ROOTURL stringByAppendingString:HN_PUSH_NOTIFICATION]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUseKeychainPersistence:YES];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:HN_LOGIN_USERID] forKey:HN_LOGIN_USERID];
    [request setPostValue:appdelegate.strDeviceToken forKey:@"devicetoken"];
    [request setPostValue:@"ios" forKey:@"devicetype"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //handle the request
    if (request.responseStatusCode == 400) {
        NSLog(@"Invalid code");
    } else if (request.responseStatusCode == 403) {
        NSLog(@"Code already used");
    } else if (request.responseStatusCode == 200) {
        NSString *resString = [request responseString];
        NSArray *responseArray = [resString JSONValue];
        NSDictionary *response = responseArray[0];
        BOOL responseStatus = [[response valueForKey:@"success"] boolValue];
        NSString * message = [response valueForKey:@"msg"];
        if(responseStatus == true)
        {
            NSLog(@"Nofifcation Service: %@",message);
        }
        else
        {
        }
    } else {
        NSLog(@"Unexpected error");
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error : %@",error.localizedDescription);
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
