//
//  HBRealNameAuthenticationModel.h
//  Destination
//
//  Created by 胡勃 on 7/2/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBRealNameAuthenticationModel : NSObject
@property (strong, nonatomic) NSString *MID;  //会员ID
@property (strong, nonatomic) NSString *NickName;  //昵称
@property (strong, nonatomic) NSString *RealName;  //姓名
@property (strong, nonatomic) NSString *HeadImg;
@property (strong, nonatomic) NSString *Sex;  //性别（男，女，未知）
@property (strong, nonatomic) NSString *AuthStatus;  //认证状态（未认证，待审核，已认证，认证失败）
@property (strong, nonatomic) NSString *AuthRemark;  //认证备注
@property (strong, nonatomic) NSString *IDCard;  //身份证号
@property (strong, nonatomic) NSString *OpeningBank;  //开户行
@property (strong, nonatomic) NSString *BankAccount;  //银行卡号
@end

NS_ASSUME_NONNULL_END
