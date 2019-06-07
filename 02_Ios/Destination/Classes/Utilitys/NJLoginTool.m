//
//  NJLogin.m
//  ConsumptionPlus
//
//  Created by TouchWorld on 2017/11/2.
//  Copyright © 2017年 qichen. All rights reserved.
//

#import "NJLoginTool.h"
#import "NJUserItem.h"
#import "HLTokenModel.h"
@implementation NJLoginTool
#pragma mark - 是否登录
+ (BOOL)isLogin{
    NSString * userID = [self getUserID];
    if(userID != nil && userID.length > 0){
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - 登录所需操作
+ (void)loginWithItem:(NJUserItem *)item
{
    if(item == nil)
    {
        //退出登录
        [NJLoginTool logout];
        return;
    }

    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    //保存用户状态
    [userDefaults setBool:YES forKey:NJUserDefaultLoginStatus];
    
    //保存用户数据
    
    NSData * userData = [NSKeyedArchiver archivedDataWithRootObject:item];
    if(userData != nil)
    {
        [userDefaults setObject:userData forKey:NJUserDefaultLoginUserData];
    }
    
    
    //保存用户ID
//    [userDefaults setObject:item.uid forKey:NJUserDefaultLoginUserID];
    
    NSString * userid = [NSString stringWithFormat:@"%@",item.user_id];
     [userDefaults setObject:userid forKey:NJUserDefaultLoginUserID];
    
    //保存用户token
//    [userDefaults setValue:item. forKey:NJUserDefaultLoginUserToken];
    
    //同步
    [userDefaults synchronize];
}
#pragma mark - 退出登录所需操作
+ (void)logout
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserLogout object:nil];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //登录状态
    [userDefaults setBool:NO forKey:NJUserDefaultLoginStatus];
    
    //用户数据
    NJUserItem * item = [[NJUserItem alloc]init];
    NSData * userData = [NSKeyedArchiver archivedDataWithRootObject:item];
    if(userData != nil)
    {
        [userDefaults setObject:userData forKey:NJUserDefaultLoginUserData];
    }
    //用户ID
    [userDefaults setValue:@"" forKey:NJUserDefaultLoginUserID];
    
    //用户token
    [userDefaults setValue:@"" forKey:NJUserDefaultLoginUserToken];
    
    //同步
    [userDefaults synchronize];
}

#pragma mark - 获取当前用户
+ (NJUserItem *)getCurrentUser
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * userData = [userDefaults objectForKey:NJUserDefaultLoginUserData];
    NJUserItem * item = nil;
    if(userData != nil)
    {
        item = (NJUserItem *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
    else
    {
        item = [[NJUserItem alloc]init];
    }
    return item;
}

#pragma mark - 设置当前用户
+ (void)setCurrentUser:(NJUserItem *)item
{
    if(item == nil)
    {
        return ;
    }
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * userData = [NSKeyedArchiver archivedDataWithRootObject:item];
    
    [userDefaults setObject:userData forKey:NJUserDefaultLoginUserData];
    
    [userDefaults synchronize];
    
}

#pragma mark - 获取当前用户ID
+ (NSString *)getUserID{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * value = [userDefaults objectForKey:NJUserDefaultLoginUserID];
    if(value != nil){
        return value;
    }else{
        return @"123";
    }
}
#pragma mark - 获取当前用户token
+ (NSString *)getUserToken
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * token = [userDefaults objectForKey:NJUserDefaultLoginUserToken];
    if(token != nil)
    {
        return token;
    }
    else
    {
        return @"";
    }
}

@end
