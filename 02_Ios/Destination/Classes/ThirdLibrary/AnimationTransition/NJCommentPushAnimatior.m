//
//  NJCommentPushAnimatior.m
//  Destination
//
//  Created by TouchWorld on 2018/11/29.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJCommentPushAnimatior.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation NJCommentPushAnimatior
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
//    fromView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.fromViewFrame = fromView.frame;
    [containerView addSubview:fromView];
    
    //maskView
    UIView * maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [containerView addSubview:maskView];
    
    //ToVC
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * toView = toVC.view;
    UIColor * oldToViewBgColor = toView.backgroundColor;
    toView.backgroundColor = [UIColor clearColor];
    toView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    self.toViewFrame = toView.frame;
    [containerView addSubview:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        
    } completion:^(BOOL finished) {
        BOOL cancelled = [transitionContext transitionWasCancelled];
        toView.backgroundColor = oldToViewBgColor;
        [maskView removeFromSuperview];
        //设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:!cancelled];
    }];
    
}


@end
