//
//  NJRecursiveItem.m
//  Destination
//
//  Created by TouchWorld on 2018/11/14.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJRecursiveItem.h"

@implementation NJRecursiveItem
- (instancetype)initWithReServedInfo:(NSDictionary *)reServedInfo data:(id)data
{
    if(self = [super init])
    {
        self.reServedInfo = reServedInfo;
        self.data = data;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"reServedInfo=%@ -- data=%@", _reServedInfo, _data];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"debug：reServedInfo=%@ -- data=%@", _reServedInfo, _data];
}
@end
