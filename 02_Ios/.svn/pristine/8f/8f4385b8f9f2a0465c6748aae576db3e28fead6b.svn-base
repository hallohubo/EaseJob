//
//  NJTimerTool.h
//  OctoberTen_验证码倒计时
//
//  Created by TouchWorld on 2017/10/10.
//  Copyright © 2017年 qichen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJTimerTool : NSObject
//添加定时器
- (void)addTimer:(void(^)(NSInteger time,BOOL isStop)) completed;
//移除定时器
- (void)removeTimer;
//恢复定时器
- (void)resumeTimer:(void(^)(NSInteger time,BOOL isStop)) completed;

/**
 默认60秒
 */
- (instancetype)initWithTime:(NSInteger)time;

@end
