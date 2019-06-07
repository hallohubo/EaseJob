//
//  UITextField+NJPlaceHolder.m
//  June_nine_BuDeJie
//
//  Created by TouchWorld on 2017/6/14.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "UITextField+NJPlaceHolder.h"
#import <objc/message.h>
@implementation UITextField (NJPlaceHolder)
+ (void)load
{
    //1.获取setPlaceholder:的实现
    Method setPlaceholder = class_getInstanceMethod(self, @selector(setPlaceholder:));
    //2.获取setNJ_placeholder:的实现
    Method setNJ_placeholder = class_getInstanceMethod(self, @selector(setNJ_placeholder:));
    //3.交换实现
    method_exchangeImplementations(setPlaceholder, setNJ_placeholder);
}
//要求要设置占位文字后，再设置颜色，这样才有效。因为oc是懒加载机制
- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    //_placeholderLabel	id	0x0
    //placeHolder的类型是UILabel
    //1.获取占位文字的Label
    UILabel * placeHolderLabel = [self valueForKey:@"_placeholderLabel"];
    //2.设置颜色
    placeHolderLabel.textColor = placeHolderColor;
    //3.将颜色保存起来
    objc_setAssociatedObject(self, @"placeHolderColor", placeHolderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)placeHolderColor
{
    //1.获取保存的颜色
    return objc_getAssociatedObject(self, @"placeHolderColor");;
}
- (void)setNJ_placeholder:(NSString *)placeholder
{
    //1.设置占位文字
//    [self setNJ_placeholder:placeholder];
    //2.设置扩展的功能
    //2.1设置占位文字颜色
    self.placeHolderColor = self.placeHolderColor;
}
@end
