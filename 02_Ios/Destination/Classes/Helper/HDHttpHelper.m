//
//  HDHttp.m
//  JianJian
//
//  Created by hufan on 16/6/21.
//  Copyright © 2016年 Hu Dennis. All rights reserved.
//

#import "HDHttpHelper.h"
#import "LDCry.h"
#import "UINavigationController+Pop.h"

#define HDDomain @"http://ckz8di.natappfree.cc/"         //新调试外网

#define IP [HDHttpHelper ip]

static dispatch_once_t *onceToken_debug;

@interface HDHttpHelper (){
    HDHUD *hud;
}

@end

@implementation HDHttpHelper

+ (NSString *)ip
{
    if ([HDGI.loginUser.RegMobile isEqualToString:@"15060672715"]) {
 
        return [NSString stringWithFormat:@"%@API/", HDDomain];//测试时用
    }
    return [NSString stringWithFormat:@"%@API/", HDDomain];
}

+ (instancetype)instance
{
     HDHttpHelper *_sharedClient = nil;
//    static dispatch_once_t onceToken;
//    onceToken_debug = &onceToken;
//    dispatch_once(&onceToken, ^{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest  = 30.;
    configuration.timeoutIntervalForResource = 30.;
    _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:IP] sessionConfiguration:configuration];
//    });
    [_sharedClient setDefault];
    return _sharedClient;
}

//+ (void)resetDispatchOnce{
//    *onceToken_debug = 0;//地址指向的值
//}

- (void)setDefault
{
    _parameters = [NSMutableDictionary new];
    /*设置默认参数*/
    [_parameters setValue:@"1"                      forKey:@"Source"];
    [_parameters setValue:HDSTR([HDHelper uuid])    forKey:@"IMEI"];
    [_parameters setValue:HDSTR(APPVERSION)         forKey:@"Version"];
    NSString *token = HDGI.loginUser.Token;
    NSString *uid   = HDGI.loginUser.MID;
    Dlog(@"uid=%@",uid);
    if (token) {
        [_parameters setValue:token forKey:@"Token"];
    }
    if (uid) {
        [_parameters setValue:uid forKey:@"UserID"];
    }
}

- (void)setParameters:(NSMutableDictionary *)parameters
{
    [_parameters addEntriesFromDictionary:parameters];
}

- (NSURLSessionDataTask *)post101:(void (^)(NSString *key, NSString *seed, HDError *error))block
{
   
    NSString *key = [HDDateHelper stringWithDate:[NSDate date] withFormat:@"yyyyMMddHHmmss"];
    key = HDFORMAT(@"%@-%d", key, arc4random() % 100000);
    NSDictionary *p = @{@"key": HDSTR(key)};
   
    [self.requestSerializer setValue:HDSTR(PLATFORM) forHTTPHeaderField:@"Platform"];
    [self.requestSerializer setValue:HDSTR([HDHelper uuid]) forHTTPHeaderField:@"IMEI"];
    [self.requestSerializer setValue:HDSTR(APPVERSION) forHTTPHeaderField:@"Version"];
    
    HDError *e = [HDError new];
    NSURLSessionDataTask *task = [self POST:@"Act101" parameters:p progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *json = responseObject;
        Dlog(@"Act101 json = %@", json);
        if (!json) {
            e.code = 10101;
            e.desc = @"服务器返回responseObject对象为空";
            block(nil, nil, e);
            return;
        }
        NSDictionary *result = json[@"Result"];
        if (!result) {
            e.code = 10102;
            e.desc = @"服务器返回字典Result字典为空";
            block(nil, nil, e);
            return;
        }
        NSString *seed = result[@"Seed"];
        if (seed.length == 0) {
            e.code = 10103;
            e.desc = @"服务器返回seed字符串为空";
            block(nil, nil, e);
            return;
        }
        block(key, seed, nil);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        Dlog(@"网络请求失败 code = %d.描述：%@", (int)error.code, error.localizedDescription);
        Dlog(@"Act101 http = %@", task.response.URL);
        e.code = 0;//暂时先这么处理，
        e.desc = @"网络请求失败！";
        if (error.code == -999) {
            e.code = 0;
            e.desc = error.localizedDescription;
        }
        block(nil, nil, e);
    }];
    [task resume];
    return task;
}

