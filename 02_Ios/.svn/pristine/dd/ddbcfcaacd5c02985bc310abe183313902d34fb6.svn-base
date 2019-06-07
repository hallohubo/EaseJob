//
//  NJPhotoBrowserModalAnimationTransition.m
//  NJPhotoBrowserDemo
//
//  Created by TouchWorld on 2018/11/27.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJPhotoBrowserModalAnimationTransition.h"
#import "NJPhotoBrowserPushAnimator.h"
#import "NJPhotoBrowserPopAnimator.h"
#import "NJPhotoBrowserDrivenInteractiveTransition.h"

@interface NJPhotoBrowserModalAnimationTransition ()
/********* <#注释#> *********/
@property(nonatomic,strong)NJPhotoBrowserDrivenInteractiveTransition * percentIntractive;

/********* <#注释#> *********/
@property(nonatomic,strong)NJPhotoBrowserPushAnimator * pushAnimator;
/********* <#注释#> *********/
@property(nonatomic,strong)NJPhotoBrowserPopAnimator * popAnimator;

@end
@implementation NJPhotoBrowserModalAnimationTransition
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.pushAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.popAnimator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;//push时不加手势交互
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    if(self.transitionParameter.gestureRecognizer != nil)
    {
        return self.percentIntractive;
    }
    return nil;
}


- (NJPhotoBrowserPushAnimator *)pushAnimator
{
    if(_pushAnimator == nil)
    {
        _pushAnimator = [[NJPhotoBrowserPushAnimator alloc] init];
    }
    return _pushAnimator;
}

- (NJPhotoBrowserPopAnimator *)popAnimator
{
    if(_popAnimator == nil)
    {
        _popAnimator = [[NJPhotoBrowserPopAnimator alloc] init];
    }
    return _popAnimator;
}

- (NJPhotoBrowserDrivenInteractiveTransition *)percentIntractive
{
    if(_percentIntractive == nil)
    {
        _percentIntractive = [[NJPhotoBrowserDrivenInteractiveTransition alloc] initWithTransitionParameter:self.transitionParameter];
    }
    return _percentIntractive;
}

- (void)setTransitionParameter:(NJPhotoBrowserTransitionParameter *)transitionParameter
{
    _transitionParameter = transitionParameter;
    self.pushAnimator.transitionParameter = transitionParameter;
    self.popAnimator.transitionParameter = transitionParameter;
}
@end
