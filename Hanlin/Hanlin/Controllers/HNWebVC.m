//
//  HNWebVC.m
//  Hanlin
//
//  Created by Selvam M on 1/26/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import "HNWebVC.h"

@interface HNWebVC ()

@end

@implementation HNWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.scalesPageToFit = YES;
    _webView.frame=self.view.bounds;
    
    [_webView loadHTMLString:_htmlString baseURL:nil];
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
