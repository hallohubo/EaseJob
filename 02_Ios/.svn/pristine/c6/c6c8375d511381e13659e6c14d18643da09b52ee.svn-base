//
//  NJModalNaviAnimationTransition.m
//  Destination
//
//  Created by TouchWorld on 2018/11/27.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJModalNaviAnimationTransition.h"
#import "NJModalPushAnimator.h"
#import "NJModalPopAnimator.h"
@interface NJModalNaviAnimationTransition ()
/********* <#注释#> *********/
@property(nonatomic,strong)NJModalPushAnimator * pushAnimator;
/********* <#注释#> *********/
@property(nonatomic,strong)NJModalPopAnimator * popAnimator;

@end
@implementation NJModalNaviAnimationTransition
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


- (NJModalPushAnimator *)pushAnimator
{
    if(_pushAnimator == nil)
    {
        _pushAnimator = [[NJModalPushAnimator alloc] init];
    }
    return  _pushAnimator;
}

- (NJModalPopAnimator *)popAnimator
{
    if(_popAnimator == nil)
    {
        _popAnimator = [[NJModalPopAnimator alloc] init];
    }
    return _popAnimator;
}
@end
