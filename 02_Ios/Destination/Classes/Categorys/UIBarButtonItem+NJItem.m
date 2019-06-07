//
//  UIBarButtonItem+NJItem.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/12.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "UIBarButtonItem+NJItem.h"

@implementation UIBarButtonItem (NJItem)
+ (instancetype)itemWithNormalImage:(UIImage *)normalImage highLightImage:(UIImage *)highLightImage target:(id)target action:(SEL)action
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:highLightImage forState:UIControlStateHighlighted];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -26, 0, 0);
    //绑定事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    btn.frame = CGRectMake(0, 0, 40, 44);
    //为btn添加一个容器，解决按钮点范围的问题
    UIView * viewContainer = [[UIView alloc]initWithFrame:btn.frame];
    [viewContainer addSubview:btn];
    return [[self alloc]initWithCustomView:viewContainer];

}
+ (instancetype)backItemWithNormalImage:(UIImage *)normalImage highLightImage:(UIImage *)highLightImage target:(id)target action:(SEL)action title:(NSString *)title
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:highLightImage forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    //往左偏移
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    //添加事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //设置容器
    UIView * viewContainer = [[UIView alloc]initWithFrame:btn.frame];
    [viewContainer addSubview:btn];
    return [[UIBarButtonItem alloc]initWithCustomView:viewContainer];
    
}
+ (instancetype)itemWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage target:(nullable id)target action:(SEL)action
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateSelected];
    //绑定事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
//    btn.frame = CGRectMake(0, 0, 30, 44);
    
    //为btn添加一个容器，解决按钮点击范围的问题
    UIView * viewContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, NAVIGATION_BAR_HEIGHT)];
    btn.center = viewContainer.center;
    [viewContainer addSubview:btn];
    return [[self alloc]initWithCustomView:viewContainer];
}
@end
