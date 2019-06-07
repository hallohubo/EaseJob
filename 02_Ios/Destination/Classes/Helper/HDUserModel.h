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
@property (nonatomic, strong) NSString *UID;        //用户ID
@property (nonatomic, strong) NSString *CustomerNo; //用户编号
@property (nonatomic, strong) NSString *RealName;   //姓名
@property (nonatomic, strong) NSString *HeadImg;    //头像
@property (nonatomic, strong) NSString *TelPhone;   //电话
@property (nonatomic, strong) NSString *Province;   //省
@property (nonatomic, strong) NSString *City;       //市
@property (nonatomic, strong) NSString *Balance;    //账户余额
@property (nonatomic, strong) NSString *RedPacket;  //红包余额
@property (nonatomic, strong) NSString *Token;      //Token
@property (nonatomic, strong) NSString *HasSetPwd;   //是否设置过密码(true是，false否)

+ (id)readFromLocal;
- (void)saveToLocal;
+ (void)clearFromLocal;
@end
