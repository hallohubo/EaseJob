//
//  NJCommonTool.m
//  SmartCity
//
//  Created by TouchWorld on 2018/5/24.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import "NJCommonTool.h"

@implementation NJCommonTool
static NJCommonTool * tool;
+ (instancetype)shareInstance
{
    if(tool == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            tool = [[NJCommonTool alloc] init];
        });
    }
    return tool;
}


- (UIImage *)screenShot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



+ (CGFloat)DegreesToRadian:(CGFloat)degrees
{
    return M_PI * degrees / 180.0;
}

+ (CGFloat)radianToDegrees:(CGFloat)radian
{
    return radian * 180 / M_PI;
}

- (UIWindow *)getWindow
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray * windowArr = [UIApplication sharedApplication].windows;
        for (id item in windowArr) {
            if([item class] == [UIWindow class])
            {
                UIWindow * itemWindow = (UIWindow *)item;
                if(!itemWindow.hidden && itemWindow.windowLevel == UIWindowLevelNormal)
                {
                    window = itemWindow;
                    break;
                }
            }
        }
    }
    return window;
}


- (UIViewController *)currentViewController
{
    UIViewController *result = nil;
    
    //获取window
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    //获取当前控制器
    UIView * frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }
    else {
        result = window.rootViewController;
    }
    
    //判断是否是navigationController
    if([result isKindOfClass:[UINavigationController class]])
        result = [((UINavigationController *)result).viewControllers lastObject];
    //判断是否是tabBarController
    if([result isKindOfClass:[UITabBarController class]]){
        result = ((UITabBarController *)result).selectedViewController;
        
        //判断是否是navigationController
        if([result class] == [UINavigationController class])
        {
            result = ((UINavigationController *)result).viewControllers.lastObject;
        }
    }
    
    return result;
}

//前往设置界面
- (void)openAppSetting
{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
@end
