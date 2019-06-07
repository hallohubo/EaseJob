//
//  NSObject_Instance.h
//  FEPosUniversal
//
//  Created by DennisHu on 12-8-6.
//  Copyright (c) 2012年 __iDennisHu__. All rights reserved.
//

//
//typedef NS_ENUM(NSInteger, HDCharacterType) {
//
//    HDCharacterTypeEnglish = 0,
//    HDCharacterTypeChinese,
//    HDCharacterTypeOther,
//};

#define HDWeakSelf __weak typeof(self) weakSelf = self;

#define HDScreenW [UIScreen mainScreen].bounds.size.width
#define HDScreenH [UIScreen mainScreen].bounds.size.height

/*************** 设置延迟下拉刷新加载时间 *********************/
#define  DROP_down_time 0.5

#define keywindowView [UIApplication sharedApplication].keyWindow
//----------------------系统----------------------------

#define kSCREEN_WIDTH       ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT      ([UIScreen mainScreen].bounds.size.height)
#define IS_iPhoneX             (kSCREEN_WIDTH == 375.f && kSCREEN_HEIGHT == 812.f)
//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define isRetina3_5 CGSizeEqualToSize(CGSizeMake(320, 480), [UIScreen mainScreen].bounds.size)
#define isRetina4_0 CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size)
#define isRetina4_7 CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size)
#define isRetina5_5 CGSizeEqualToSize(CGSizeMake(414, 736), [UIScreen mainScreen].bounds.size)
#define isRetina5_8 CGSizeEqualToSize(CGSizeMake(375, 812), [UIScreen mainScreen].bounds.size)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/*************** 适配iPhone X *********************/
// 判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size): NO)

//是否是FaceID
#define IS_FaceID (IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES)

// 状态栏高度
#define STATUS_BAR_HEIGHT (IS_FaceID ? 44.0 : 20.0)
// 导航条高度
#define NAVIGATION_BAR_HEIGHT 44.0
// 导航栏高度
#define NAVIGATION_BAR_Max_Y (IS_FaceID ? 88.0 : 64.0)
// tabBar高度
#define TAB_BAR_HEIGHT (IS_FaceID ? 83.0 : 49.0)
// home indicator
#define HOME_INDICATOR_HEIGHT (IS_FaceID? 34.0 : 0)

//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGEFILE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define HDIMAGE(_pointer) [UIImage imageNamed:_pointer]

//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//透明色
#define HDCLEARCOLOR [UIColor clearColor]

#define HDFRAME(x,y,w,h) CGRectMake((x), (y), (w), (h))

#pragma mark - color functions
#define HDRGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define HDRGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define HDCLEARCOLOR            [UIColor clearColor]
#define HDCOLOR_THEME           [UIColor colorWithPatternImage:HDIMAGE(@"theme")]     //主题色
#define HDCOLOR_ORANGE          [UIColor colorWithRed:230./255.  green:137./255.  blue:93./255.   alpha:1.0]  //橘色
#define HDCOLOR_RED             [UIColor colorWithRed:254/255.  green:77/255.   blue:61/255.    alpha:1.0]
#define HDCOLOR_DARKBLUE        [UIColor colorWithRed:22/255.   green:98/255.   blue:152/255.   alpha:1.0]
#define HDCOLOR_LINE            [UIColor colorWithRed:206/255.  green:206/255.  blue:206/255.   alpha:1.]
#define HDCOLOR_GRAY            [UIColor colorWithRed:235/255.  green:235/255.  blue:235/255.   alpha:1.]
#define HDCOLOR_GREEN           [UIColor colorWithRed:64/255.   green:196/255.  blue:118/255.   alpha:1.]
#define HDCOLOR_WHITE           [UIColor whiteColor]

//字体
#define HDFONT_TITLE            [UIFont systemFontOfSize:16]    //正文、标题字体
#define HDFONT                  [UIFont systemFontOfSize:14]    //正文、标题字体
#define HDFONT_DETAIL           [UIFont systemFontOfSize:12]    //详情、副标题字体
#define HDFONT_NOTE             [UIFont systemFontOfSize:10]     //注解字体

#define _fileName_default__     @"default"

#define SRV_CONNECTED       0
#define SRV_CONNECT_SUC     1
#define SRV_CONNECT_FAIL    2
#define debugMode           1

#ifdef DEBUG
#define HDLog(format, ...) printf("\n%s HDLog %s(line%d) %s\n%s\n\n", __TIME__, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else
#define HDLog(format, ...)
#endif

#ifdef DEBUG
#define Dlog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define Dlog(fmt, ...)
#endif

#define ssRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ssRGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define HDUMClick(p)        [MobClick event:p]
#define HDVALUE(p0, p1)     (!p0 || [p0 isKindOfClass:[NSNull class]]? p1: p0)
#define HDSTR(p)            HDVALUE(p, @"")
#define HDNILTEXT           @"不限"
#define HDIndexPath(s, r)   (indexPath.section == s && indexPath.row == r)

#define HD_DEPRECATED_IOS(_intro, _DepIntro, ...) __attribute__((deprecated("")))

#define HDDocumentPath ((NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])

#define DEVICE_IS_IPHONE    [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define DEVICE_IS_IPAD      [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define HDDeviceSize        [[UIScreen mainScreen] bounds].size
#define kWindow             [HDGlobalInfo instance].window
#define TAB                 [HDGlobalInfo instance].tab
#define HDFORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]
#define DOCUMENTS_FOLDER    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define FILEPATH            [DOCUMENTS_FOLDER stringByAppendingPathComponent:[self dateString]]
#define LS(s)  NSLocalizedString((s), @"")

#define HDUTF8(P) [NSString stringWithCString:[[P description] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding]

#define ORITATION_IS_HORIZONTAL     ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft)

#define ORITATION_IS_VERTICAL       ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown)

#define BARBUTTON(TITLE, SELECTOR) 	[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define SYSBARBUTTON(ITEM, TARGET, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:TARGET action:SELECTOR]

#ifndef IOS_VERSION
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#endif
#define IS_4INCH_SCREEN     (fabs((double)[[UIScreen mainScreen ] bounds].size.height - (double)568)  <  DBL_EPSILON )
#define IS_35INCH_SCREEN    (fabs((double)[[UIScreen mainScreen ] bounds].size.height - (double)568)  >= DBL_EPSILON )

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

#define NOTI_SHARE_SUCCESS @"shareSuccessNotification"




