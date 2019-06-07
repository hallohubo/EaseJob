//
//  NJHorizontalMenuListView.h
//  Destination
//
//  Created by TouchWorld on 2018/10/16.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NJHorizontalMenuListView : UIView
/********* 显示在第几行 *********/
@property(nonatomic,assign)NSInteger row;


- (void)showWithSender:(UIView *)sender senderFrame:(CGRect)senderFrame;

- (void)dismiss;

/********* <#注释#> *********/
@property(nonatomic,copy)void (^didSelectedBlock)(NSInteger row, NSInteger index);
@end

NS_ASSUME_NONNULL_END
