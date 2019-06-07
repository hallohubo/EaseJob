//
//  NJShareListView.h
//  Destination
//
//  Created by TouchWorld on 2018/10/24.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJShareConst.h"
NS_ASSUME_NONNULL_BEGIN

@interface NJShareListView : UIView
/********* <#注释#> *********/
@property(nonatomic,copy)void (^shareBlock)(ShareType type);

@end

NS_ASSUME_NONNULL_END
