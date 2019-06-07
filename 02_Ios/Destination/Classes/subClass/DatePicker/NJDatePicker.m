//
//  NJDatePicker.m
//  Destination
//
//  Created by TouchWorld on 2018/12/11.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJDatePicker.h"

#define containerViewHeight (294 + HOME_INDICATOR_HEIGHT)

@interface NJDatePicker ()
/********* <#注释#> *********/
@property(nonatomic,weak)UIView * containerView;
/********* <#注释#> *********/
@property(nonatomic,weak)UIDatePicker * datePicker;
@end

@implementation NJDatePicker
+ (instancetype)datePicker
{
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupInit];
    }
    return self;
}

- (void)setupInit
{
    self.backgroundColor = NJGrayColorAlpha(0, 0);
    
    UIView * bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:tapGesture];
    
    [self setupContainerView];
}

- (void)setupContainerView
{
    UIView * containerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).mas_offset(containerViewHeight);
        make.height.mas_equalTo(containerViewHeight);
    }];
    
    self.containerView = containerView;
    containerView.backgroundColor = NJGrayColor(126);
    
    UIView * toolView = [[UIView alloc] init];
    [containerView addSubview:toolView];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(containerView);
        make.height.mas_equalTo(44);
    }];
    toolView.backgroundColor = [UIColor whiteColor];
    
    
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
        make.top.left.bottom.mas_equalTo(toolView);
    }];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [cancelBtn setTitleColor:NJGreenColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
        make.top.right.bottom.mas_equalTo(toolView);
    }];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [confirmBtn setTitleColor:NJGreenColor forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    [toolView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(toolView);
        make.left.mas_equalTo(cancelBtn.mas_right).mas_offset(5);
        make.right.mas_equalTo(confirmBtn.mas_left).mas_offset(5);
    }];
    
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = NJGreenColor;
    titleLabel.text = @"日期选择器";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIView * seperatorView = [[UIView alloc] init];
    [toolView addSubview:seperatorView];
    [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(toolView);
        make.height.mas_equalTo(0.5);
    }];
    seperatorView.backgroundColor = NJBgColor;
    
    UIDatePicker * datePicker = [[UIDatePicker alloc] init];
    [containerView addSubview:datePicker];
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(containerView);
        make.top.mas_equalTo(toolView.mas_bottom);
    }];
    
 
//    if((self.modeltimetype=2)){
//
//        datePicker.datePickerMode =UIDatePickerModeDate;
//    }else{
//        datePicker.datePickerMode = UIDatePickerModeTime;
//    }
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor whiteColor];
    
    self.datePicker = datePicker;
}

#pragma mark - 事件
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    //动画开始前，强制刷新
    [self layoutIfNeeded];
    
    [self.containerView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        
    }];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        //在动画中，强制刷新，产生动画效果
        [self layoutIfNeeded];
        self.backgroundColor = NJGrayColorAlpha(0, 0.4);
    }];
}

- (void)dismiss
{
    [self.containerView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).mas_offset(containerViewHeight);
    }];
    
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        self.backgroundColor = NJGrayColorAlpha(0, 0);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


- (void)confirmBtnClick
{
    if(self.datePickerBlock != nil)
    {
        self.datePickerBlock(self.datePicker.date);
    }
    
    [self dismiss];
}

@end
