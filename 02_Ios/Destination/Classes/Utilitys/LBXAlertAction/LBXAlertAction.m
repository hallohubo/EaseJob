//
//  LBXAlertAction.m
//
//  https://github.com/MxABC/LBXAlertAction
//  Created by lbxia on 15/10/27.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "LBXAlertAction.h"
#import <UIKit/UIKit.h>
#import "UIAlertView+LBXAlertAction.h"
#import "UIActionSheet+LBXAlertAction.h"
#import "UIWindow+LBXHierarchy.h"

@implementation LBXAlertAction


+ (BOOL)isIosVersion8AndAfter
{  
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ;
}

+ (void)sayWithTitle:(NSString*)title message:(NSString*)message buttons:(NSArray<NSString*>*)arrayItems chooseBlock:(void (^)(NSInteger buttonIdx))block{
    NSMutableArray* argsArray = [[NSMutableArray alloc] initWithArray:arrayItems];
    if ( [LBXAlertAction isIosVersion8AndAfter]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        for (int i = 0; i < [argsArray count]; i++){
            UIAlertActionStyle style = (0 == i)? UIAlertActionStyleCancel: UIAlertActionStyleDefault;
            UIAlertAction *action = [UIAlertAction actionWithTitle:[argsArray objectAtIndex:i] style:style handler:^(UIAlertAction *action) {
                if (block) {
                    block(i);
                }
            }];
            //设置按钮title颜色
            UIColor *textColor = i == 0? HDRGBCOLOR(102, 102, 102): HDRGBCOLOR(230, 137, 93);
            [action setValue:textColor forKey:@"titleTextColor"];
            [alertController addAction:action];
        }
        [[LBXAlertAction getTopViewController] presentViewController:alertController animated:YES completion:nil];
        return;
    }
}


+ (UIViewController*)getTopViewController{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    return window.currentViewController;
}

+ (void)showActionSheetWithTitle:(NSString*)title
                         message:(NSString*)message
               cancelButtonTitle:(NSString*)cancelString
          destructiveButtonTitle:(NSString*)destructiveButtonTitle
                otherButtonTitle:(NSArray<NSString*>*)otherButtonArray
                     chooseBlock:(void (^)(NSInteger buttonIdx))block{
    NSMutableArray* argsArray = [[NSMutableArray alloc] initWithCapacity:3];
    if (cancelString) {
        [argsArray addObject:cancelString];
    }
    if (destructiveButtonTitle) {
        [argsArray addObject:destructiveButtonTitle];
    }
  
    [argsArray addObjectsFromArray:otherButtonArray];
        
    if ( [LBXAlertAction isIosVersion8AndAfter])
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        for (int i = 0; i < [argsArray count]; i++)
        {
            UIAlertActionStyle style =  (0 == i)? UIAlertActionStyleCancel: UIAlertActionStyleDefault;
            
            if (1==i && destructiveButtonTitle) {
                
                style = UIAlertActionStyleDestructive;
            }
            
            // Create the actions.
            UIAlertAction *action = [UIAlertAction actionWithTitle:[argsArray objectAtIndex:i] style:style handler:^(UIAlertAction *action) {
                if (block) {
                    block(i);
                }
            }];
            [alertController addAction:action];
        }
        
        [[LBXAlertAction getTopViewController] presentViewController:alertController animated:YES completion:nil];
        return;
    }
}



@end