//
//  NSString+NJNormal.h
//  VideoAssistant
//
//  Created by TouchWorld on 2017/11/12.
//  Copyright © 2017年 qichen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NJNormal)

/**
 时间戳

 @param subffix 后缀
 @return 字符串
 */
+ (NSString *)timeStampWithSubffix:(NSString *)subffix;

+ (NSString *)timeStampWithSubffix_Float:(NSString *)subffix;

+ (NSString *)timeStampWithSubffix:(NSString *)subffix index:(NSInteger)index;

/**
 获取指定格式的日期字符串

 @param time 时间戳 1970年开始
 @param formatterStr 格式
 @return 指定格式的日期
 */
+ (NSString *)formatterDateStrWithTime:(NSTimeInterval)time formatterStr:(NSString *)formatterStr;
/**
 文字内容的最大宽度高度

 @param str 字符串
 @param font 字体大小
 @param maxSize 最大磁村
 @return 尺寸
 */
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 MD5加密
 
 @return 加密后的字符串
 */
- (NSString *)md5Str;

//json转NSData
+ (NSData *)objectChangeToJsonData:(id)obj;

//对象转JSON字符串
+ (NSString *)objectChangeToJson:(id)obj;

//JSON字符串转对象
+ (id)jsonChangeToObject:(NSString *)jsonStr;
/**
 日期字符串转日期对象
 
 @param formatter 日期格式
 @return 日期
 */
- (NSDate *)timeStrChangeToDateWithFormatter:(NSString *)formatter;


/**
 更改日期字符串格式

 @param fromFormatter 原格式
 @param toFormatter 目标格式
 @return 更改后的字符串
 */
- (NSString *)changeTimeStrFormatterFromFormatter:(NSString *)fromFormatter toFormatter:(NSString *)toFormatter;


/**
 距离换算

 @param distance 距离
 @return 距离字符串
 */
+ (NSString *)distanceChange:(CGFloat)distance;



/**
 是否是空字符串

 @param str 要检测的字符串
 @return 结果
 */
+ (BOOL)isEmptyString:(NSString *)str;

//中文转拼音
- (NSString *)chineseToPinYin;
@end
