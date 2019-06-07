//
//  NJConst.h
//  Destination
//
//  Created by TouchWorld on 2018/10/30.
//  Copyright © 2018 Redirect. All rights reserved.
//

/*
 1.公共的宏
 2.头文件
 3.NSLog
 */

#import "UIView+NJFrame.h"
#import "UIView+NJCommon.h"
#import "NJGlobalConst.h"
#import "NJLoginTool.h"
#import "NSString+NJNormal.h"
#import "LBXAlertAction.h"
#import "UIView+NJCommon.h"
#import <SVProgressHUD.h>
#import "NJProgressHUD.h"
#import <UIImageView+WebCache.h>


//whl
#import "UrlManage.h"
#import "myButton.h"
#import "myLabel.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "HDHUD.h"
#import "FileCacheTool.h"

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>



//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"
#endif

#define NJFunc NJLog(@"%s",__func__)
//弱引用
#define NJWeakSelf __weak typeof(self) weakSelf = self;

#define CLWeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self

//数据保存为plist
//#abc == "abc"
#define NJDataWriteToPlist(plistName) [responseObject writeToFile:[NSString stringWithFormat:@"/Users/TouchWorld/desktop/%@.plist",@#plistName] atomically:YES]
//MainBundle路径
#define NJPlistPath [[NSBundle mainBundle] pathForResource:@"Info.plist" ofType:nil]
//缓存路径
#define NJCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)
//Document路径
#define NJDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define INDICATOR_FIX_WIDTH 35.0

/*************** 设置颜色 *********************/
#define NJRandomColor NJColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
#define NJColor(r,g,b) [UIColor colorWithRed:(r) / 256.0 green:(g) / 256.0 blue:(b) / 256.0 alpha:1.0]
#define NJColorAlpha(r,g,b,a) [UIColor colorWithRed:(r) / 256.0 green:(g) / 256.0 blue:(b) / 256.0 alpha:a]
#define NJGrayColor(n) NJColor(n,n,n)
#define NJGrayColorAlpha(n,a) NJColorAlpha(n,n,n,a)
/*************** 设置颜色 *********************/

/*************** 屏幕适配 *********************/
#define NJScreenW [UIScreen mainScreen].bounds.size.width
#define NJScreenH [UIScreen mainScreen].bounds.size.height
#define iphone6P (NJScreenH == 736)
#define iphone6 (NJScreenH == 667)
#define iphone5 (NJScreenH == 568)
#define iphone4 (NJScreenH == 480)

#define NJiPhone6PlusWidth 375
#define NJiPhone6PlusHeight 667
#define NJScreenScaleX NJScreenW * 1.0 / NJiPhone6PlusWidth
#define NJScreenScaleY NJScreenH * 1.0 / NJiPhone6PlusHeight
/*************** 屏幕适配 *********************/

/*************** 颜色 *********************/
//蓝色
#define NJBlueColor NJColor(18, 140, 239)
//橙色
#define NJOrangeColor NJColor(255, 96, 65)
//绿色
#define NJGreenColor NJColor(234, 138, 88)
//disable绿色
#define NJDisableGreenColor NJColorAlpha(234, 138, 88, 0.6034)
//灰色
#define NJGrayTextColor NJGrayColor(179)
//分割线颜色
#define NJSeperatorColor NJGrayColor(241)
//背景颜色（灰色）
#define NJBgColor NJGrayColor(245)
//白色
#define WhiteColor [UIColor whiteColor]
//102
#define YILINGERCOLOR NJGrayColor(102)
//153
#define YIWUSANCOLOR NJGrayColor(102)
//85
#define BAWUCOLOR NJGrayColor(85)

//textfieldPlashoderColor
#define TextfieldPlasehoderColor NJColor(178, 181, 185)
//Btncolor
#define Btncolor NJColor(230, 137, 93)
//SANQIColor
#define SANQIColor NJColor(37, 37, 37)
//LineViewColor
#define LineViewColor NJColor(238, 241, 245)
//ERWUWUColor
#define ERWUWUColor NJColor(255, 255, 255)
//NOBtncolor
#define NOBtncolor NJColor(249, 215, 199)
//背景颜色
#define BACKGROUNDCOLOR NJColor(238, 241, 245)
//黑色字体颜色
#define BlackColor ColorWithRGBValue16(0x555555)


//删除按钮颜色
#define DELECOLOR NJColor(249, 109, 120)
/*************** 颜色 *********************/

#define Font(font) [UIFont systemFontOfSize:(font)]
#define Image(imageName) [UIImage imageNamed:(imageName)]


/*************** 字体 *********************/
#define NJFont(s) NJFontR(s)

#define NJFontR(s) [UIFont systemFontOfSize:s weight:UIFontWeightRegular]

#define NJFontL(s) [UIFont systemFontOfSize:s weight:UIFontWeightLight]

#define NJFontB(s) [UIFont systemFontOfSize:s weight:UIFontWeightBold]

#define NJFontT(s) [UIFont systemFontOfSize:s weight:UIFontWeightThin]


/*************** 字体 *********************/

