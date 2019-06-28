//
//  BaseViewController.m
//  SPPageMenu
//
//  Created by 乐升平 on 17/10/26.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import "BaseViewController.h"
#import "HBDiscoverModel.h"
#import "HBDiscoverCell.h"

@interface BaseViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger page;
    NSURLSessionTask    *task;
}

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    //设置取消 Automatic 自动计算一下2个高度值
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:tableView];
    _tableView = tableView;
   
    [self setTableviewRefreshInit];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _marList.count > 0? _marList.count : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"HBDiscoverCell";
    HBDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [HBDiscoverCell loadFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    HBDiscoverModel *model = _marList[indexPath.section];
    [cell.imvPhoto setImage:HDIMAGE(@"main_cellHeadImage")];
    cell.lbMainheading.text = model.TaskTitle;
    cell.lbSubheading.text  = model.Quantity;
    cell.lbMoney.text   = model.Commission;
    return cell;
}

#pragma mark - http event
- (void)httpGetPageTask:(NSInteger)indexPage type:(NSString *)type typeId:(NSString *)typeId  //
{
    int IntType = type.intValue;
    int IntTypeId = typeId.intValue;
    HDHttpHelper *helper = [HDHttpHelper instance];
    NSDictionary *dic = @{@"PageSize": @"10",
                          @"PageIndex": @(indexPage),
                          @"taskTypeID": @(IntTypeId),
                          @"searchType": @(IntType),
                          };
    [helper.parameters addEntriesFromDictionary:dic];
    
    task = [helper postPath:@"Act204" object:[HBDiscoverModel class] finished:^(HDError *error, id object, BOOL isLast, id json)
    {
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        if (error) {
            [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            
            return ;
        }
        
        NSArray * dataArr = [NSArray array];
        if ([object isKindOfClass:[NSArray class]] && object) {
            dataArr = object;
        }else {
            return;
        }
        
        if (dataArr.count < 1) {//test
            NSMutableArray *mar = [[NSMutableArray alloc] init];
            for (int i = 0; i < 10; i++) {
                HBDiscoverModel *model = [HBDiscoverModel new];
                model.TaskTitle = HDFORMAT(@"task%d", i);
                model.Commission= HDFORMAT(@"RMB:1000.%d0元", i);
                model.Quantity = @"19/10";
                [mar addObject:model];
            }
            _marList = [mar copy];
            [_tableView reloadData];
            return;
        }
        
        if (dataArr.count < 1 && page == 1) {
            _marList = [NSMutableArray array];
            [NJProgressHUD showInfoWithStatus:@"暂时没有资讯！"];
            [NJProgressHUD dismissWithDelay:1.2];
            return ;
        }
        
        if(page == 1){
            _marList = [NSMutableArray arrayWithArray:dataArr];
            [_tableView reloadData];
            return;
        }
        
        if(page > 1 && (dataArr == nil || dataArr.count == 0)){
            page -= 1;
            [NJProgressHUD showInfoWithStatus:@"已经到底了"];
            [NJProgressHUD dismissWithDelay:1.2];
            [_marList addObjectsFromArray:dataArr];
            [_tableView reloadData];
            return ;
        }
        
        [_marList addObjectsFromArray:dataArr];
        [_tableView reloadData];
        
    }];
}


#pragma mark - setter and getter

- (void)setTableviewRefreshInit
{
    page = 1;
   
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - other

- (void)loadNewData
{
    page = 1;
    [self httpGetPageTask:page type:_type typeId:_typeID];
}

- (void)loadMoreData
{
    page += 1;
    [self httpGetPageTask:page type:_type typeId:_typeID];
}

@end
