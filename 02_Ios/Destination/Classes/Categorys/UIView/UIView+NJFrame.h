//
//  UIView+NJFrame.h
//  VideoAssistant
//
//  Created by TouchWorld on 2017/9/25.
//  Copyright © 2017年 qichen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NJFrame)
/********* x坐标 *********/
@property(nonatomic,assign)CGFloat NJ_x;
/********* y坐标 *********/
@property(nonatomic,assign)CGFloat NJ_y;
/********* width坐标 *********/
@property(nonatomic,assign)CGFloat NJ_width;
/********* height坐标 *********/
@property(nonatomic,assign)CGFloat NJ_height;
/********* 中心x坐标 *********/
@property(nonatomic,assign)CGFloat NJ_centerX;
/********* 中心y坐标 *********/
@property(nonatomic,assign)CGFloat NJ_centerY;
/********* 最大x值 *********/
@property(nonatomic,assign)CGFloat NJ_MaxX;
/********* 最大y值 *********/
@property(nonatomic,assign)CGFloat NJ_MaxY;
/********* 从xib中加载视图 *********/
+ (instancetype)viewFromXib;
@end
