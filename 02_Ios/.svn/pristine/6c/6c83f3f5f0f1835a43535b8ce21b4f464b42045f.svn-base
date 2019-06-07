//
//  NJRewardView.m
//  Destination
//
//  Created by TouchWorld on 2018/10/24.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJRewardView.h"

#define containerViewHeight (307 + HOME_INDICATOR_HEIGHT)

@interface NJRewardView ()

@end
@implementation NJRewardView
static NJRewardView * shared;

+ (instancetype)rewardView
{
    return [[NJRewardView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupInit];
    }
    return self;
}

#pragma mark - 设置初始化
- (void)setupInit
{
//    self.backgroundColor = NJGrayColorAlpha(0, 0);
    
    UIView * bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:tapGesture];
    
    [self setupContainerView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - containerView
- (void)setupContainerView
{
    NJRewardListView * containerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NJRewardListView class]) owner:nil options:nil].firstObject;
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).mas_offset(containerViewHeight);
        make.height.mas_equalTo(containerViewHeight);
    }];
    
    self.containerView = containerView;
    containerView.backgroundColor = [UIColor whiteColor];
    HDWeakSelf;
    containerView.cancelBlock = ^{
        [weakSelf dismiss];
    };
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
    } completion:^(BOOL finished) {
        [self.containerView.moneyTextF becomeFirstResponder];
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

- (void)keyboardWillShow:(NSNotification *)notification
{
    //    HDLog(@"%@", notification);
    CGFloat duration = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect endFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
//    CGFloat centerX = self.containerView.center.x;
//    CGFloat centerY = endFrame.origin.y - containerViewHeight * 0.5 - 10;
    CGFloat offset = -endFrame.size.height + 187;
    
    //动画开始前，强制刷新
    [self layoutIfNeeded];
    
    [self.containerView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).mas_offset(offset);
    }];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:duration animations:^{
        //在动画中，强制刷新，产生动画效果
        [self layoutIfNeeded];
        self.backgroundColor = NJGrayColorAlpha(0, 0.4);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    //     HDLog(@"%@", notification);
    CGFloat duration = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    //    CGRect endFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
//    //动画开始前，强制刷新
//    [self layoutIfNeeded];
    
    [self.containerView updateConstraints:^(MASConstraintMaker *make) {
        //在动画中，强制刷新，产生动画效果
        [self layoutIfNeeded];
        make.bottom.mas_equalTo(self);
        
    }];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:duration animations:^{
        //在动画中，强制刷新，产生动画效果
        [self layoutIfNeeded];
        self.backgroundColor = NJGrayColorAlpha(0, 0.4);
    }];
}

#pragma mark - 其他
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
