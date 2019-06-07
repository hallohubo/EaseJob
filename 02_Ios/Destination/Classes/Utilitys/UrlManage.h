//
//  UrlManage.h
//  Property Management
//
//  Created by 中庚环境 on 17/1/3.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlManage : NSObject<UITableViewDataSource,UITableViewDelegate>
{
    UIView *bgView;
}

@property (nonatomic,assign) NSInteger urlIndex;
@property (nonatomic,strong) NSMutableArray *urlArr;

+(instancetype)urlManage;
-(NSString *)getComveeUrl;
-(void)changeUrl;

@end
