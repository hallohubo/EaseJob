//
//  NJBadgeView.m
//  Destination
//
//  Created by TouchWorld on 2018/12/6.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJBadgeView.h"

@implementation NJBadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupInit];
    }
    return self;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if(self.window)
    {
        [self updateFrame];
    }
}



#pragma mark - 设置初始化
- (void)setupInit
{
    self.count = 0;
    self.margin = 0;
    self.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = NJColor(255, 34, 14);
    self.textColor = [UIColor whiteColor];
    [self addAllCornerRadius:self.NJ_height * 0.5];
 
}

#pragma mark - setter
- (void)updateFrame
{
    self.hidden = self.count == 0;
    if(self.count == 0)
    {
        return;
    }
    
//    NSString * titleStr = [NSString stringWithFormat:@"%ld", self.count];
//    if(self.count > 99)
//    {
//        titleStr = @"99+";
//    }
    
//    self.text = titleStr;
//    CGFloat width = self.NJ_height;
//    if(titleStr.length > 1)
//    {
//        width = [titleStr sizeWithAttributes:@{
//                                                       NSFontAttributeName : self.font
//                                                       }].width + 2 * self.margin;
//    }
//
//    CGRect badgeFrame = self.frame;
//    badgeFrame.size.width = width;
    
//    self.bounds = CGRectMake(0, 0, badgeFrame.size.width, badgeFrame.size.height);
    self.bounds = CGRectMake(0, 0, 6,6);
    
    
    
}

- (void)setCount:(NSInteger)count
{
    _count = count;
    [self updateFrame];
}

@end
