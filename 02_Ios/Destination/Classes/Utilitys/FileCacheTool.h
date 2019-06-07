//
//  FileCacheTool.h
//  communicationsConstruction
//
//  Created by TouchWorld on 2018/3/7.
//  Copyright © 2018年 quanmei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileCacheTool : NSObject

+ (instancetype)sharedInstance;


/**
 归档对象

 @param object 对象
 @param key key值
 */
+ (void)cacheObject:(NSObject<NSCoding> *)object forKey:(NSString *)key;


/**
 解档对象

 @param key key值
 @return 解档的对象
 */
+ (id<NSCoding>)unCacheObjectWithKey:(NSString *)key;


/**
 移除归档的对象

 @param key key值
 */
+ (void)removeCacheObjectWithKey:(NSString *)key;


/**
 移除所有缓存
 */
+ (void)removeAllCache;


/**
 是否已经保存

 @param key key
 @return yes or no
 */
+ (BOOL)containsObjecForKey:(NSString *)key;


/**
 将参数字典Des加密

 @param parameterDic 参数字典
 @return 加密后的json字符串
 */
+ (NSString *)parameterDicDesEncrypt:(NSDictionary *)parameterDic;


/**
 将json对象Des解密

 @param jsonStr 加密后的JSON字符串
 @return 解密后的对象
 */
+ (NSDictionary *)jsonStrDesDesCrypt:(NSString *)jsonStr;


/**
 对象转Json字符串

 @param obj 对象
 @return json字符串
 */
+ (NSString *)objectChangeToJson:(id)obj;


/**
 json字符串转对象

 @param jsonStr Json字符串
 @return 对象
 */
+ (id)jsonChangeToObject:(NSString *)jsonStr;


/**
 获取设备信息

 @return 设备信息(iPhone标识符 iPhone1,1：iPhone 1G)
 */
+ (NSString *)getDeviceInfo;


/**
 苹果设备类型

 @return 设备类型（iPhone6，iPhoneX）
 */
+ (NSString *)deviceModelName;

/**
 iOS版本

 @return iOS版本
 */
+ (NSString *)getiOSVersion;


/**
 应用版本

 @return 应用版本
 */
+ (NSString *)getApplicationVersion;


/**
 built版本

 @return built版本
 */
+ (NSString *)getAppBuiltVersion;


/**
 跳转到应用权限设置界面
 */
+ (void)jumpToAppSetting;


/**
 当前城市

 @return 城市
 */
+ (NSString *)currentCity;
@end
