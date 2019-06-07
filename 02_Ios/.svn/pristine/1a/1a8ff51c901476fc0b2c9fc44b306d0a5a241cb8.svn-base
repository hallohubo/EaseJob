//
//  NJHorizontalMenuView.m
//  Destination
//
//  Created by TouchWorld on 2018/10/16.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJHorizontalMenuView.h"
#import <SVProgressHUD.h>


@interface NJHorizontalMenuView ()
/********* <#注释#> *********/
@property(nonatomic,strong)UIView * sender;
/********* <#注释#> *********/
@property(nonatomic,assign)CGRect senderFrame;

/********* bgView *********/
@property(nonatomic,strong)UIView * bgView;

/********* <#注释#> *********/
@property(nonatomic,strong)UIView * containerView;

/********* <#注释#> *********/
@property(nonatomic,strong)NSArray<NSDictionary *> * dataArr;


@end
@implementation NJHorizontalMenuView
static NJHorizontalMenuView * shared;

+ (instancetype)sharedInstance
{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[NJHorizontalMenuView alloc] init];
        shared.backgroundColor = [UIColor greenColor];
    });
    return shared;
}


#pragma mark - 设置初始化



#pragma mark - pickerView出现
+ (void)showWithSender:(UIView *)sender senderFrame:(CGRect)senderFrame
{
    [[self sharedInstance] showWithSender:sender senderFrame:senderFrame];
}

- (void)showWithSender:(UIView *)sender senderFrame:(CGRect)senderFrame
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self backgroundWindow] addSubview:self.bgView];
        
        CGRect senderRect;
        if(sender)
        {
            senderRect = [sender.superview convertRect:sender.frame toView:self.bgView];
        }
        else
        {
            senderRect = senderFrame;
        }
        
        self.containerView.center = CGPointMake(HDScreenW * 0.5, 0);
        self.containerView.NJ_y = senderRect.origin.y + senderRect.size.height;
        
        
        [self show];
    });
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
//        self.containerView.center = CGPointMake(self.frame.size.width/2, self.containerView.center.y - self.containerView.frame.size.height);
    }];
}
#pragma mark - pickerView消失
+ (void)dismiss{
    [shared dismiss];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.4 animations:^{
//        self.containerView.center = CGPointMake(self.frame.size.width/2, self.containerView.center.y + self.containerView.frame.size.height);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

#pragma mark - setter


#pragma mark - 事件

#pragma mark - 懒加载
- (UIView *)bgView
{
    if(_bgView == nil)
    {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_bgView addSubview:self.containerView];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        _bgView.backgroundColor = [UIColor clearColor];
        [_bgView addGestureRecognizer:tapGesture];
        
        
    }
    return _bgView;
}

- (UIView *)containerView
{
    if(_containerView == nil)
    {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 133, 48)];
        [self addSubview:_containerView];
        
        
        _containerView.backgroundColor = [UIColor clearColor];
        
        UIImageView * bgImageV = [[UIImageView alloc] initWithFrame:_containerView.bounds];
        bgImageV.image = [UIImage imageNamed:@"icon_combined_shape"];
        [_containerView addSubview:bgImageV];
        
        NSInteger count = self.dataArr.count;
        for (NSInteger i = 0; i < count; i++) {
            
            NSDictionary * dataDic = self.dataArr[i];
            CGFloat tempViewX = i * 66.5;
            UIView * tempView = [[UIView alloc] initWithFrame:CGRectMake(tempViewX, 0, 66.5, _containerView.frame.size.height)];
            [_containerView addSubview:tempView];

            UIImageView * iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(26, 12, 15, 15)];
            [tempView addSubview:iconImageV];
            iconImageV.image = [UIImage imageNamed:dataDic[@"img"]];
            
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tempView.NJ_height - 21, tempView.NJ_width, 21)];
            titleLabel.text = dataDic[@"title"];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:9];
            titleLabel.textColor = NJGrayColor(51);
            [tempView addSubview:titleLabel];
        }
        
        
    }
    return _containerView;
}

- (NSArray<NSDictionary *> *)dataArr
{
    if(_dataArr == nil)
    {
        _dataArr = @[
                     @{
                         @"title" : @"图片",
                         @"img" : @"icon_post_image"
                         },
                     @{
                         @"title" : @"文字",
                         @"img" : @"icon_post_text"
                         },
                     ];
    }
    return _dataArr;
}

- (UIWindow *)backgroundWindow {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    if (window == nil && [delegate respondsToSelector:@selector(window)]){
        window = [delegate performSelector:@selector(window)];
    }
    return window;
}

@end
