//
//  NJModalListView.h
//  Destination
//
//  Created by TouchWorld on 2018/10/15.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NJBankCardItem;
NS_ASSUME_NONNULL_BEGIN

@interface NJModalListView : UIView
+ (instancetype)modalListView;

- (void)show;

- (void)dismiss;

/********* 使用新卡提现 *********/
@property(nonatomic,copy)void (^addNewBankCardBlock)(void);

/********* 选择银行卡 *********/
@property(nonatomic,copy)void (^selectedBankCardBlock)(NJBankCardItem * item);

/********* <#注释#> *********/
@property(nonatomic,strong)NSArray<NJBankCardItem *> * bankCardArr;
@end

NS_ASSUME_NONNULL_END
