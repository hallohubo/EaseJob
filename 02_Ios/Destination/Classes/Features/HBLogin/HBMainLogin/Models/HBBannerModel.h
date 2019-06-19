//
//  HBBannerModel.h
//  Destination
//
//  Created by 胡勃 on 6/19/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBBannerModel : NSObject
@property (nonatomic, strong) NSString *BannerID;   //Banner图ID
@property (nonatomic, strong) NSString *Title;      //图片标题
@property (nonatomic, strong) NSString *ImgUrl;     //图片地址
@property (nonatomic, strong) NSString *LinkType; //跳转类型（0无跳转，1跳转外链，2跳转APP内部页）
@property (nonatomic, strong) NSString *ExternalLink;   //外链地址
@property (nonatomic, strong) NSString *InternaLink;    //APP内链（暂时未使用到）
@property (nonatomic, strong) NSString *ImgPosition;    //图片显示位置（1=首页广告）
@property (nonatomic, strong) NSString *OrderValue;     // 图片排序

+ (id)readFromLocal;
- (void)saveToLocal;
+ (void)clearFromLocal;
@end

NS_ASSUME_NONNULL_END
