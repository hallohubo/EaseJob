//
//  HDUserModel.m
//  Demo
//
//  Created by hufan on 2017/3/8.
//  Copyright © 2017年 hufan. All rights reserved.
//

#import "HDUserModel.h"

#define USER_INFO    @"USER_INFO"    //用户信息key

@implementation HDUserModel

@end

@implementation HDLoginUserModel

+ (id)readFromLocal{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:USER_INFO];
    HDLoginUserModel *model = [HDLoginUserModel new];
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
    [[NSUserDefaults standardUserDefaults] setValue:mdc forKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearFromLocal{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
