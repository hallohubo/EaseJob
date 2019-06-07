//
//  NJCommentAnimationTransition.m
//  Destination
//
//  Created by TouchWorld on 2018/11/29.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJCommentAnimationTransition.h"
#import "NJCommentPushAnimatior.h"
#import "NJCommentPopAnimator.h"
@interface NJCommentAnimationTransition ()
/********* <#注释#> *********/
@property(nonatomic,strong)NJCommentPushAnimatior * pushAnimator;
/********* <#注释#> *********/
@property(nonatomic,strong)NJCommentPopAnimator * popAnimator;

@end
@implementation NJCommentAnimationTransition
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if(operation == UINavigationControllerOperationPush)
    {
        return self.pushAnimator;
    }
    else if(operation == UINavigationControllerOperationPop)
    {
        self.popAnimator.fromViewFrame = self.pushAnimator.fromViewFrame;
        return self.popAnimator;
    }
    return nil;
}


- (NJCommentPushAnimatior *)pushAnimator
{
    if(_pushAnimator == nil)
    {
        _pushAnimator = [[NJCommentPushAnimatior alloc] init];
    }
    return  _pushAnimator;
}

- (NJCommentPopAnimator *)popAnimator
{
    if(_popAnimator == nil)
    {
        _popAnimator = [[NJCommentPopAnimator alloc] init];
    }
    return _popAnimator;
}
@end
