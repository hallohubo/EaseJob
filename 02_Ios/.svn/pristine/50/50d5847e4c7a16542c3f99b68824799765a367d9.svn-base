//
//  NJValuePicker.h
//  Destination
//
//  Created by TouchWorld on 2019/1/16.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NJValuePicker : UIView
+ (instancetype)valuePicker;
/********* 数据 *********/
@property(nonatomic,strong)NSArray<NSString *> * dataArr;
/********* 设置默认选中行 *********/
@property(nonatomic,assign)NSInteger selectedRow;
/********* <#注释#> *********/
@property(nonatomic,weak)UILabel * titleLabel;
/********* <#注释#> *********/
@property(nonatomic,weak)UIButton * confirmBtn;
/********* <#注释#> *********/
@property(nonatomic,weak)UIButton * cancelBtn;

- (void)show;

- (void)dismiss;

/********* <#注释#> *********/
@property(nonatomic,copy)void (^completedBlock)(NSString * title, NSInteger index);

@end

NS_ASSUME_NONNULL_END
