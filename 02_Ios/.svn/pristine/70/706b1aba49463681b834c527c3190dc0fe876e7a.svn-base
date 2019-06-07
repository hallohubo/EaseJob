//
//  NJPhotoBrowserDrivenInteractiveTransition.m
//  Destination
//
//  Created by TouchWorld on 2019/1/2.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "NJPhotoBrowserDrivenInteractiveTransition.h"
#import "NJPhotoBrowserTransitionParameter.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface NJPhotoBrowserDrivenInteractiveTransition ()
/********* <#注释#> *********/
@property(nonatomic,strong)NJPhotoBrowserTransitionParameter * transitionParameter;
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *gestureRecognizer;

@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UIView *fromView;

@property(nonatomic, strong) UIView *firstVCImgWhiteView;
@property(nonatomic, strong) UIView *blackBgView;
@end
@implementation NJPhotoBrowserDrivenInteractiveTransition

- (instancetype)initWithTransitionParameter:(NJPhotoBrowserTransitionParameter *)transitionParameter
{
    NSLog(@"----------------PercentDrivenInteractive init----------------");
    if(self = [super init])
    {
        _transitionParameter = transitionParameter;
        _gestureRecognizer = transitionParameter.gestureRecognizer;
        [_gestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];
    }
    return self;
}

- (CGFloat)percentForGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:gesture.view];
    
    CGFloat scale = 1 - (translation.y / HDScreenH);
    scale = scale < 0 ? 0 : scale;
    scale = scale > 1 ? 1 : scale;
    
    return scale;
}

- (void)gestureRecognizeDidUpdate:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat scrale = [self percentForGesture:gestureRecognizer];
    
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
            
            [self updateInteractiveTransition:[self percentForGesture:gestureRecognizer]];
            [self updateInterPercent:[self percentForGesture:gestureRecognizer]];
            
            break;
        case UIGestureRecognizerStateEnded:
            if (scrale > 0.95f){
                HDLog(@"取消过场动画---%lf", scrale);
                [self cancelInteractiveTransition];
                [self interPercentCancel];
            }
            else{
                [self finishInteractiveTransition];
                [self interPercentFinish:scrale];
            }
            break;
        default:
            [self cancelInteractiveTransition];
            [self interPercentCancel];
            break;
    }
}

- (void)beginInterPercent{
    NSLog(@"----------------开始----------------");
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    [containerView addSubview:toView];
    
    //图片背景白色的空白view
//    _firstVCImgWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    _firstVCImgWhiteView.backgroundColor = [UIColor whiteColor];
//    [containerView addSubview:_firstVCImgWhiteView];
    
    //有渐变的黑色背景
    _blackBgView = [[UIView alloc] initWithFrame:containerView.bounds];
    _blackBgView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:_blackBgView];
    
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    fromView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:fromView];
}

- (void)updateInterPercent:(CGFloat)scale{
    //        NSLog(@"变化");
    
    _blackBgView.alpha = scale * scale * scale;
}

- (void)interPercentCancel{
    NSLog(@"取消--");
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    fromView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:fromView];
    
    [_blackBgView removeFromSuperview];
//    [_firstVCImgWhiteView removeFromSuperview];
    _blackBgView = nil;
//    _firstVCImgWhiteView = nil;
    
//    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    [transitionContext completeTransition:NO];
    
}
//完成
- (void)interPercentFinish:(CGFloat)scale{
    NSLog(@"完成");
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    [containerView addSubview:toView];
    
    //图片背景白色的空白view
//    UIView *imgBgWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    imgBgWhiteView.backgroundColor =[UIColor whiteColor];
//    [containerView addSubview:imgBgWhiteView];
    
    //有渐变的黑色背景
    UIView *bgView = [[UIView alloc] initWithFrame:containerView.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = scale;
    [containerView addSubview:bgView];
    
    //过渡的图片
    UIImageView *transitionImgView = [[UIImageView alloc] initWithImage:self.transitionParameter.transitionImage];
    transitionImgView.clipsToBounds = YES;
    transitionImgView.frame = self.transitionParameter.currentPanGestImgFrame;
    [containerView addSubview:transitionImgView];
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        transitionImgView.frame = CGRectMake(ScreenWidth * 0.5, ScreenHeight * 0.5, 0, 0);
        bgView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
//        [_blackBgView removeFromSuperview];
//        [_firstVCImgWhiteView removeFromSuperview];
//        _blackBgView = nil;
//        _firstVCImgWhiteView = nil;
        
        [bgView removeFromSuperview];
//        [imgBgWhiteView removeFromSuperview];
        [transitionImgView removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    NSLog(@"--------startInteractiveTransition--------");
    [self beginInterPercent];
    if(self.transitionParameter.gestureRecognizer == nil)
    {
        [self cancelInteractiveTransition];
        [self interPercentCancel];
        return;
    }
    
}



#pragma mark - 其他
- (void)dealloc
{
    [self.gestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
}
@end
