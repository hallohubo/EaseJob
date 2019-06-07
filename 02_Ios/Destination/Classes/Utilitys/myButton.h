//
//  myButton.h
//  封装
//
//  Created by qianfeng0 on 16/1/19.
//  Copyright (c) 2016年 公司的名字. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myButton : UIButton
+(UIButton *)buttonWithFrame:(CGRect)frame BGClolor:(UIColor *)color Title:(NSString *)title
                 NormalImage:(UIImage *) normalImage Tag:(int)tag Method:(SEL)method Object:(id)object;
@end
