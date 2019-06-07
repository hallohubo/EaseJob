//
//  NJCOmmentPopAnimator.m
//  Destination
//
//  Created by TouchWorld on 2018/11/29.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJCommentPopAnimator.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation NJCommentPopAnimator
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //过场容器
    UIView * containerView = [transitionContext containerView];
    
    //ToVC
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    if(!CGRectEqualToRect(self.fromViewFrame, CGRectZero))
    {
        toView.frame = self.fromViewFrame;
    }
    HDLog(@"toView:%@", NSStringFromCGRect(toView.frame));
    //    toView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [containerView addSubview:toView];
    
    //maskView
    UIView * maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    [containerView addSubview:maskView];
    
    //FromVC
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * fromView = fromVC.view;
    UIColor * oldFromViewBgColor = fromView.backgroundColor;
    fromView.backgroundColor = [UIColor clearColor];
    fromView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [containerView addSubview:fromView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
        maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    } completion:^(BOOL finished) {
        BOOL cancelled = [transitionContext transitionWasCancelled];
//        fromView.backgroundColor = oldFromViewBgColor;
        [maskView removeFromSuperview];
        
        //设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:!cancelled];
    }];
    
    
    
}
@end
