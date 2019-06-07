//
//  NSDate+NJCommonDate.m
//  Destination
//
//  Created by TouchWorld on 2018/11/7.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NSDate+NJCommonDate.h"

@implementation NSDate (NJCommonDate)

+ (NSString *)currentDateFormatter
{
    return [[[self alloc] init] formatterDate:@"yyyy-MM-dd"];
}
//yyyy-MM-dd HH:mm:ss
- (NSString *)formatterDate:(NSString *)formatterStr
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatterStr];
    NSString * dateStr = [dateFormatter stringFromDate:self];
    return dateStr;
}
@end
