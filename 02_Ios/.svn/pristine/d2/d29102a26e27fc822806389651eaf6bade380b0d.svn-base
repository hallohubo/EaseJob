//
//  UINavigationController+Pop.m
//  Demo
//
//  Created by hufan on 2017/12/29.
//  Copyright © 2017年 hufan. All rights reserved.
//

#import "UINavigationController+Pop.h"

@implementation UINavigationController (Pop)

- (void)popToViewControllerClass:(Class)controllerClass animated:(BOOL)animate{
    NSArray *ar = self.viewControllers;
    for (int i = 0; i < ar.count; i++) {
        UIViewController *ctr = ar[i];
        if ([ctr isKindOfClass:controllerClass]) {
            [self popToViewController:ctr animated:animate];
            return;
        }
    }
    Dlog(@"Wornning:UINavigationController has no object of class:%@", NSStringFromClass(controllerClass));
}

- (void)popToIndex:(int)index animated:(BOOL)animate{
     NSArray *ar = self.viewControllers;
    if (index < ar.count) {
        UIViewController *ctr = ar[index];
        [self.navigationController popToViewController:ctr animated:animate];
    }
}

- (void)removeControllers:(NSArray *)controllers{
    if (controllers.count == 0) {
        Dlog(@"Error:要移除的controller为空");
        return;
    }
    NSMutableArray *ar = [[NSMutableArray alloc] initWithArray:self.viewControllers];
    if (controllers.count > ar.count) {
        Dlog(@"Error:controller 比navigation里面的多");
        return;
    }
    
    for (int i = 0; i < ar.count; i++) {
        UIViewController *c = ar[i];
        for (int j = 0; j < controllers.count; j++) {
            UIViewController *ctr = controllers[j];
            if ([c.class isKindOfClass:ctr.class]) {
                [ar removeObjectAtIndex:i];
                i = 0;
                continue;
            }
        }
    }
    self.navigationController.viewControllers = ar;
}


@end








