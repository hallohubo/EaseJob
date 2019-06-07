//
//  NJCommonTool.h
//  SmartCity
//
//  Created by TouchWorld on 2018/5/24.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJCommonTool : NSObject
+ (instancetype)shareInstance;


/**
 截图

 @param view 要切图的view
 @return 图片
 */
- (UIImage *)screenShot:(UIView *)view;

/**
 角度转换弧度
 
 @param degrees 角度
 @return 弧度
 */
+ (CGFloat)DegreesToRadian:(CGFloat)degrees;

/**
 弧度转换角度

 @param radian 弧度
 @return 角度
 */
+ (CGFloat)radianToDegrees:(CGFloat)radian;


/**
 获取窗口

 @return window
 */
- (UIWindow *)getWindow;


/**
 获取当前控制器

 @return vc
 */
- (UIViewController *)currentViewController;

//前往设置界面
- (void)openAppSetting;
@end
