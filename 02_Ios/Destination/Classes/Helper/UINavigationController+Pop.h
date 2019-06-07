//
//  UINavigationController+Pop.h
//  Demo
//
//  Created by hufan on 2017/12/29.
//  Copyright © 2017年 hufan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Pop)

- (void)popToViewControllerClass:(Class)controllerClass animated:(BOOL)animate;
- (void)popToIndex:(int)index animated:(BOOL)animate;
- (void)removeControllers:(NSArray *)controllers;
@end
