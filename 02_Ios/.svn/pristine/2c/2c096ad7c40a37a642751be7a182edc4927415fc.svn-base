//
//  NJAlertInputView.m
//  Destination
//
//  Created by TouchWorld on 2018/10/10.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJAlertInputView.h"
#import <SVProgressHUD.h>

#define ContainerViewWidth 270
#define ContainerViewHeight 168
#define ScreenSize [UIScreen mainScreen].bounds.size
@interface NJAlertInputView ()
/********* <#注释#> *********/
@property(nonatomic,weak)UIView * containerView;

/********* <#注释#> *********/
@property(nonatomic,weak)UIView * confirmBtn;

/********* <#注释#> *********/
@property(nonatomic,weak)UITextField * inputView;

/********* <#注释#> *********/
@property(nonatomic,weak)UILabel * titleLabel;

/********* <#注释#> *********/
@property(nonatomic,weak)UILabel * tipLabel;
@end
@implementation NJAlertInputView

+ (instancetype)alertInputView
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

#pragma mark - 设置初始化
- (void)setupInit
{
    self.autoDismiss = YES;
    self.alpha = 0;
    self.backgroundColor = NJGrayColorAlpha(0, 0.4);
    
    UIView * bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    
//    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
//    [bgView addGestureRecognizer:tapGesture];
    
    UIView * containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ContainerViewWidth, ContainerViewHeight)];
    
    containerView.center = CGPointMake(ScreenSize.width * 0.5, ScreenSize.height * 0.5);
    [self addSubview:containerView];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.masksToBounds = YES;
    containerView.layer.cornerRadius = 8.0;
    
    self.containerView = containerView;
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, containerView.NJ_width, 25)];
    [containerView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.text = @"人数限制";
    titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, titleLabel.NJ_MaxY + 11, containerView.NJ_width - 30, 13)];
    [containerView addSubview:tipLabel];
    self.tipLabel = tipLabel;
    tipLabel.text = @"出于安全考虑，最大组织人数为50人";
    tipLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular];
    tipLabel.textColor = NJGrayColor(153);
    tipLabel.textAlignment = NSTextAlignmentLeft;
    
    UITextField * inputView = [[UITextField alloc] initWithFrame:CGRectMake(15, tipLabel.NJ_MaxY + 9, containerView.NJ_width - 30, 34)];
    self.inputView = inputView;
    inputView.textColor = [UIColor blackColor];
    inputView.font = [UIFont systemFontOfSize:13.0];
    inputView.borderStyle = UITextBorderStyleRoundedRect;
//    inputView.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputView.clearsOnBeginEditing = YES;
    inputView.keyboardType = UIKeyboardTypeNumberPad;
    inputView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"在此输入人数" attributes:@{
                                                                                                       NSForegroundColorAttributeName : NJGrayColor(153)
                                                                                                       }];
    [containerView addSubview:inputView];
    
    //取消按钮
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(containerView.NJ_width - 47, 3, 42, 42);
    [cancelBtn setImage:[UIImage imageNamed:@"icon_close_play_windows"] forState:UIControlStateNormal];
    [containerView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn = confirmBtn;
    confirmBtn.frame = CGRectMake(0, inputView.NJ_MaxY + 24, containerView.NJ_width, 38);
    [containerView addSubview:confirmBtn];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:NJGreenColor forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
    
    UIView * seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, inputView.NJ_MaxY + 23, containerView.NJ_width, 0.5)];
    [containerView addSubview:seperatorView];
    seperatorView.backgroundColor = NJGrayColor(218);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - pickerView出现
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.inputView becomeFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1;
        
    }];
}
#pragma mark - pickerView消失
- (void)dismiss
{
    [self.inputView resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 事件 && 通知

- (void)confirmBtnClick
{
    if(self.inputTitleBlock != nil)
    {
        NSString * num = self.inputView.text;
        self.inputTitleBlock(num);
    }
    
    if(self.autoDismiss)
    {
        [self dismiss];
    }
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    //    HDLog(@"%@", notification);
    CGFloat duration = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect endFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat centerX = self.containerView.center.x;
    CGFloat centerY = endFrame.origin.y - ContainerViewHeight * 0.5 - 10;
    
    [UIView animateWithDuration:duration animations:^{
        self.containerView.center = CGPointMake(centerX, centerY);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    //     HDLog(@"%@", notification);
    CGFloat duration = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
//    CGRect endFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat centerX = self.containerView.center.x;
    [UIView animateWithDuration:duration animations:^{
        self.containerView.center = CGPointMake(centerX, ScreenSize.height * 0.5);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - setter
- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
}

- (void)setTipStr:(NSString *)tipStr
{
    _tipStr = tipStr;
    self.tipLabel.text = tipStr;
}

- (void)setPlaceholderStr:(NSString *)placeholderStr
{
    _placeholderStr = placeholderStr;
    self.inputView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderStr attributes:@{
                                                                                                             NSForegroundColorAttributeName : NJGrayColor(153)
                                                                                                             }];;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    self.inputView.keyboardType = keyboardType;
}

#pragma mark - 其他
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

