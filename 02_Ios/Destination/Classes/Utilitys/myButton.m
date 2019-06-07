//
//  myButton.m
//  封装
//
//  Created by qianfeng0 on 16/1/19.
//  Copyright (c) 2016年 公司的名字. All rights reserved.
//

#import "myButton.h"

@implementation myButton

+(UIButton *)buttonWithFrame:(CGRect)frame BGClolor:(UIColor *)color Title:(NSString *)title
                 NormalImage:(UIImage *) normalImage Tag:(int)tag Method:(SEL)method Object:(id)object{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =frame;
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = tag;
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button addTarget:object action:method forControlEvents:UIControlEventTouchUpInside];
   
    return  button;

}

@end
