//
//  NJPhotoBrowserAnimationTransition.m
//  NJPhotoBrowserDemo
//
//  Created by TouchWorld on 2018/11/27.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJPhotoBrowserNaviAnimationTransition.h"
#import "NJPhotoBrowserPushAnimator.h"
#import "NJPhotoBrowserPopAnimator.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface NJPhotoBrowserNaviAnimationTransition ()
/********* <#注释#> *********/
@property(nonatomic,strong)NJPhotoBrowserPushAnimator * pushAnimator;
/********* <#注释#> *********/
@property(nonatomic,strong)NJPhotoBrowserPopAnimator * popAnimator;

@end
@implementation NJPhotoBrowserNaviAnimationTransition

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if(operation == UINavigationControllerOperationPush)
    {
        return self.pushAnimator;
    }
    else if(operation == UINavigationControllerOperationPop)
    {
        return self.popAnimator;
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
@end
