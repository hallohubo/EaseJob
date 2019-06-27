//
//  HDUserModel.h
//  Demo
//
//  Created by hufan on 2017/3/8.
//  Copyright © 2017年 hufan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDUserModel : NSObject

@end

@interface HDLoginUserModel : NSObject

@property (nonatomic, strong) NSString *MID;        //会员ID
@property (nonatomic, strong) NSString *MemberNo;   //会员编号
@property (nonatomic, strong) NSString *RegMobile;  //注册手机号
//账号状态（0正常、1冻结、2封禁、3删除）
@property (nonatomic, strong) NSString *Status;
@property (nonatomic, strong) NSString *NickName;  //昵称
@property (nonatomic, strong) NSString *RealName;  //姓名
//头像（若返回为空，则根据性别显示默认头像）
@property (nonatomic, strong) NSString *HeadImg;
@property (nonatomic, strong) NSString *Sex;  //性别（1男性，2女性，0未知）
//认证状态（0未认证，1待审核，2已认证，3认证失败）
@property (nonatomic, strong) NSString *AuthStatus;
@property (nonatomic, strong) NSString *Commission;  //现有佣金余额
@property (nonatomic, strong) NSString *TaskBalance;  //任务余额
@property (nonatomic, strong) NSString *MarginBalance;  //保证金余额
@property (nonatomic, strong) NSString *FreezingAmount;  //冻结金额
//会员分组（0普通会员、1包月VIP会员、2永久VIP会员）
@property (nonatomic, strong) NSString *MemberGroup;
@property (nonatomic, strong) NSString *DueDate;  //会员到期日
@property (nonatomic, strong) NSString *RegDate;  //注册日期
@property (nonatomic, strong) NSString *Token;  //登录验证Token

+ (id)readFromLocal;
- (void)saveToLocal;
+ (void)clearFromLocal;
@end
