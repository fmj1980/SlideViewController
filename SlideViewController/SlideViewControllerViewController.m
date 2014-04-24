//
//  SlideViewControllerViewController.m
//  SlideViewController
//
//  Created by fmj on 14-4-21.
//  Copyright (c) 2014年 fmj. All rights reserved.
//

#import "SlideViewControllerViewController.h"

#define FM_SEGUE_STR @"FM_SEGUE_"


@interface SlideViewControllerViewController ()

@property(nonatomic) int currentIndex;

@end

@implementation SlideViewControllerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView
{
    _currentIndex = 0;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIView* view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:[UIColor redColor]];
    self.view = view;
    [self loadSegueViewControllers];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture.delegate = self;
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    [view addGestureRecognizer:panGesture];
    
    if ( self.viewControllers.count> 0 ) {
        [self.view addSubview:[self.viewControllers.firstObject view]];
    }
}
-(void)setCurrentIndex:(int)currentIndex
{
    _currentIndex = currentIndex;
}
-(void)handlePanGesture:(UIPanGestureRecognizer*)pan
{
    if (![pan isKindOfClass:[UIPanGestureRecognizer class]]) {
        return;
    }
    
    NSLog(@"currentIndex:%d",_currentIndex);
    UIView* firsetView = (UIView*)self.view.subviews.firstObject;
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        UIView* secondView = (UIView*)self.view.subviews.lastObject;
        if ( firsetView == secondView ) {
            return;
        }
        CGFloat deltaX = firsetView.frame.origin.x;
        if (fabs(deltaX)>firsetView.frame.size.width/2) {
            [firsetView removeFromSuperview];
            [secondView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionLayoutSubviews animations:^{
//                [secondView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//            } completion:nil];
            
            self.currentIndex =  self.currentIndex + (deltaX<0?1:-1);
        }
        else
        {
            [secondView removeFromSuperview];
            [firsetView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }
    }
    else if(pan.state == UIGestureRecognizerStateCancelled )
    {
        UIView* secondView = (UIView*)self.view.subviews.lastObject;
        if ( firsetView == secondView ) {
            return;
        }
        [secondView removeFromSuperview];
        [firsetView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    }
    else if(pan.state == UIGestureRecognizerStateBegan)
    {
        
    }
    else
    {
        CGPoint translate = [pan translationInView:self.view];
        UIView* currentView = [[self.viewControllers objectAtIndex:self.currentIndex] view];

        int secondIndex = translate.x< 0?self.currentIndex+1:self.currentIndex-1;
        if (secondIndex<0 || secondIndex>self.viewControllers.count-1) {
            return;
        }
        
        UIView* secondView = [[self.viewControllers objectAtIndex:secondIndex] view];
        NSUInteger index = [self.view.subviews indexOfObject:secondView];
        if (index == NSNotFound) {
            [secondView setFrame:CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
            [self.view addSubview:secondView];
        }
        if (translate.x<0) {
            [secondView setFrame:CGRectMake(self.view.frame.size.width+translate.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
            [firsetView setFrame:CGRectMake(self.view.frame.origin.x+translate.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        }
        else
        {
            [secondView setFrame:CGRectMake(-self.view.frame.size.width+translate.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
            [firsetView setFrame:CGRectMake(self.view.frame.origin.x+translate.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.view != self.view) {
        return NO;
    }
    if (self.viewControllers.count == 0) {
        return NO;
    }
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translate = [pan translationInView:self.view];
        
        if (translate.x > 0 && self.view.subviews.firstObject == [self.viewControllers.firstObject view]) {
            return NO;
        }
        
        if (translate.x < 0 && self.view.subviews.lastObject == [self.viewControllers.lastObject view]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

#pragma mark For StoryBoard

-(void)prepareForSegue:(FMSlideViewControllerSegue *)segue sender:(id)sender
{
    NSString* identifer = segue.identifier;
    NSRange range = [identifer rangeOfString:FM_SEGUE_STR];
    if ( range.location == 0 && range.length > 0 ) {
        
        segue.performBlock = ^( FMSlideViewControllerSegue* segue, UIViewController* source, UIViewController* dest )
        {
            if (self.viewControllers == nil) {
                self.viewControllers = [[NSMutableArray alloc] init];
            }
            
            NSMutableArray* controllers = (NSMutableArray*)self.viewControllers;
            [controllers addObject:dest];
        };
    }
}

-(void)loadSegueViewControllers
{
    int i = 0;
    while(true){
        @try
        {
            NSString* segue = [NSString stringWithFormat:@"%@%d",FM_SEGUE_STR,i];
            [self performSegueWithIdentifier:segue sender:nil];
        }
        @catch(NSException *exception) {
            if (i>5) {
                break;
            }
        }
        i++;
    }
}
@end


@implementation FMSlideViewControllerSegue

-(void)perform
{
    if (self.performBlock) {
        self.performBlock(self,self.sourceViewController,self.destinationViewController);
    }
    else
    {
        [super perform];
    }
}

@end