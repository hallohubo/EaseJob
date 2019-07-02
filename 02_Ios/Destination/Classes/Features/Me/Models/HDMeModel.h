//
//  HDMeModel.h
//  Destination
//
//  Created by 胡勃 on 7/2/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDMeModel : NSObject
@property (strong, nonatomic) NSString *MID;  //会员ID
@property (strong, nonatomic) NSString *MemberNo;  //会员编号
@property (strong, nonatomic) NSString *RegMobile;      //登录手机号
@property (strong, nonatomic) NSString *Status;  //账号状态（正常、冻结、封禁、删除）
@property (strong, nonatomic) NSString *NickName;       //昵称
@property (strong, nonatomic) NSString *RealName;       //姓名
@property (strong, nonatomic) NSString *HeadImg;        //头像（若返回为空，
                                                        //则根据性别显示默认头像）
@property (strong, nonatomic) NSString *Sex;            //性别（男，女，未知）
@property (strong, nonatomic) NSString *AuthStatus;     //认证状态（未认证，待审核，
                                                            //已认证，认证失败）
@property (strong, nonatomic) NSString *Commission;         //现有佣金余额
@property (strong, nonatomic) NSString *TaskBalance;        //任务余额
@property (strong, nonatomic) NSString *MarginBalance;      //保证金余额
@property (strong, nonatomic) NSString *FreezingAmount;     //冻结金额
@property (strong, nonatomic) NSString *MemberGroup;  //会员分组（普通会员、包月VIP会员、永久VIP会员）
@property (strong, nonatomic) NSString *DueDate;  //会员到期日（已开通VIP的会员，若是包月VIP则返回日期字符串（格式;  //yyyy-MM-dd HH:mm）；若是永久VIP则返回;  //“永久”；未开通VIP的，则返回空字符串）
@property (strong, nonatomic) NSString *RegDate;  //注册日期（格式;//yyyy-MM-dd HH:mm）
@property (strong, nonatomic) NSString *Token;  //登录验证Token
@end

NS_ASSUME_NONNULL_END
