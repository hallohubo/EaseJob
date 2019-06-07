//
//  NJPickerAddressItem.h
//  SmartCity
//
//  Created by TouchWorld on 2018/5/15.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 省
@interface NJProvinceItem : NSObject
/** 省对应的code或id */
@property (nonatomic, copy) NSString *code;
/** 省的名称 */
@property (nonatomic, copy) NSString *name;
/** 省的索引 */
@property (nonatomic, assign) NSInteger index;
/** 城市数组 */
@property (nonatomic, strong) NSArray *citylist;

@end

/// 市
@interface NJCityItem : NSObject
/** 市对应的code或id */
@property (nonatomic, copy) NSString *code;
/** 市的名称 */
@property (nonatomic, copy) NSString *name;
/** 市的索引 */
@property (nonatomic, assign) NSInteger index;
/** 地区数组 */
@property (nonatomic, strong) NSArray *arealist;

@end

/// 区
@interface NJAreaItem : NSObject
/** 区对应的code或id */
@property (nonatomic, copy) NSString *code;
/** 区的名称 */
@property (nonatomic, copy) NSString *name;
/** 区的索引 */
@property (nonatomic, assign) NSInteger index;

@end
