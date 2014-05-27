//
//  SlideViewControllerViewController.h
//  SlideViewController
//
//  Created by fmj on 14-4-21.
//  Copyright (c) 2014年 fmj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideViewControllerDelegate;

@interface SlideViewController : UIViewController

@property(nonatomic,retain) NSArray* viewControllers;
@property(nonatomic,retain) id<SlideViewControllerDelegate> delegate;

@end


@interface FMSlideViewControllerSegue : UIStoryboardSegue

@property (strong) void(^performBlock)( FMSlideViewControllerSegue* segue, UIViewController* svc, UIViewController* dvc );

@end


@protocol SlideViewControllerDelegate <NSObject>

@optional
-(void)willChangeFrom:(UIViewController*)from to:(UIViewController*)to;
-(void)didChangeFrom:(UIViewController*)from to:(UIViewController*)to;
-(void)cancelChangeFrom:(UIViewController*)from to:(UIViewController*)to;

@end