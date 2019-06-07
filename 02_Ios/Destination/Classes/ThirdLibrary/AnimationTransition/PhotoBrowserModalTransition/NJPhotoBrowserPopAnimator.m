//
//  NJPhotoBrowserPopAnimator.m
//  NJPhotoBrowserDemo
//
//  Created by TouchWorld on 2018/11/27.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJPhotoBrowserPopAnimator.h"
#import "NJPhotoBrowserTransitionParameter.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation NJPhotoBrowserPopAnimator
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
    toView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [containerView addSubview:toView];
    
    //FromVC
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * fromView = fromVC.view;
    fromView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    fromView.alpha = 1.0;
    [containerView addSubview:fromView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        BOOL cancelled = [transitionContext transitionWasCancelled];
        
        //设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:!cancelled];
    }];

}
@end
