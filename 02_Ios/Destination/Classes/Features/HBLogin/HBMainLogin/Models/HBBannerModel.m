//
//  HBBannerModel.m
//  Destination
//
//  Created by 胡勃 on 6/19/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBBannerModel.h"

@implementation HBBannerModel
+ (id)readFromLocal{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:@"BANNER_MODEL"];
    HBBannerModel *model = [HBBannerModel new];
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
    [[NSUserDefaults standardUserDefaults] setValue:mdc forKey:@"BANNER_MODEL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearFromLocal{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"BANNER_MODEL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
