//
//  NJViewController.h
//  SmartCity
//
//  Created by TouchWorld on 2018/3/30.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDViewControllerRefreshProtocol <NSObject>
@required

@optional
- (void)tabBarSelectedVCrefreshView;

@end

@interface HDViewController : UIViewController <HDViewControllerRefreshProtocol>



//modal登录界面
- (void)showLoginVCWithCompletion:(void (^ __nullable)(void))completion;

//社交分享
- (void)socialShareWithContent:(NSString *_Nullable)content images:(NSArray *_Nullable)images url:(NSString *_Nullable)url title:(NSString *_Nullable)title;
@end
