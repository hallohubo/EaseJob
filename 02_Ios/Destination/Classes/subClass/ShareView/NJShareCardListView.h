//
//  NJShareCardListView.h
//  Destination
//
//  Created by TouchWorld on 2018/10/24.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJShareConst.h"
@class NJShareItem;


NS_ASSUME_NONNULL_BEGIN

@interface NJShareCardListView : UIView
/********* 类型 *********/
@property(nonatomic,assign)ShareCardType type;
/********* <#注释#> *********/
@property(nonatomic,strong)NJShareItem * shareItem;

- (ShareCardType)selectedType;

/********* <#注释#> *********/
@property(nonatomic,copy)void (^qrCodeBlock)(void);
@end

NS_ASSUME_NONNULL_END
