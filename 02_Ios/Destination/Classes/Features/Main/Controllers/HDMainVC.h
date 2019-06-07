//
//  HDMainVC.h
//  Destination
//
//  Created by hufan on 2019/6/1.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDBannerModel;

@interface HDMainVC : UIViewController

@end

@interface HDBannerModel : NSObject
@property (nonatomic, strong) NSString *AID;        //广告ID
@property (nonatomic, strong) NSString *ImageUrl;   //图片地址
@property (nonatomic, strong) NSString *Width;      //图片宽度
@property (nonatomic, strong) NSString *Height;     //图片高度
@property (nonatomic, strong) NSString *LinkUrl;    //跳转链接地址 partner=合伙人计划页
@property (nonatomic, strong) NSString *Description;//描述
@property (nonatomic, strong) NSString *OrderBy;    //排序
@property (nonatomic, strong) NSString *ImgPosition;//图片位置编号
@property (nonatomic, strong) NSString *LinkType;   //0无，1外链，2内链）
@end
