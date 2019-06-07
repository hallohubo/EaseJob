//
//  NJShareConst.h
//  Destination
//
//  Created by TouchWorld on 2018/12/10.
//  Copyright © 2018 Redirect. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ShareCardType)
{
    ShareCardTypeImage = 0,//图片
    ShareCardTypeLink,//链接
    ShareCardTypeBoth,//都有
};

typedef NS_ENUM(NSUInteger, ShareType)
{
    ShareTypeWeChat = 0, //微信
    ShareTypeQQ, //QQ
    ShareTypeWeibo, //微博
    ShareTypeFriendCircle, //朋友圈
    ShareTypeZone, //QQ空间
};
