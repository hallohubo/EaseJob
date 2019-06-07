//
//  NetRequestConst.h
//  Destination
//
//  Created by TouchWorld on 2018/10/29.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//请求方式
typedef NS_ENUM(NSUInteger, NetRequestMethodType) {
    NetRequestMethodTypeGet,
    NetRequestMethodTypePost,
    NetRequestMethodTypePut,
    NetRequestMethodTypeDelete,
    NetRequestMethodTypePatch,
    NetRequestMethodTypeHead
};

//数据解析类型
typedef NS_ENUM(NSUInteger, NetResponseSerializerType) {
    NetResponseSerializerTypeDefault,//默认类型 JSON
    NetResponseSerializerTypeJson,//JSON
    NetResponseSerializerTypeXml,//XML
    NetResponseSerializerTypePlist,//Pist
    NetResponseSerializerTypeCompound,//Compound
    NetResponseSerializerTypeImage,//image
    NetResponseSerializerTypeData//二进制
};

