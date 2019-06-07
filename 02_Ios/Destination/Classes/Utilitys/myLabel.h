//
//  myLabel.h
//  封装
//
//  Created by qianfeng0 on 16/1/19.
//  Copyright (c) 2016年 公司的名字. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myLabel : UILabel
+(UILabel*)labelWithFrame:(CGRect)frame Text:(NSString * )text BGColor:(UIColor *)color  TextColor:(UIColor *)textcolor FONT:(int)font;
@end
