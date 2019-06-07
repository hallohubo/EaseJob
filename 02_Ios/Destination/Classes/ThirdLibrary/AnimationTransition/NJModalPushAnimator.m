//
//  NJModalPushAnimator.m
//  Destination
//
//  Created by TouchWorld on 2018/11/27.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJModalPushAnimator.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation NJModalPushAnimator
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //过场容器
    UIView * containerView = [transitionContext containerView];
    
    //FromVC
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * fromView = fromVC.view;
    fromView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [containerView addSubview:fromView];
    
    
    //ToVC
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * toView = toVC.view;
    toView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    [containerView addSubview:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
    } completion:^(BOOL finished) {
        BOOL cancelled = [transitionContext transitionWasCancelled];
        
        //设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:!cancelled];
    }];
    
}

@end
