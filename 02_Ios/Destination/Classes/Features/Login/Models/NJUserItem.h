//
//  NJUserItem.h
//  ConsumptionPlus
//
//  Created by TouchWorld on 2017/11/4.
//  Copyright © 2017年 qichen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJUserItem : NSObject <NSCoding>

@property(nonatomic,copy)NSNumber * user_id;
@property(nonatomic,copy)NSNumber * fensi_num;//粉丝数量
@property(nonatomic,copy)NSNumber * praise_num;
@property(nonatomic,copy)NSNumber * gender;//性别0男1女
@property(nonatomic,copy)NSNumber * follow_num;//关注的数量
@property(nonatomic,copy)NSNumber * is_pwd;//密码是否设置过0没1有
@property(nonatomic,copy)NSNumber * wx_bind;//微信是否绑定过0没1有

@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *nickname;//昵称
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *background_image;//背景图片
@property(nonatomic,copy)NSString *introduce;//简介
@property(nonatomic,copy)NSString *address;//地址
@property(nonatomic,copy)NSString *birthday;//邮箱
@property(nonatomic,copy)NSString *m_id;
@property(nonatomic,copy)NSString *realname;//真实姓名
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSNumber *has_picture;//0不显示



///********* 用户ID *********/
//@property(nonatomic,copy)NSString * uid;
///********* 昵称 *********/
//@property(nonatomic,copy)NSString * nikename;
///********* 头像图片 *********/
//@property(nonatomic,copy)NSString * image;
///********* 邮箱 *********/
//@property(nonatomic,copy)NSString * email;
///********* 地址 *********/
//@property(nonatomic,copy)NSString * address;
///********* 手机号 *********/
//@property(nonatomic,copy)NSString * mobile;
///********* 真实姓名 *********/
//@property(nonatomic,copy)NSString * realname;
///********* 介绍 *********/
//@property(nonatomic,copy)NSString * introduce;
///********* 头像id *********/
//@property(nonatomic,copy)NSString * m_id;
///********* 是否绑定微信  0： 否  1：是 *********/
//@property(nonatomic,copy)NSString * wx_bind;



///********* 账号 *********/
//@property(nonatomic,copy)NSString * account;
//
///********* 密码 *********/
//@property(nonatomic,copy)NSString * password;
//
///********* 头像 *********/
//@property(nonatomic,copy)NSString * picture;
//
///********* 电话 *********/
//@property(nonatomic,copy)NSString * mobile;
//
///********* 姓名 *********/
//@property(nonatomic,copy)NSString * name;
//
///********* 邮箱 *********/
//@property(nonatomic,copy)NSString * email;
//
///********* 创建账号时间 *********/
//@property(nonatomic,copy)NSString * created_at;
//
///********* 上次登录时间 *********/
//@property(nonatomic,copy)NSString * updated_at;
//
///********* token *********/
//@property(nonatomic,copy)NSString * remember_token;
//
///********* token时间 *********/
//@property(nonatomic,copy)NSString * token_time;
//
//
//
///********* 授权类型 *********/
//@property(nonatomic,copy)NSString * authtype;
//
///********* 性别 *********/
//@property(nonatomic,strong)NSNumber * sex;
//
///********* 定位 *********/
//@property(nonatomic,copy)NSString * location;




@end
