//
//  NJHorizontalMenuListView.m
//  Destination
//
//  Created by TouchWorld on 2018/10/16.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJHorizontalMenuListView.h"
#import "NJMenuItemView.h"
@interface NJHorizontalMenuListView ()
/********* <#注释#> *********/
@property(nonatomic,weak)UIView * menuContainerView;


/********* <#注释#> *********/
@property(nonatomic,strong)NSArray<NSDictionary *> * dataArr;


@end
@implementation NJHorizontalMenuListView



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
    UIView * menuContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 153, 68)];
    
    [self addSubview:menuContainerView];
    self.menuContainerView = menuContainerView;
    menuContainerView.backgroundColor = [UIColor clearColor];
    
    UIImageView * bgImageV = [[UIImageView alloc] initWithFrame:menuContainerView.bounds];
    bgImageV.image = [UIImage imageNamed:@"icon_combined_shape"];
    [menuContainerView addSubview:bgImageV];
    
    CGFloat shadowWidth = 10;
    UIView * containerView = [[UIView alloc] initWithFrame:CGRectMake(shadowWidth, shadowWidth, menuContainerView.NJ_width - 2 * shadowWidth, menuContainerView.NJ_height - 2 * shadowWidth)];
    [menuContainerView addSubview:containerView];
    containerView.backgroundColor = [UIColor clearColor];
    
    NSInteger count = self.dataArr.count;
    for (NSInteger i = 0; i < count; i++) {
        
        NSDictionary * dataDic = self.dataArr[i];
        CGFloat tempViewX = i * 66.5;
        NJMenuItemView * menuItemView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NJMenuItemView class]) owner:nil options:nil].firstObject;
        menuItemView.frame = CGRectMake(tempViewX, 0, 66.5, containerView.NJ_height);
        menuItemView.dataDic = dataDic;
        menuItemView.row = i;
        HDWeakSelf;
        menuItemView.didSelectedBlock = ^(NSInteger index) {
            if(weakSelf.didSelectedBlock != nil)
            {
                weakSelf.didSelectedBlock(weakSelf.row, index);
            }
        };
        
        [containerView addSubview:menuItemView];
        
        
        
    }
    
    
}



- (void)showWithSender:(UIView *)sender senderFrame:(CGRect)senderFrame
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGRect senderRect;
        if(sender)
        {
            senderRect = [sender.superview convertRect:sender.frame toView:self];
        }
        else
        {
            senderRect = senderFrame;
        }
        
        self.menuContainerView.center = CGPointMake(HDScreenW * 0.5, senderRect.origin.y + senderRect.size.height + self.menuContainerView.NJ_height * 0.5 - 10);
      
        self.hidden = NO;

        CAKeyframeAnimation * scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];

        scaleAnimation.values = @[@(0), @(1.2), @(1)];
        scaleAnimation.keyTimes  =  @[@(0), @(0.7), @(1.0)];
        scaleAnimation.beginTime = 0;
        scaleAnimation.duration = 0.3;

        scaleAnimation.repeatCount = 1;
        scaleAnimation.calculationMode = kCAAnimationCubic;
        [self.menuContainerView.layer addAnimation:scaleAnimation forKey:@"transform.scale"];
        
        
        
    });
}


- (void)dismiss
{
    self.hidden = YES;
}




#pragma mark - 懒加载
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

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * view = [super hitTest:point withEvent:event];
    if(view != nil && view == self)
    {
        if(self.hidden == NO)
        {
            [self dismiss];
        }
        return nil;
    }
    return view;
}

@end
