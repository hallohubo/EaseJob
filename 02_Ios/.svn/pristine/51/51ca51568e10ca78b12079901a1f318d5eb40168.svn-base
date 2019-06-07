//
//  UIView+NJFrame.m
//  VideoAssistant
//
//  Created by TouchWorld on 2017/9/25.
//  Copyright © 2017年 qichen. All rights reserved.
//

#import "UIView+NJFrame.h"

@implementation UIView (NJFrame)
- (void)setNJ_x:(CGFloat)NJ_x
{
    CGRect fram = self.frame;
    fram.origin.x = NJ_x;
    self.frame = fram;
}
- (CGFloat)NJ_x
{
    return self.frame.origin.x;
}

- (void)setNJ_y:(CGFloat)NJ_y
{
    CGRect fram = self.frame;
    fram.origin.y = NJ_y;
    self.frame = fram;
}
- (CGFloat)NJ_y
{
    return self.frame.origin.y;
}

- (void)setNJ_width:(CGFloat)NJ_width
{
    CGRect fram = self.frame;
    fram.size.width = NJ_width;
    self.frame = fram;
}
- (CGFloat)NJ_width
{
    return self.frame.size.width;
}

- (void)setNJ_height:(CGFloat)NJ_height
{
    CGRect fram = self.frame;
    fram.size.height = NJ_height;
    self.frame = fram;
}
- (CGFloat)NJ_height
{
    return self.frame.size.height;
}

- (void)setNJ_centerX:(CGFloat)NJ_centerX
{
    CGPoint point = self.center;
    point.x = NJ_centerX;
    self.center = point;
}
- (CGFloat)NJ_centerX
{
    return self.center.x;
}

- (void)setNJ_centerY:(CGFloat)NJ_centerY
{
    CGPoint point = self.center;
    point.y = NJ_centerY;
    self.center = point;
}
- (CGFloat)NJ_centerY
{
    return self.center.y;
}

- (CGFloat)NJ_MaxX
{
    return CGRectGetMaxX(self.frame);
}
- (void)setNJ_MaxX:(CGFloat)NJ_MaxX
{
    CGRect fram = self.frame;
    fram.size.width = NJ_MaxX - fram.origin.x;
    self.frame = fram;
}

- (CGFloat)NJ_MaxY
{
    return CGRectGetMaxY(self.frame);
}
- (void)setNJ_MaxY:(CGFloat)NJ_MaxY
{
    CGRect fram = self.frame;
    fram.size.height = NJ_MaxY - fram.origin.y;
    self.frame = fram;
}

+ (instancetype)viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}
@end
