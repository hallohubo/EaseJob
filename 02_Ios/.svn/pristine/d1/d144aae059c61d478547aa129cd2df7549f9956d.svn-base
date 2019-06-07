//
//  UIView+NJCommon.h
//  ConsumptionPlus
//
//  Created by TouchWorld on 2017/10/13.
//  Copyright © 2017年 qichen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NJCommon)

/**
 添加圆角边框

 @param width 线宽
 @param color 颜色
 @param cornerRadius 圆角半径
 */
- (void)addBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;


/**
 添加虚线边框

 @param lineWidth 虚线的宽度
 @param lineColor 虚线的颜色
 */
- (void)addDottedBorderWithLineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor;


/**
 添加虚线边框

 @param lineWidth 虚线的宽度
 @param lineColor 虚线的颜色
 @param frame 尺寸
 */
- (void)addDottedBorderWithLineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor viewFrame:(CGRect)frame;

// 从 XIB 中加载视图
+ (instancetype)NJ_loadViewFromXib;


/**
 绘画对应的角为圆角
 
 @param rectCornet 哪几个角
 @param size 大小
 */
- (void)addCornerRadius:(UIRectCorner)rectCornet size:(CGSize)size;


/**
 添加阴影

 @param color 颜色
 @param shadowOffset 偏移
 @param shadowOpacity 透明度
 @param shadowRadius 圆角半径
 */
- (void)addShadowWithColor:(UIColor *)color shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius;

/**
 绘画圆角
 
 @param radius 半径
 */
- (void)addAllCornerRadius:(CGFloat)radius;


/**
 获取当前view的响应对象

 @return vc
 */
- (UIViewController *)viewController;
@end
