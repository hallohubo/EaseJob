//
//  NJUserItem.m
//  ConsumptionPlus
//
//  Created by TouchWorld on 2017/11/4.
//  Copyright © 2017年 qichen. All rights reserved.
//

#import "NJUserItem.h"
#import <objc/runtime.h>

@implementation NJUserItem
//编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    encodeRuntime(NJUserItem);

}
//解码
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    initCoderRuntime(NJUserItem);
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"user_id" : @"id"
             };
}


@end