#pragma mark - 通用请求post方法
- (NSURLSessionDataTask *)postPath:(NSString *)path object:(id)newObj finished:(void (^)(HDError *error, id object, BOOL isLast, id json))block
{
    NSURLSessionDataTask *task = [self post101:^(NSString *key, NSString *seed, HDError *error) {
        Dlog(@"seed = %@", seed);
        HDError *e = [HDError new];
        if (seed.length == 0 || !seed || error) {
            e = error;
            block(e, nil, NO, nil);
            return ;
        }
        NSString *pathCode = @"";
        if (path.length > 4) {
            pathCode = [path substringFromIndex:3];
        }
        NSString *sign = HDFORMAT(@"%@_%@_EasyTaskAPI", [HDHelper uuid], seed);
        NSString *encry = [LDCry getMd5_32Bit_String:sign];
        Dlog(@"sign = %@", sign);
        Dlog(@"encry = %@", encry);
        [self.requestSerializer setValue:HDSTR(key) forHTTPHeaderField:@"Key"];
        [self.requestSerializer setValue:HDSTR(encry) forHTTPHeaderField:@"Sign"];
        [self.requestSerializer setValue:HDSTR(PLATFORM) forHTTPHeaderField:@"Platform"];
        [self.requestSerializer setValue:HDSTR([HDHelper uuid]) forHTTPHeaderField:@"IMEI"];
        [self.requestSerializer setValue:HDSTR(APPVERSION) forHTTPHeaderField:@"Version"];
        NSURLSessionDataTask *task = [self POST:path parameters:_parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            Dlog(@"path:%@ --- http response's url = %@", path, task.response.URL);
            NSError *nserror = nil;
            NSDictionary *dic_json = responseObject;
            Dlog(@"path:%@ --- json = %@", path, dic_json);
            if (!dic_json) {
                e.desc = HDFORMAT(@"服务器返回数据有误，错误码:%@01", pathCode);
                block(e, nil, NO, nil);
                return;
            }
            NSString    *code       = JSON(dic_json[@"Code"]);
            NSString    *Description= JSON(dic_json[@"Description"]);
            NSString    *ErrorDesc  = JSON(dic_json[@"ErrorDesc"]);
            NSObject    *result     = dic_json[@"Result"];
            BOOL        isLast      = NO;
            if (code.intValue == 5) {//后台token值过期时，重登录操作
                
            }
            if (code.intValue != 0) {
                e.desc =  ErrorDesc.length > 0? ErrorDesc: Description;
                e.code = code.intValue;
                block(e, nil, NO, nil);
                return;
            }
            if (!result || [result isKindOfClass:[NSNull class]]) {
                e.desc = HDFORMAT(@"服务器返回数据有误，错误码:%@02", pathCode);
                e.code = code.intValue;
            }
            if (!newObj) {//结果只返回成功或失败，newObjectc传回result值，调用者爱用不用
                block(nil, nil, NO, result);
                return;
            }
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)result;
                NSArray *allValues = [dic allValues];
                if (allValues.count == 0) {//result 字典无值
                    block(nil, nil, NO, result);
                    return;
                }
                if (dic[@"IsLastPage"] || (dic.count == 1 && [allValues[0] isKindOfClass:[NSArray class]])) {//多页的情况，或者没有分页，但是是数组
                    isLast = JSON(dic[@"IsLastPage"]).boolValue;
                    NSString *sArrKey = [HDHttpHelper getTheArrayKey:dic];
                    if (!sArrKey || sArrKey.length == 0) {
                        e.desc = HDFORMAT(@"服务器返回数据有误，错误码:%@03", pathCode);
                        block(e, nil, NO, nil);
                        return;
                    }
                    NSArray *list = dic[sArrKey];
                    NSMutableArray *mar = [NSMutableArray new];
                    for (int i = 0; i < list.count; i++) {
                        NSDictionary *dic = list[i];
                        id obj = [[newObj class] new];
                        obj = [HDHttpHelper model:obj fromDictionary:dic];
                        [mar addObject:obj];
                    }
                    block(nil, mar, isLast, list);
                    return;
                }
                id obj = [HDHttpHelper model:newObj fromDictionary:dic];
                block(nil, obj, NO, dic);
                return;
            }
            if ([result isKindOfClass:[NSArray class]]) {
                NSArray *list = (NSArray *)result;
                NSMutableArray *mar = [NSMutableArray new];
                for (int i = 0; i < list.count; i++) {
                    NSDictionary *dic = list[i];
                    id o = [[newObj class] new];
                    o = [HDHttpHelper model:o fromDictionary:dic];
                    [mar addObject:o];
                }
                block(nil, mar, isLast, result);
                return;
            }
            block(nil, nil, NO, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            Dlog(@"网络请求失败 code = %d.描述：%@", (int)error.code, error.localizedDescription);
            Dlog(@"%@ http = %@", path, task.response.URL);
            e.desc  = error.localizedDescription;
            e.code  = (int)error.code;
            if (error.code == -999) {//用户主动取消，如请求中，用户跳转其他页面，即主动取消请求
                e.code = 0;
                e.desc = error.localizedDescription;
            }
            
            block(e, nil, NO, nil);
            return ;
            
        }];
        [task resume];
    }];
   
    return task;
}

