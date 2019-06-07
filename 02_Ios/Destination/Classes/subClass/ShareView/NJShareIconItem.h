//
//  NJShareIconItem.h
//  Destination
//
//  Created by TouchWorld on 2018/12/10.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJShareConst.h"
NS_ASSUME_NONNULL_BEGIN

@interface NJShareIconItem : NSObject
/********* <#注释#> *********/
@property(nonatomic,copy)NSString * iconName;
/********* <#注释#> *********/
@property(nonatomic,copy)NSString * title;
/********* <#注释#> *********/
@property(nonatomic,assign)ShareType type;

@end

NS_ASSUME_NONNULL_END
