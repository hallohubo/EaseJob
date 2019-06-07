//
//  NJCommentModalAnimationTransition.m
//  Destination
//
//  Created by TouchWorld on 2018/11/28.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJCommentModalAnimationTransition.h"
#import "NJCommentPresentationVC.h"

@interface NJCommentModalAnimationTransition ()

@end
@implementation NJCommentModalAnimationTransition

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    NJCommentPresentationVC * presentationVC = [[NJCommentPresentationVC alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    return presentationVC;
}

@end