#pragma mark - 请求Post图片方法
- (NSURLSessionDataTask *)httpPostPath:(NSString *)path data:(NSArray *)datas finished:(void (^)(HDError *error, id object))block
{
    NSURLSessionDataTask *task = [self post101:^(NSString *key, NSString *seed, HDError *error) {
        Dlog(@"seed = %@", seed);
        NSString *pathCode;
        if (path.length > 3) {
            pathCode = [path substringFromIndex:3];
        }
        HDError *e = [HDError new];
        if (seed.length == 0 || !seed || error) {
            e = error;
            block(e, nil);
            return ;
        }
        NSString *sign = HDFORMAT(@"%@_%@_RSPlatFormAPI", [HDHelper uuid], seed);
        NSString *encry = [LDCry getMd5_32Bit_String:sign];
        Dlog(@"sign = %@", sign);
        Dlog(@"encry = %@", encry);
        [self.requestSerializer setValue:HDSTR(key) forHTTPHeaderField:@"Key"];
        [self.requestSerializer setValue:HDSTR(encry) forHTTPHeaderField:@"Sign"];
        [self.requestSerializer setValue:HDSTR(PLATFORM) forHTTPHeaderField:@"Platform"];
        [self.requestSerializer setValue:HDSTR([HDHelper uuid]) forHTTPHeaderField:@"IMEI"];
        [self.requestSerializer setValue:HDSTR(APPVERSION) forHTTPHeaderField:@"Version"];
        NSURLSessionDataTask *t = [self POST:path parameters:_parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (int i = 0; i < datas.count; i++) {
                UIImage *image = datas[i];
                NSData *data = UIImageJPEGRepresentation(image, 1.0);
                [formData appendPartWithFileData:data name:HDFORMAT(@"files_%d.jpg", i) fileName:HDFORMAT(@"img_%d.jpg", i) mimeType:@"image/jpeg"];
            }
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            Dlog(@"%@ http = %@", path, task.response.URL);
            NSDictionary *dic_json = responseObject;
            Dlog(@"%@ json = %@", path, dic_json);
            if (!dic_json) {
                e.desc = HDFORMAT(@"网络出错，请稍后再试(%@)", path);
                block(e, nil);
                return;
            }
            NSString    *sCode      = JSON(dic_json[@"Code"]);
            NSObject    *result     = dic_json[@"Result"];
            NSString    *sErrDesc   = JSON(dic_json[@"Description"]);
            NSString    *ErrorDesc  = JSON(dic_json[@"ErrorDesc"]);
            sErrDesc =  sErrDesc.length > 0? sErrDesc: ErrorDesc;
            if (sCode.intValue != 0 || !result || [result isKindOfClass:[NSNull class]]) {
                e.desc = HDFORMAT(@"网络数据有误，错误码:%@%d，错误描述：%@", pathCode, sCode.intValue, sErrDesc);
                block(e, nil);
                return;
            }
            block(nil, result);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            Dlog(@"网络请求失败 failed %d", (int)error.code);
            Dlog(@"%@ http = %@", path, task.response.URL);
            e.desc  = error.localizedDescription;;
            e.code  = (int)error.code;
            if (error.code == -999) {
                e.code = 0;
                e.desc = error.localizedDescription;
            }
            block(e, nil);
        }];
        [t resume];
    }];
    return task;
}

+ (NSString *)getTheArrayKey:(NSDictionary *)dic
{
    if (dic.count == 0 || !dic) {
        return nil;
    }
    NSArray *ar = [dic allKeys];
    NSString *key = @"";
    for (int i = 0; i < ar.count; i++) {
        NSString *k = ar[i];
        id value = dic[k];
        if ([value isKindOfClass:[NSArray class]]) {
            key = k;
            break;
        }
    }
    return key;
}

#pragma mark - runtime

