//
//  AppDelegate.h
//  Destination
//
//  Created by TouchWorld on 2018/9/25.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CYLTabBarController.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
/********* tabBarController旧的选中下标 *********/
@property(nonatomic,assign)NSInteger oldSelectedIndex;


@end

