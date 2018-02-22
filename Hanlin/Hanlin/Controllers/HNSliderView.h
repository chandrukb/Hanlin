//
//  HNSliderView.h
//  ImageSlider
//
//  Created by BALACHANDRAN K on 26/01/18.
//  Copyright © 2018 Balachandran Kaliyamoorthy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CSLazyLoadController/CSLazyLoadController.h>
@class HNSliderDelegate;

@protocol HNSliderDelegate <NSObject>

@optional
- (void)hnslider:(HNSliderDelegate *)hnslider didTapOnImage:(UIImage *)targetImage andParentView:(UIImageView *)targetView;

@end

@interface HNSliderView : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate, CSLazyLoadControllerDelegate> {
    
    id <HNSliderDelegate>_delegate;
    
}

@property (nonatomic, strong) id <HNSliderDelegate>delegate;
@property (nonatomic, strong) IBOutlet UIScrollView *sliderMainScroller;
@property (weak, nonatomic) IBOutlet UIPageControl *pageIndicator;
@property (nonatomic, strong) CSLazyLoadController *lazyLoadController;
- (void)createSliderWithImages:(NSArray *)images WithAutoScroll:(BOOL)isAutoScrollEnabled inView:(UIView *)parentView;
- (void)initializeLazyLoader;
-(void)startAutoPlay;
-(void)stopAutoPlay;
-(void)hidePageIndicator:(BOOL)shouldHide;

@end
