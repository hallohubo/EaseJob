//
//  NJProgressHUD.m
//  Destination
//
//  Created by TouchWorld on 2018/10/29.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "NJProgressHUD.h"
#import <SVProgressHUD.h>

@implementation NJProgressHUD

+ (void)show
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD show];
}

+ (void)showInfoWithStatus:(NSString *)status
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD showInfoWithStatus:status];
}

+ (void)showWithMessage:(NSString *)message
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD showWithStatus:message];
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}

+ (void)dismissWithDelay:(NSTimeInterval)interval
{
    [SVProgressHUD dismissWithDelay:interval];
    
}

+ (void)dismissWithDelay:(NSTimeInterval)interval completion:(SVProgressHUDDismissCompletion)completion
{
    [SVProgressHUD dismissWithDelay:interval completion:completion];
}


+ (void)showError:(NSString *)errorInfo
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    
    [SVProgressHUD setMinimumDismissTimeInterval:0.1f];
    [SVProgressHUD showErrorWithStatus:errorInfo];
}

+ (void)showSuccess:(NSString *)info
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    
    [SVProgressHUD setMinimumDismissTimeInterval:0.1f];
    [SVProgressHUD showSuccessWithStatus:info];
    
}

+ (void)showProgress:(float)progress status:(NSString *)status
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    
    [SVProgressHUD setMinimumDismissTimeInterval:0.1f];
    [SVProgressHUD showProgress:progress status:status];
}
@end
