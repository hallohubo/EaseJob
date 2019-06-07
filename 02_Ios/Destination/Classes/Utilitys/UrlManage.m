//
//  UrlManage.m
//  Property Management
//
//  Created by 中庚环境 on 17/1/3.
//  Copyright © 2017年 DiTian. All rights reserved.
//

#import "UrlManage.h"
#import "AppDelegate.h"

@implementation UrlManage

static UrlManage *urlManage = nil;
+(instancetype)urlManage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        urlManage = [[UrlManage alloc] init];
        [urlManage initUrl];
    });
    return urlManage;
}

-(NSMutableArray *)urlArr
{
    if (!_urlArr) {
        _urlArr = [NSMutableArray new];
    }
    return _urlArr;
}

-(void)initUrl
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"urlIndex"]) {
        self.urlIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"urlIndex"] integerValue];
    }else{
        self.urlIndex = 0;
    }
    //线上
    //#define NJUrlPrefix @"http://mdd.yqxsy.cn/api"
    //测试
    //#define NJUrlPrefix @"http://mdd.test.yqxsy.cn/"
    //公司后台
    NSArray *arr1 = [NSArray arrayWithObjects:@"http://mdd.test.yqxsy.cn", @"内网", nil];
    NSArray *arr2 = [NSArray arrayWithObjects:@"http://mdd.yqxsy.cn/api", @"外网", nil];
    NSArray *arr3 = [NSArray arrayWithObjects:@"http://qiantutest.chongdx.com/api", @"松哥", nil];


    
    [self.urlArr addObject:arr1];
    [self.urlArr addObject:arr2];
    [self.urlArr addObject:arr3];
 

}

-(NSString *)getComveeUrl
{
    return [[self.urlArr objectAtIndex:self.urlIndex] objectAtIndex:0];
}

-(void)changeUrl
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    bgView = [[UIView alloc] initWithFrame:appDelegate.window.bounds];
    bgView.backgroundColor = [UIColor clearColor];
    [appDelegate.window addSubview:bgView];
    
    UIImageView *colorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
    colorView.backgroundColor = [UIColor blackColor];
    colorView.alpha = 0.5;
    [bgView addSubview:colorView];
    
    UITableView *m_table = [[UITableView alloc] initWithFrame:CGRectMake(0, (bgView.frame.size.height-44.0*6)/2, bgView.frame.size.width, 44.0*6) style:UITableViewStylePlain];
    m_table.delegate = self;
    m_table.dataSource = self;
    m_table.backgroundColor = [UIColor clearColor];
    //m_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [bgView addSubview:m_table];
    
    NSIndexPath *lastIndestPath = [NSIndexPath indexPathForRow:self.urlIndex inSection:0];
    [m_table scrollToRowAtIndexPath:lastIndestPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.urlArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [[self.urlArr objectAtIndex:indexPath.row] objectAtIndex:1];
    if (self.urlIndex == indexPath.row) {
        cell.textLabel.textColor = [UIColor blueColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.urlIndex = indexPath.row;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"urlIndex"];
    [defaults synchronize];
    
    [bgView removeFromSuperview];
    bgView = nil;
}

@end
