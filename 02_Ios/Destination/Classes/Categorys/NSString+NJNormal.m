//
//  NSString+NJNormal.m
//  VideoAssistant
//
//  Created by TouchWorld on 2017/11/12.
//  Copyright © 2017年 qichen. All rights reserved.
//

#import "NSString+NJNormal.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation NSString (NJNormal)
+ (NSString *)timeStampWithSubffix:(NSString *)subffix index:(NSInteger)index
{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%lld_%@",(long long)nowTime + index, subffix];
}

+ (NSString *)timeStampWithSubffix:(NSString *)subffix
{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%lld_%@",(long long)nowTime, subffix];
}
+ (NSString *)timeStampWithSubffix_Float:(NSString *)subffix
{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%lf_%@",nowTime, subffix];
}
+ (NSString *)formatterDateStrWithTime:(NSTimeInterval)time formatterStr:(NSString *)formatterStr
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = formatterStr;
    NSString * dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary * attributesDic = @{
                                     NSFontAttributeName : font,
                                    
                                     };
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributesDic context:nil].size;
    return size;
}


//MD5加密
- (NSString *)md5Str
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

//对象转JSON字符串
+ (NSString *)objectChangeToJson:(id)obj
{
    NSData * jsonData = [self objectChangeToJsonData:obj];
    if(jsonData == nil)
    {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//json转NSData
+ (NSData *)objectChangeToJsonData:(id)obj
{
    if([NSJSONSerialization isValidJSONObject:obj] == false)
    {
        NSLog(@"对象不能转换成JSON");
        return nil;
    }
    if([obj isKindOfClass:[NSArray class]])
    {
        obj = (NSArray *)obj;
    }
    else if([obj isKindOfClass:[NSDictionary class]])
    {
        obj = (NSDictionary *)obj;
    }
    NSError * error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    if(error == nil)
    {
        return data;
    }
    else
    {
        NSLog(@"%@",error.description);
        return nil;
    }
}

//json字符串转对象
+ (id)jsonChangeToObject:(NSString *)jsonStr
{
    NSData * jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if(error == nil)
    {
        return object;
    }
    else
    {
        NSLog(@"Json字符串转对象失败：%@",error);
        return nil;
    }
}

- (NSDate *)timeStrChangeToDateWithFormatter:(NSString *)formatter
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter dateFromString:self
            ];
}

//yyyy-MM-dd HH:mm:ss
- (NSString *)changeTimeStrFormatterFromFormatter:(NSString *)fromFormatter toFormatter:(NSString *)toFormatter
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = fromFormatter;
    NSDate * date = [dateFormatter dateFromString:self];
    if(date == nil)
    {
        NSLog(@"原日期格式不匹配");
        return @"";
    }
    
    dateFormatter.dateFormat = toFormatter;
    NSString * toDateStr = [dateFormatter stringFromDate:date];
    return toDateStr;
}

+ (NSString *)distanceChange:(CGFloat)distance
{
    NSString * distanceStr = [NSString stringWithFormat:@"%.0lfm", distance];
    
    if(distance > 1000)
    {
        CGFloat km = distance / 1000.0;
        NSString * kmStr = [NSString stringWithFormat:@"%.1lf", km];
        kmStr = [kmStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
        distanceStr = [NSString stringWithFormat:@"%@km", kmStr];
    }
    return distanceStr;
}

+ (BOOL)isEmptyString:(NSString *)str
{
//    NSString * trimString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str == nil || str.length == 0 || (NSNull *)str == [NSNull null] || [str isEqualToString:@"(null)"] || [str isEqualToString:@"<null>"];
}

- (NSString *)chineseToPinYin
{
    if ([NSString isEmptyString:self]) {
        return @"";
    }
    CFStringRef cfstr = (__bridge CFStringRef)self;
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, cfstr);
    if (CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO)&&CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO)) {
        return (__bridge NSString *)(string);
    }else{
        return self;
    }
}
@end
