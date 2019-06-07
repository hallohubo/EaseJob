//
//  NJCommentPresentationVC.m
//  Destination
//
//  Created by TouchWorld on 2018/11/28.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJCommentPresentationVC.h"
@interface NJCommentPresentationVC ()
/********* <#注释#> *********/
@property(nonatomic,strong)UIView * bgView;

@end
@implementation NJCommentPresentationVC
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    if(self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController])
    {
        
    }
    return self;
}

// 覆写此方法来设置呈现的视图控制器的尺寸
- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect presentedViewFrame = CGRectZero;
    CGRect containerBounds = self.containerView.bounds;
    presentedViewFrame.size = CGSizeMake(containerBounds.size.width, containerBounds.size.height - STATUS_BAR_HEIGHT);
    presentedViewFrame.origin.y = containerBounds.size.height - presentedViewFrame.size.height;
    return presentedViewFrame;
}

- (void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
}

- (void)containerViewDidLayoutSubviews
{
    [super containerViewDidLayoutSubviews];
}

- (void)presentationTransitionWillBegin
{
    self.bgView.frame = self.containerView.bounds;
    [self.containerView insertSubview:self.bgView atIndex:0];
    
    self.bgView.alpha = 0;
    
    UIViewController * presentedViewControlelr = [self presentedViewController];
    if([presentedViewControlelr transitionCoordinator])
    {
        [[presentedViewControlelr transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            self.bgView.alpha = 1.0;
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
        }];
    }
    else
    {
        self.bgView.alpha = 1.0;
    }
}


- (void)presentationTransitionDidEnd:(BOOL)completed
{
    //没有完成过程动画
    if(!completed)
    {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }
    
}



- (void)dismissalTransitionWillBegin
{
    UIViewController * presentedVC = [self presentedViewController];
    if([presentedVC transitionCoordinator])
    {
        [[presentedVC transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            self.bgView.alpha = 0.0;
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            [self.bgView removeFromSuperview];
            self.bgView = nil;
        }];
    }
    else
    {
        self.bgView.alpha = 0.0;
    }
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    //转场动画未完成
    if(!completed)
    {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }
}

- (void)bgViewClick
{
    
}

#pragma mark - 懒加载
- (UIView *)bgView
{
    if(_bgView == nil)
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewClick)];
        [_bgView addGestureRecognizer:tapGesture];
    }
    return _bgView;
}
@end
