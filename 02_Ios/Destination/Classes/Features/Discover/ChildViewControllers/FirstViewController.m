//
//  FirstViewController.m
//  SPPageMenu
//
//  Created by 乐升平 on 17/10/26.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import "FirstViewController.h"
#import "HBDiscoverModel.h"

@interface FirstViewController ()
{
    NSURLSessionTask *task;
    NSMutableArray *mar;
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self httpGetPageTask:1 type:0];

    // 请进入 "BaseViewController"
}

#pragma mark - http event

- (void)httpGetPageTask:(NSInteger)indexPage type:(NSInteger)type  //
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    NSDictionary *dic = @{@"PageSize": @"10",
                          @"PageIndex": @(indexPage),
                          @"type": @"0",
                          };
    [helper.parameters addEntriesFromDictionary:dic];
    
    task = [helper postPath:@"Act204" object:[HBDiscoverModel class] finished:^(HDError *error, id object, BOOL isLast, id json)
            {
                if (error) {
                    if (error.code != 0 ) {
                        [HDHelper say:error.desc];
                    }
                    return ;
                }
                if (!object || ![object isKindOfClass:[NSArray class]]) {
                    return;
                }
                mar = [NSMutableArray arrayWithArray:object];
                
                //test
                if (mar.count < 1) {
                    mar = [[NSMutableArray alloc] init];
                    for (int i = 0; i < 10; i++) {
                        HBDiscoverModel *model = [HBDiscoverModel new];
                        model.TaskTitle = HDFORMAT(@"task%d", i);
                        model.Commission= HDFORMAT(@"RMB:1000.%d0元", i);
                        model.Quantity = @"19/10";
                        [mar addObject:model];
                    }
                }
                self.marList = [mar copy];
                [self.tableView reloadData];
            
            }];
}

@end
