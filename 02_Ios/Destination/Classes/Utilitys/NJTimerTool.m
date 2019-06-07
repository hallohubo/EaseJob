//
//  NJTimerTool.m
//  OctoberTen_验证码倒计时
//
//  Created by TouchWorld on 2017/10/10.
//  Copyright © 2017年 qichen. All rights reserved.
//

#import "NJTimerTool.h"
@interface NJTimerTool ()
/********* 定时器 *********/
@property(nonatomic,strong)NSTimer * timer;
/********* 时间 *********/
@property(nonatomic,assign)NSInteger time;
/********* 总共多少时间 *********/
@property(nonatomic,assign)NSInteger totalTime;
/********* <#注释#> *********/
@property(nonatomic,copy) void(^completed)(NSInteger time,BOOL isStop) ;



@end
@implementation NJTimerTool

- (instancetype)init
{
    if(self = [super init])
    {
        self.time = 60;
        self.totalTime = 60;
    }
    return self;
}

/**
 默认60秒

 */
- (instancetype)initWithTime:(NSInteger)time
{
    if(self = [super init])
    {
        self.totalTime = time <= 0 ? 60 : time;
        self.time = time <= 0 ? 60 : time;
    }
    return self;
}
- (void)addTimer:(void(^)(NSInteger time,BOOL isStop)) completed
{
    if(completed == nil)
    {
        NSLog(@"回调闭包（completed）不能为空");
        return;
    }
    self.completed = completed;
    
    if(self.timer == nil)
    {
//        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
//        self.timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            weakSelf.time -= 1;
//            NSLog(@"%ld",self.time);
//            if(weakSelf.time == 0)
//            {
//                //关闭定时器
//                [weakSelf removeTimer];
//                weakSelf.time = self.totalTime;
//                completed(self.time, YES);
//                return;
//            }
//            completed(weakSelf.time,NO);
//        }];
        
    }
    //启动定时器
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
   
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)resumeTimer:(void(^)(NSInteger time,BOOL isStop)) completed
{
    if(self.timer == nil && self.time != self.totalTime)
    {
        [self addTimer:completed];
        self.completed = completed;
    }
}
////启动定时器
//- (void)fireTimer
//{
//    self.time -= 1;
//    NSLog(@"%ld",self.time);
//    if(self.time == 0)
//    {
//        //关闭定时器
//        [self removeTimer];
//        self.time = self.totalTime;
//        self.completed(self.time, YES);
//        return;
//    }
//    __weak typeof(self) weakSelf = self;
//    self.completed(self.time, NO);
//
//}
#pragma mark - 事件
//计时
- (void)timerFireMethod:(NSTimer *)timer
{
    self.time -= 1;
//    NSLog(@"%ld",self.time);
    if(self.time == 0)
    {
        //关闭定时器
        [self removeTimer];
        self.time = self.totalTime;
        if(self.completed != nil)
        {
            self.completed(self.time, YES);
        }
        
        return;
    }
    if(self.completed != nil)
    {
        self.completed(self.time,NO);
    }
    else
    {
        NSLog(@"czx");
    }
}
#pragma mark - 懒加载
- (void)dealloc
{
    NSLog(@"%@",@"njtimerTool");
}
@end
