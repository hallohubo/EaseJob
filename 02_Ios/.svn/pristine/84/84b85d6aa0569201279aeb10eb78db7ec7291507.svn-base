//
//  NJPayTool.m
//  SmartCity
//
//  Created by TouchWorld on 2018/5/8.
//  Copyright © 2018年 Redirect. All rights reserved.
//

#import "NJPayTool.h"
//#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

#define AlipayFromScheme @"SmartCity"
@implementation NJPayTool
static NJPayTool * payTool;
+ (instancetype)shareInstance
{
    if(payTool == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            payTool = [[NJPayTool alloc] init];
        });
    }
    return payTool;
}

#pragma mark - 支付宝支付
//- (void)alipayWithOrderStr:(NSString *)orderStr
//{
//    HDLog(@"Alipay:%@",orderStr);
//    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:AlipayFromScheme callback:^(NSDictionary *resultDic) {
//        NSLog(@"%@", resultDic);
//
//        switch ([resultDic[@"resultStatus"] integerValue])
//        {
//            case 9000:
//            {
//                //                        [self showHudTipStr:@"订单支付成功"];
//                NSDictionary * dic = @{
//                                       DictionaryKeyPayType : @"1",
//                                       DictionarykeyPayResult : @"0",
//
//                                       };
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_PayStyle object:dic];
//            }
//            break;
//            case 8000:
//            //                        [self showHudTipStr:@"正在处理中"];
//            break;
//            case 4000:
//            {
//                //                        [self showHudTipStr:@"订单支付失败"];
//                NSDictionary * dic = @{
//                                       DictionaryKeyPayType : @"1",
//                                       DictionarykeyPayResult : @"-1",
//
//                                       };
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_PayStyle object:dic];
//            }
//            break;
//            case 6001:
//            {
//                //                        [self showHudTipStr:@"订单支付取消"];
//                NSDictionary * dic = @{
//                                       DictionaryKeyPayType : @"1",
//                                       DictionarykeyPayResult : @"-1",
//
//                                       };
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_PayStyle object:dic];
//            }
//            break;
//            case 6002:
//            {
//                //                        [self showHudTipStr:@"网络连接出错"];
//                NSDictionary * dic = @{
//                                       DictionaryKeyPayType : @"1",
//                                       DictionarykeyPayResult : @"-1",
//
//                                       };
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_PayStyle object:dic];
//            }
//            break;
//            default:
//            {
//                [SVProgressHUD showErrorWithStatus:@"支付失败"];
//                [SVProgressHUD dismissWithDelay:1.5];
//            }
//            break;
//        }
//    }];
//}

#pragma mark - 微信支付
- (void)weixinPayWithOrderInfo:(NSDictionary *)dataDic
{
    HDLog(@"weixinPayOrderInfo:%@", dataDic);
    
    if(![WXApi isWXAppInstalled])
    {
        [SVProgressHUD showErrorWithStatus:@"未安装微信"];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    PayReq * req = [[PayReq alloc] init];
    
    req.partnerId = dataDic[@"partnerid"];
    req.prepayId = dataDic[@"prepayid"];
    req.nonceStr = dataDic[@"noncestr"];
    req.timeStamp = [dataDic[@"timestamp"] intValue];
    req.package = dataDic[@"package"];
    req.sign = dataDic[@"sign"];
    /*! @brief 发送请求到微信，等待微信返回onResp
     *
     * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型
     * SendAuthReq、SendMessageToWXReq、PayReq等。
     * @param req 具体的发送请求，在调用函数后，请自己释放。
     * @return 成功返回YES，失败返回NO。
     */
    [WXApi sendReq:req];
}


#pragma mark - WXApiDelegate方法
//发送请求
-(void)onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        GetMessageFromWXReq *temp = (GetMessageFromWXReq *)req;
        
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@", temp.openID];
        
        [LBXAlertAction sayWithTitle:strTitle message:strMsg buttons:@[@"ok"] chooseBlock:^(NSInteger buttonIdx) {
            
        }];
        
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n附加消息:%@\n", temp.openID, msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length, msg.messageExt];
        
        [LBXAlertAction sayWithTitle:strTitle message:strMsg buttons:@[@"ok"] chooseBlock:^(NSInteger buttonIdx) {
            
        }];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        LaunchFromWXReq *temp = (LaunchFromWXReq *)req;
        WXMediaMessage *msg = temp.message;
        
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", temp.openID, msg.messageExt];
        
        [LBXAlertAction sayWithTitle:strTitle message:strMsg buttons:@[@"ok"] chooseBlock:^(NSInteger buttonIdx) {
            
        }];
    }
}
//微信支付结果回调
-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:{
                //服务器端查询支付通知或查询API返回的结果再提示成功
                if([self.delegate respondsToSelector:@selector(paySuccess:type:)])
                {
                    [self.delegate paySuccess:self type:self.type];
                }
            }
                break;
            default:{
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                if([self.delegate respondsToSelector:@selector(payFailure:type:)])
                {
                    [self.delegate payFailure:self type:self.type];
                }
            }
                break;
        }
    }else  if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]])//添加卡券
    {
        AddCardToWXCardPackageResp* temp = (AddCardToWXCardPackageResp*)resp;
        NSMutableString* cardStr = [[NSMutableString alloc] init];
        for (WXCardItem* cardItem in temp.cardAry) {
            [cardStr appendString:[NSString stringWithFormat:@"cardid:%@ cardext:%@ cardstate:%u\n",cardItem.cardId,cardItem.extMsg,(unsigned int)cardItem.cardState]];
        }
        [LBXAlertAction sayWithTitle:@"add card resp" message:cardStr buttons:@[@"ok"] chooseBlock:^(NSInteger buttonIdx) {
            
        }];
    }else {
        NSLog(@"error");
    }
}

@end
