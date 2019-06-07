//
//  NJBankCell.h
//  Destination
//
//  Created by TouchWorld on 2018/10/15.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NJBankCardItem;
NS_ASSUME_NONNULL_BEGIN

@interface NJBankCell : UITableViewCell
/********* <#注释#> *********/
@property(nonatomic,strong)NJBankCardItem * item;

@end

NS_ASSUME_NONNULL_END
