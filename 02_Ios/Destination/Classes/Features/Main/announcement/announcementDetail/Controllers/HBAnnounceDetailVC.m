//
//  HBAnnounceDetailVC.m
//  Destination
//
//  Created by 胡勃 on 6/20/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBAnnounceDetailVC.h"

@interface HBAnnounceDetailVC ()
{
    NSURLSessionDataTask    *task;
    NSString    *strID;
}

@end

@implementation HBAnnounceDetailVC

#pragma mark - life cycle

- (instancetype)initWithTypeID:(NSString *)typeId
{
    if (!(self = [super init])) {
        return nil;
    }
    strID = typeId;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self httpGetReceNews:strID];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - http event

- (void)httpGetReceNews:(NSString *)typeId
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    NSDictionary *dic = @{@"nid":  HDSTR(typeId),
                          };
    [helper.parameters addEntriesFromDictionary:dic];
    [NJProgressHUD show];
    task = [helper postPath:@"Act009" object:nil finished:^(HDError *error, id object, BOOL isLast, id json)
            {
                [NJProgressHUD dismiss];
                if (error) {
                    [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
                    
                    return ;
                }
            }];
}


#pragma mark - setter and getter

- (void)setupUI
{
    self.title = @"活动详情";
}

@end
