//
//  NJPaymentView.m
//  Destination
//
//  Created by TouchWorld on 2018/12/15.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJPaymentView.h"

//#import "NJPictureFeeItem.h"

#define containerViewHeight (307 + HOME_INDICATOR_HEIGHT)
@interface NJPaymentView ()
/********* containerView *********/
@property(nonatomic,weak)UIView * containerView;



@end
@implementation NJPaymentView
+ (instancetype)paymentView
{
    return [[NJPaymentView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if([super initWithFrame:frame])
    {
        [self setupInit];
    }
    return self;
}

#pragma mark - 设置初始化
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

#pragma mark - containerView
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
    
    [containerView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(containerView);
    }];
}

- (NJPayContentView *)contentView
{
    if(_contentView == nil)
    {
        HDWeakSelf;
        _contentView = [NJPayContentView NJ_loadViewFromXib];
        _contentView.cancelBlock = ^{
            [weakSelf dismiss];
        };                                      
    }
    return _contentView;
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



@end