+ (id)model:(id)model fromDictionary:(NSDictionary *)dic
{
    if (!model || !dic || dic.count == 0) {
        Dlog(@"传入参数model或dic为空！");
        return nil;
    }
    NSArray *ar_properties = [self allProperties:model];
    for (int i = 0; i < ar_properties.count; i++) {
        NSString *sPropertyName = ar_properties[i];
        if (sPropertyName.length == 0) {
            NSLog(@"Error:Get property name false!");
            continue;
        }
        if (!dic[sPropertyName]) {
            continue;
        }
        if ([dic[sPropertyName] isKindOfClass:[NSDictionary class]] || [dic[sPropertyName] isKindOfClass:[NSArray class]]) {
            NSDictionary *d = dic[sPropertyName];
            [model setValue:d forKey:sPropertyName];
        }else{
            NSString *s = [self jsonObject:dic[sPropertyName]];
            s = [self changeBr2n:s];
            [model setValue:s forKey:sPropertyName];
        }
    }
    return model;
}

+ (NSString *)changeBr2n:(NSString *)s
{
    if (s.length == 0) {
        return @"";
    }
    s = [s stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, s.length)];
    s = [s stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, s.length)];
    s = [s stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, s.length)];
    s = [s stringByReplacingOccurrencesOfString:@"</b>" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, s.length)];
    s = [s stringByReplacingOccurrencesOfString:@"<b>" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, s.length)];
    s = [s stringByReplacingOccurrencesOfString:@"<br/" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, s.length)];
    s = [s stringByReplacingOccurrencesOfString:@"&nbsp" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, s.length)];
    return s;
}

+ (NSArray *)allProperties:(id)model {
    NSMutableArray *allNames    = [[NSMutableArray alloc] init];
    unsigned int propertyCount  = 0;
    NSString *sClass = NSStringFromClass([model class]);
    objc_property_t *propertys  = class_copyPropertyList(objc_getClass([sClass UTF8String]), &propertyCount);
    for (int i = 0; i < propertyCount; i ++) {
        objc_property_t property   = propertys[i];
        const char *propertyName   = property_getName(property);
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    return allNames;
}

+ (NSMutableArray *)dic_arrayWithArray:(NSMutableArray *)ar model:(id)model
{
    NSMutableArray *mar = [NSMutableArray new];
    for (int i = 0; i < ar.count; i++) {
        id m = ar[i];
        NSDictionary *d = [NSMutableDictionary new];
        NSArray *properties = [HDHttpHelper allProperties:model];
        for (int j = 0; j < properties.count; j++) {
            NSString *key = properties[j];
            NSString *value = [m valueForKey:key];
            [d setValue:HDSTR(value) forKey:key];
        }
        [mar addObject:d];
    }
    return mar;
}

+ (NSMutableArray *)model_arrayWithArray:(NSMutableArray *)ar model:(id)model
{
    NSMutableArray *mar = [NSMutableArray new];
    for (int i = 0; i < ar.count; i++) {
        NSDictionary *d = ar[i];
        id m = [HDHttpHelper model:[[model class] new] fromDictionary:d];
        [mar addObject:m];
    }
    return mar;
}

+ (id)transform:(NSString *)serial toClass:(id)newObj
{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:[serial dataUsingEncoding:kCFStringEncodingUTF8] options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        Dlog(@"error: %@", error.description);
        return nil;
    }
    if ([result isKindOfClass:[NSArray class]]) {
        NSArray *list = (NSArray *)result;
        NSMutableArray *mar = [NSMutableArray new];
        for (int i = 0; i < list.count; i++) {
            NSDictionary *dic = list[i];
            id obj = [[newObj class] new];
            obj = [HDHttpHelper model:newObj fromDictionary:dic];
            [mar addObject:obj];
        }
        return mar;
    }
    id obj = [HDHttpHelper model:newObj fromDictionary:result];
    return obj;
}

+ (NSString *)jsonObject:(id)object
{
    if ([object isKindOfClass:[NSNull class]]) {
        object = @"";
    }
    NSString *s = HDFORMAT(@"%@", object);
    BOOL isNull1 = [s isEqualToString:@"<null>"] || [s isEqualToString:@"(null)"] || [s isEqualToString:@"null"];
    BOOL isNull2 = [s isEqualToString:@"<NULL>"] || [s isEqualToString:@"(NULL)"] || [s isEqualToString:@"NULL"];
    if (isNull1 || isNull2 || !object) {
        return @"";
    }else{
        return s;
    }
}
@end



@implementation HDError

+ (HDError *)errorWithCode:(int)errCode andDescription:(NSString *)description
{
    return [[self alloc] initWithCode:errCode desc:description];
}

- (id)initWithCode:(int)code desc:(NSString *)desc
{
    if (self = [super init]) {
        self.code   = code;
        self.desc   = desc;
    }
    return self;
}
+ (HDError *)errorWithHDError:(NSError *)error
{
    return [self alloc];
}
@end
