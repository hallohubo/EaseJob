//
//  NJShareItem.h
//  Destination
//
//  Created by TouchWorld on 2018/10/24.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NJShareItem : NSObject
/********* 用户头像 *********/
@property(nonatomic,copy)NSString * icon;
/********* 用户昵称 *********/
@property(nonatomic,copy)NSString * nickname;
/********* 标题 *********/
@property(nonatomic,copy)NSString * title;
/********* 详情 *********/
@property(nonatomic,copy)NSString * detailTitle;

/********* 分享的链接 没有http开头 *********/
@property(nonatomic,copy)NSString * shareURL;
/********* 分享的全路径 *********/
@property(nonatomic,copy)NSString * shareAbsoluteURL;

/********* 分享的图片 *********/
@property(nonatomic,copy)NSString * shareImageURL;
/********* 卡片分享的图片 *********/
@property(nonatomic,strong)UIImage * shareImage;

/********* 图片宽度 *********/
@property(nonatomic,strong)NSNumber * width;
/********* 图片高度 *********/
@property(nonatomic,strong)NSNumber * height;

@end

NS_ASSUME_NONNULL_END
