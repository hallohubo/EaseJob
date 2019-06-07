//
//  NJRecursiveItem.h
//  Destination
//
//  Created by TouchWorld on 2018/11/14.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NJRecursiveItem : NSObject
/********* 预留信息 *********/
@property(nonatomic,strong)NSDictionary * reServedInfo;
/********* 服务器返回的数据 *********/
@property(nonatomic,strong)id data;
- (instancetype)initWithReServedInfo:(NSDictionary *)reServedInfo data:(id)data;

@end

NS_ASSUME_NONNULL_END
