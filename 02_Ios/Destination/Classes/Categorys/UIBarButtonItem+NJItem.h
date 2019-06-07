//
//  UIBarButtonItem+NJItem.h
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/12.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (NJItem)

/**
 返回item，有设置好高亮图片的

 @param normalImage 普通状态下的图片
 @param highLightImage 高亮状态下的图片
 @param target 触发者
 @param action 事件
 @return 一个item
 */
+ (instancetype _Nullable )itemWithNormalImage:(UIImage *_Nullable)normalImage highLightImage:(UIImage *_Nullable)highLightImage target:(nullable id)target action:(SEL _Nonnull )action;
//返回按钮设置
+ (instancetype _Nullable )backItemWithNormalImage:(UIImage *_Nullable)normalImage highLightImage:(UIImage *_Nullable)highLightImage target:(id _Nullable )target action:(SEL _Nullable )action title:(NSString *_Nullable)title;
//返回一个item，有设置好选中图片的
+ (instancetype _Nullable )itemWithNormalImage:(UIImage *_Nullable)normalImage selectedImage:(UIImage *_Nullable)selectedImage target:(nullable id)target action:(SEL _Nullable )action;
@end
