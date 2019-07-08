//
//  HBAmountFrozenVC.m
//  Destination
//
//  Created by 胡勃 on 7/7/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBAmountFrozenVC.h"
#import "HBFrozenAcountCell.h"
#import "HBFrozenAmountModel.h"

@interface HBAmountFrozenVC ()
{
    IBOutlet UITableView    *tbv;
    NSURLSessionTask        *task;
    NSMutableArray          *marDiscoverList;
    NSUInteger page;
}
@end

@implementation HBAmountFrozenVC

#pragma mark - life cycle

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear:HBAmountFrozenVC");
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear:HBAmountFrozenVC");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableviewRefreshInit];
    [self loadNewData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return marDiscoverList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"HBFrozenAcountCell";
    HBFrozenAcountCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [HBFrozenAcountCell loadFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HBFrozenAmountModel *model  = marDiscoverList[indexPath.row];
    
    cell.lbSerialNumber.text    = model.TaskNo;
    cell.lbFrozenAmount.text    = model.FreezingBalance;
    cell.lbFrozenMargin.text    = model.FreezingDeposit;
    cell.lbTitle.text   = model.TaskTitle;
    cell.lbType.text    = model.TaskPayType;
    [cell.imvPhoto sd_setImageWithURL:[NSURL URLWithString:model.TaskIcon]];

    return cell;

}

#pragma mark - http event

- (void)httpGetFrozenList:(NSInteger)indexPage  //
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    NSDictionary *dic = @{@"PageSize": @"10",
                          @"PageIndex": @(indexPage),
                          };
    [helper.parameters addEntriesFromDictionary:dic];
    
    task = [helper postPath:@"Act122" object:[HBFrozenAmountModel new] finished:^(HDError *error, id object, BOOL isLast, id json)
            {
                [tbv.mj_footer endRefreshing];
                [tbv.mj_header endRefreshing];
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
                
                if (dataArr.count < 1 && page == 1) {
                    [NJProgressHUD showInfoWithStatus:@"暂时没有资讯！"];
                    [NJProgressHUD dismissWithDelay:1.2];
                    return ;
                }
                
                if(page == 1){
                    marDiscoverList = [NSMutableArray arrayWithArray:dataArr];
                    [tbv reloadData];
                    return;
                }
                
                if(page > 1 && (dataArr == nil || dataArr.count == 0)){
                    page -= 1;
                    [NJProgressHUD showInfoWithStatus:@"已经到底了"];
                    [NJProgressHUD dismissWithDelay:1.2];
                    [marDiscoverList addObjectsFromArray:dataArr];
                    [tbv reloadData];
                    return ;
                }
                
                [marDiscoverList addObjectsFromArray:dataArr];
                [tbv reloadData];
                
            }];
}

#pragma mark - setter and getter

- (void)setupInit
{
    
}

- (void)setTableviewRefreshInit
{
    page = 1;
    
    tbv.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tbv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - other

- (void)loadNewData
{
    page = 1;
    [self httpGetFrozenList:page];
}

- (void)loadMoreData
{
    page += 1;
    [self httpGetFrozenList:page];
}
@end