#ifdef DEBUG // 调试

#define NJLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else // 发布

#define NJLog(fmt, ...)
#endif

/*************** UserDefault *********************/
#define SHAREURL [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"HLSHAREDONGTAIYUMING"]]

//用户token
#define NJUserDefaultLoginUserToken @"NJUserDefaultLoginUserToken"

//用户状态
#define NJUserDefaultLoginStatus @"NJUserDefaultLoginStatus"
//用户数据
#define NJUserDefaultLoginUserData @"NJUserDefaultLoginUserData"
//用户ID
#define NJUserDefaultLoginUserID @"NJUserDefaultLoginUserID"

//开关状态 0:审核，1：正式上线
#define NJUserDefaultSwitchStatus @"NJUserDefaultSwitchStatus"

//地图切换
#define NJUserDefaultMapSettingSwitchType @"NJUserDefaultMapSettingSwitchType"

//地图标注隐藏
#define NJUserDefaultMapSettingAnnotationHide @"NJUserDefaultMapSettingAnnotationHide"

//deviceToken
#define NJUserDefaultDeviceToken @"NJUserDefaultDeviceToken"

//搜索历史
#define NJUserDefaultSearchHistory @"NJUserDefaultSearchHistory"

/*************** UserDefault *********************/


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

/*************** 适配iPhone X *********************/

#define Frame(x,y,w,h) CGRectMake((x), (y), (w), (h))
#define HDFRAME(x,y,w,h) CGRectMake((x), (y), (w), (h))

/*************** 通知 *********************/
//token改变
#define NJTokenChangeNotification @"tokenChangeNotification"

//网络错误
#define NotificationNetworkError @"NotificationNetworkError"

//定位信息更新
#define NotificationLocationChange @"NotificationLocationChange"

//退出登录
#define NotificationUserLogout @"NotificationUserLogout"

//登录成功
#define NotificationLoginSuccess @"NotificationLoginSuccess"

//修改了用户信息
#define NotificationUpdateInfo @"NotificationUpdateInfo"

//我的界面刷新
#define NotificationProfileVCRefresh @"NotificationProfileVCRefresh"

//首页搜索
#define NotificationDiscoverySearch @"NotificationDiscoverySearch"

//首页搜索滚动
#define NotificationDiscoverySearchScroll  @"NotificationDiscoverySearchScroll"

//获取deviceToken
#define NotificationReceiveDeviceToken @"NotificationReceiveDeviceToken"

//是否有发布过发现
#define NotificationPostStatus @"NotificationPostStatus"


//编辑草稿
#define NotificationEditCaogao @"NotificationEditCaogao"

//编辑未完成
#define NotificationEditUnfinish @"NotificationEditUnfinish"


/*************** 通知 *********************/

/*************** 字典key *********************/
#define DictionaryKeyData @"data"
#define DictionaryKeyCode @"code"
#define DictionaryKeyMsg @"msg"

#define DictionaryKeyPayType @"payType"
#define DictionarykeyPayResult @"payResult"
/*************** 字典key *********************/

/*************** 数据库 *********************/
#define RealmDataBaseName @"Destination"

/*************** 数据库 *********************/

/*************** Basic Config *********************/
#define UIViewAnimationTrantitionTime 0.75f
/*************** Basic Config *********************/

/*************** UserDefault *********************/
//纬度
#define NJUserDefaultLocationLatitute @"NJUserDefaultLocationLatitute"

//经度
#define NJUserDefaultLocationLongitute @"NJUserDefaultLocationLongitute"

//地址
#define NJUserDefaultLocationAddress @"NJUserDefaultLocationAddress"

//省份
#define NJUserDefaultLocationProvince @"NJUserDefaultLocationProvince"

//用户选择城市
#define NJUserDefaultUserSelectedCity @"NJUserDefaultUserSelectedCity"

//城市
#define NJUserDefaultLocationCity @"NJUserDefaultLocationCity"


/*************** UserDefault *********************/

/*************** 用runtime实现NSCoding的自动归档和解档 *********************/

#define encodeRuntime(A) \
\
unsigned int count = 0;\
Ivar *ivars = class_copyIvarList([A class], &count);\
for (int i = 0; i<count; i++) {\
Ivar ivar = ivars[i];\
const char *name = ivar_getName(ivar);\
NSString *key = [NSString stringWithUTF8String:name];\
id value = [self valueForKey:key];\
[aCoder encodeObject:value forKey:key];\
}\
free(ivars);\
\

#define initCoderRuntime(A) \
\
if (self = [super init]) {\
unsigned int count = 0;\
Ivar *ivars = class_copyIvarList([A class], &count);\
for (int i = 0; i<count; i++) {\
Ivar ivar = ivars[i];\
const char *name = ivar_getName(ivar);\
NSString *key = [NSString stringWithUTF8String:name];\
id value = [aDecoder decodeObjectForKey:key];\
[self setValue:value forKey:key];\
}\
free(ivars);\
}\
return self;\
\
/*************** 用runtime实现NSCoding的自动归档和解档 *********************/


