//
//  SlideViewControllerViewController.h
//  SlideViewController
//
//  Created by fmj on 14-4-21.
//  Copyright (c) 2014年 fmj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideViewControllerViewController : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic,retain) NSArray* viewControllers;

@end

@interface FMSlideViewControllerSegue : UIStoryboardSegue

@property (strong) void(^performBlock)( FMSlideViewControllerSegue* segue, UIViewController* svc, UIViewController* dvc );

@end