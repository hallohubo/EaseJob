//
//  FileCacheTool.m
//  communicationsConstruction
//
//  Created by TouchWorld on 2018/3/7.
//  Copyright © 2018年 quanmei. All rights reserved.
//

#import "FileCacheTool.h"
#import <sys/utsname.h>
#import <YYCache.h>
#import "DESUtil.h"

@interface FileCacheTool ()
/********* <#注释#> *********/
@property(nonatomic,strong)YYCache * cache;

@end

@implementation FileCacheTool
static FileCacheTool * cacheTool;


+ (instancetype)sharedInstance
{
    if(cacheTool == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cacheTool = [[FileCacheTool alloc] init];
            cacheTool.cache = [[YYCache alloc] initWithName:NSStringFromClass([FileCacheTool class])];
        });
    }
    return cacheTool;
}
#pragma mark - 缓存操作

//归档对象
+ (void)cacheObject:(NSObject<NSCoding> *)object forKey:(NSString *)key
{
    [[FileCacheTool sharedInstance].cache setObject:object forKey:key];
}

//解档对象
+ (id<NSCoding>)unCacheObjectWithKey:(NSString *)key
{
    return [[FileCacheTool sharedInstance].cache objectForKey:key];
}

//移除归档的对象
+ (void)removeCacheObjectWithKey:(NSString *)key
{
    [[FileCacheTool sharedInstance].cache removeObjectForKey:key];
}

//移除所有缓存
+ (void)removeAllCache
{
    [[FileCacheTool sharedInstance].cache removeAllObjects];
    
}

//是否已经保存
+ (BOOL)containsObjecForKey:(NSString *)key
{
    return [[FileCacheTool sharedInstance].cache containsObjectForKey:key];
}
#pragma mark - 数据加密
//将参数字典Des加密
+ (NSString *)parameterDicDesEncrypt:(NSDictionary *)parameterDic
{
    NSString * jsonStr = [self objectChangeToJson:parameterDic];
    NSString * desKey = [self getDesKey];
    
    NSString * encryptJsonStr = [DESUtil encryptWithText:jsonStr key:desKey];
    return encryptJsonStr;
}

//将json对象Des解密
+ (NSDictionary *)jsonStrDesDesCrypt:(NSString *)jsonStr
{
    NSString * desKey = [self getDesKey];
    NSString * decryptJsonStr = [DESUtil decryptWithText:jsonStr key:desKey];
    NSDictionary * dataDic = [self jsonChangeToObject:decryptJsonStr];
    return dataDic;
}

//DES加密key
+ (NSString *)getDesKey
{
    
    return @"app-1984";
}

