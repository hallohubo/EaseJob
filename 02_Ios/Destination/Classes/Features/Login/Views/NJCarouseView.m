//
//  NJCarouseView.m
//  Destination
//
//  Created by TouchWorld on 2019/1/8.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "NJCarouseView.h"
#import "NJLoginCarouseImageItem.h"
#define AnimationKey @"NJCarouseViewAnimation"
@interface NJCarouseView ()
/********* contentView *********/
@property(nonatomic,weak)UIView * contentView;
/********* <#注释#> *********/
@property(nonatomic,strong)CAAnimationGroup * animationGroup;

@end
@implementation NJCarouseView
static CGFloat const ScrollTime = 10.0;

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
    self.backgroundColor = [UIColor redColor];
    self.scrollTime = ScrollTime;
    self.scrollOffSetY = 0;
    self.scrollDistance = 50;
    
    [self setupContentView];
}

#pragma mark - contentView
- (void)setupContentView
{
    UIView * contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    
    self.contentView = contentView;
}

#pragma mark - setter
- (void)setCarouseImageArr:(NSArray<NJLoginCarouseImageItem *> *)carouseImageArr
{
    _carouseImageArr = carouseImageArr;
    CGFloat imageVY = 0;
    for (NJLoginCarouseImageItem * item in carouseImageArr) {
        UIImageView * imageV = [[UIImageView alloc] initWithImage:item.carouseImage];
        [self.contentView addSubview:imageV];
        
        imageV.frame = CGRectMake(0, imageVY,  item.imageViewWidth, item.imageViewHeight);
        imageVY += item.imageViewHeight;
    }
    
    self.contentView.frame = CGRectMake(0, 0, HDScreenW * 0.5, imageVY);
}

- (void)setScrollOffSetY:(CGFloat)scrollOffSetY
{
    _scrollOffSetY = scrollOffSetY;
    
    self.contentView.NJ_y = -scrollOffSetY;
}


#pragma mark - 其他
- (void)beginAnimation
{
    if(self.animationGroup == nil)
    {
        self.contentView.NJ_y = -self.scrollOffSetY;
        [self addScrollAnimation];
        HDLog(@"添加动画");
    }
    
}
- (void)removeAnimation
{
    [self.contentView.layer removeAnimationForKey:AnimationKey];
    self.animationGroup = nil;
    HDLog(@"移除动画");
}

- (void)addScrollAnimation
{
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    self.animationGroup = animationGroup;
    animationGroup.repeatCount = CGFLOAT_MAX;
    animationGroup.duration = self.scrollTime;
    //动画完成后不移除
    animationGroup.removedOnCompletion = NO;
    //完成后处于最后的状态
    animationGroup.fillMode = kCAFillModeForwards;
    //动画由初始值到最终值后，是否反过来回到初始值的动画。如果设置为YES，就意味着动画完成后会以动画的形式回到初始值。
    animationGroup.autoreverses = YES;
    
    
    id toValue;
    if(self.direction == NJCarouseViewScrollDirectionUp)
    {
        toValue = @(self.scrollDistance);
    }
    else
    {
        toValue = @(-self.scrollDistance);
    }
    
    CABasicAnimation * firtstAnimation = [self getAnimationWithKeyPath:@"transform.translation.y" toValue:toValue beginTime:0 duration:self.scrollTime];
    
    animationGroup.animations = @[firtstAnimation];
    
    [self.contentView.layer addAnimation:animationGroup forKey:AnimationKey];
    
    
}

- (CABasicAnimation *)getAnimationWithKeyPath:(NSString *)keyPath toValue:(id)toValue beginTime:(CFTimeInterval)beginTime duration:(CFTimeInterval)duration
{
    CABasicAnimation * basicAnimation = [[CABasicAnimation alloc] init];
    basicAnimation.keyPath = keyPath;
    basicAnimation.toValue = toValue;
    basicAnimation.beginTime = beginTime;
    basicAnimation.duration = duration;
    //线性动画
//    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //动画完成后不移除
    basicAnimation.removedOnCompletion = NO;
    //完成后处于最后的状态
    basicAnimation.fillMode = kCAFillModeForwards;
    
    return basicAnimation;
}

- (void)dealloc
{
    [self removeAnimation];
}
@end
