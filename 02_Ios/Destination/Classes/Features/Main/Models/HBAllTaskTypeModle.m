//
//  HBAllTaskTypeModle.m
//  Destination
//
//  Created by 胡勃 on 6/27/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBAllTaskTypeModle.h"

#define TASK_INFO    @"TASK_INFO"    //用户信息key

@implementation HBAllTaskTypeModle
+ (id)readFromLocal{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:TASK_INFO];
    HBAllTaskTypeModle *model = [HBAllTaskTypeModle new];
    model = [HDHttpHelper model:model fromDictionary:dic];
    return model;
}

- (void)saveToLocal{
    NSArray *ar_keys = [HDHttpHelper allProperties:self];
    NSMutableDictionary *mdc = [NSMutableDictionary new];
    for (int i = 0; i < ar_keys.count; i++) {
        NSString *key = ar_keys[i];
        NSString *s = [self valueForKey:key];
        [mdc setValue:HDSTR(s) forKey:key];
    }
    [[NSUserDefaults standardUserDefaults] setValue:mdc forKey:TASK_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearFromLocal{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TASK_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
