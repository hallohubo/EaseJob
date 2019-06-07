//
//  NJAlertInputView.h
//  Destination
//
//  Created by TouchWorld on 2018/10/10.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NJAlertInputView : UIView

+ (instancetype)alertInputView;

/********* 标题 *********/
@property(nonatomic,copy)NSString * titleStr;

/********* 提示 *********/
@property(nonatomic,copy)NSString * tipStr;

/********* 占位文字 *********/
@property(nonatomic,copy)NSString * placeholderStr;

/********* 键盘类型 *********/
@property(nonatomic,assign)UIKeyboardType keyboardType;


- (void)show;

- (void)dismiss;

/********* <#注释#> *********/
@property(nonatomic,assign)BOOL autoDismiss;


/********* <#注释#> *********/
@property(nonatomic,copy)void (^inputTitleBlock)(NSString * num);

@end

NS_ASSUME_NONNULL_END