#pragma mark - 对象和JSON互转
//对象转Json字符串
+ (NSString *)objectChangeToJson:(id)obj
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
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];;
    }
    else
    {
        NSLog(@"对象转Json字符串失败：%@",error);
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


#pragma mark - 设备信息
//获取设备信息
+ (NSString *)getDeviceInfo
{
    struct utsname systemInfos;
    uname(&systemInfos);
    return [NSString stringWithCString:systemInfos.machine encoding:NSUTF8StringEncoding];
}

// 苹果设备类型说明 ： https://www.theiphonewiki.com/wiki/Models
//苹果设备类型
+ (NSString *)deviceModelName
{
    
    NSString *platform = [self getDeviceInfo];
    //simulator
    if ([platform isEqualToString:@"i386"])          return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])        return @"Simulator";
    
    //AirPods
    if ([platform isEqualToString:@"AirPods1,1"])    return @"AirPods";
    
    //Apple TV
    if ([platform isEqualToString:@"AppleTV2,1"])    return @"Apple TV (2nd generation)";
    if ([platform isEqualToString:@"AppleTV3,1"])    return @"Apple TV (3rd generation)";
    if ([platform isEqualToString:@"AppleTV3,2"])    return @"Apple TV (3rd generation)";
    if ([platform isEqualToString:@"AppleTV5,3"])    return @"Apple TV (4th generation)";
    if ([platform isEqualToString:@"AppleTV6,2"])    return @"Apple TV 4K";
    
    //Apple Watch
    if ([platform isEqualToString:@"Watch1,1"])    return @"Apple Watch (1st generation)";
    if ([platform isEqualToString:@"Watch1,2"])    return @"Apple Watch (1st generation)";
    if ([platform isEqualToString:@"Watch2,6"])    return @"Apple Watch Series 1";
    if ([platform isEqualToString:@"Watch2,7"])    return @"Apple Watch Series 1";
    if ([platform isEqualToString:@"Watch2,3"])    return @"Apple Watch Series 2";
    if ([platform isEqualToString:@"Watch2,4"])    return @"Apple Watch Series 2";
    if ([platform isEqualToString:@"Watch3,1"])    return @"Apple Watch Series 3";
    if ([platform isEqualToString:@"Watch3,2"])    return @"Apple Watch Series 3";
    if ([platform isEqualToString:@"Watch3,3"])    return @"Apple Watch Series 3";
    if ([platform isEqualToString:@"Watch3,4"])    return @"Apple Watch Series 3";
    
    //HomePod
    if ([platform isEqualToString:@"AudioAccessory1,1"])    return @"HomePod";
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])    return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])    return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])    return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])    return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])    return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"])    return @"iPad (3rd generation)";
    if ([platform isEqualToString:@"iPad3,2"])    return @"iPad (3rd generation)";
    if ([platform isEqualToString:@"iPad3,3"])    return @"iPad (3rd generation)";
    if ([platform isEqualToString:@"iPad3,4"])    return @"iPad (4th generation)";
    if ([platform isEqualToString:@"iPad3,5"])    return @"iPad (4th generation)";
    if ([platform isEqualToString:@"iPad3,6"])    return @"iPad (4th generation)";
    if ([platform isEqualToString:@"iPad4,1"])    return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])    return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])    return @"iPad Air";
    if ([platform isEqualToString:@"iPad5,3"])    return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])    return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,7"])    return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad6,8"])    return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad6,3"])    return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,4"])    return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,11"])    return @"iPad (5th generation)";
    if ([platform isEqualToString:@"iPad6,12"])    return @"iPad (5th generation)";
    if ([platform isEqualToString:@"iPad7,1"])    return @"iPad Pro (12.9-inch, 2nd generation)";
    if ([platform isEqualToString:@"iPad7,2"])    return @"iPad Pro (12.9-inch, 2nd generation)";
    if ([platform isEqualToString:@"iPad7,3"])    return @"iPad Pro (10.5-inch)";
    if ([platform isEqualToString:@"iPad7,4"])    return @"iPad Pro (10.5-inch)";
    
    //iPad mini
    if ([platform isEqualToString:@"iPad2,5"])    return @"iPad mini";
    if ([platform isEqualToString:@"iPad2,6"])    return @"iPad mini";
    if ([platform isEqualToString:@"iPad2,7"])    return @"iPad mini";
    if ([platform isEqualToString:@"iPad4,4"])    return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,5"])    return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,6"])    return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,7"])    return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,8"])    return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,9"])    return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad5,1"])    return @"iPad mini 4";
    if ([platform isEqualToString:@"iPad5,2"])    return @"iPad mini 4";
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])     return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])     return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])     return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])     return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])     return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])     return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])     return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])     return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])     return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone5,4"])     return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"])     return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"])     return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"])     return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])     return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])     return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])     return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])     return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])     return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"])     return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])     return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"])     return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    
    //iPod touch
    if ([platform isEqualToString:@"iPod1,1"])    return @"iPod touch";
    if ([platform isEqualToString:@"iPod2,1"])    return @"iPod touch (2nd generation)";
    if ([platform isEqualToString:@"iPod3,1"])    return @"iPod touch (3rd generation)";
    if ([platform isEqualToString:@"iPod4,1"])    return @"iPod touch (4th generation)";
    if ([platform isEqualToString:@"iPod5,1"])    return @"iPod touch (5th generation)";
    if ([platform isEqualToString:@"iPod7,1"])    return @"iPod touch (6th generation)";
    
    return platform;
    
}


//iOS版本
+ (NSString *)getiOSVersion
{
    return [UIDevice currentDevice].systemVersion;
}

//应用版本
+ (NSString *)getApplicationVersion
{
    return [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

//built版本
+ (NSString *)getAppBuiltVersion
{
    return [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"];
}

//跳转到应用权限设置界面
+ (void)jumpToAppSetting
{
    if(UIApplicationOpenSettingsURLString != nil)
    {
        UIApplication * app = [UIApplication sharedApplication];
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if (@available(iOS 10.0, *)) {
            [app openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else {
            // Fallback on earlier versions
            [app openURL:url];
        }
        [app openURL:url];
    }
}

+ (NSString *)currentCity
{
    NSString * userSelectedCity = (NSString *)[FileCacheTool unCacheObjectWithKey:NJUserDefaultUserSelectedCity];
    if(userSelectedCity != nil && userSelectedCity.length > 0)
    {
        return userSelectedCity;
    }
    NSString * city = (NSString *)[FileCacheTool unCacheObjectWithKey:NJUserDefaultLocationCity];
    if(city != nil && city.length > 0)
    {
        return city;
    }
    return nil;
}
@end
