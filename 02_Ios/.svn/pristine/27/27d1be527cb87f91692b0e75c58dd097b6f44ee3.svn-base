//
//  UIViewController+NJViewControllerBar.m
//  Destination
//
//  Created by TouchWorld on 2018/9/29.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import "UIViewController+NJViewControllerBar.h"

@implementation UIViewController (NJViewControllerBar)

- (CGFloat)myStatusbarHeight
{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

- (CGFloat)myNavigationBarHeight
{
    CGFloat statusHeight = [self myStatusbarHeight];
    return self.navigationController.navigationBar.frame.size.height + statusHeight;
}

- (CGFloat)myTabbarHeight
{
    return self.tabBarController.tabBar.bounds.size.height;
}
@end
