//
//  HDGlobleInfo.h
//  HDStudio
//
//  Created by Hu Dennis on 14/12/12.
//  Copyright (c) 2014年 Hu Dennis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDUserModel.h"

#define HDGI [HDGlobal instance]
#define HDNOTI_DID_TAP_TABBAR_INDEX @"HDNOTI_DID_TAP_TABBAR_INDEX"

@interface HDGlobal : NSObject

@property (nonatomic, strong) HDLoginUserModel *loginUser;  //登录用户
@property (nonatomic, strong) NSString *paySum;             //支付金额，由支付页面315接口获取，支付结果页调用
//@property (nonatomic, strong) UINavigationController *nav;  //大厦基石导航控件
@property (nonatomic, strong) NSString *strNotification;    //极光推送判断那个control需要显示小红点；
//@property (nonatomic, strong) NSString *AuthID;             //第三方登录act121客户未绑定手机号时暂存
@property (nonatomic, strong) NSString *gender;
+ (HDGlobal *)instance;

@end
