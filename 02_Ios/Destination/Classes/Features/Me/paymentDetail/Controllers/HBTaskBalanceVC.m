//
//  HBTaskBalanceVC.m
//  Destination
//
//  Created by 胡勃 on 7/7/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBTaskBalanceVC.h"
#import "HBCommissionBalanceCell.h"
#import "HBCommissionModel.h"


@interface HBTaskBalanceVC ()
{
    IBOutlet UITableView    *tbv;
    NSURLSessionTask        *task;
    NSMutableArray          *marDiscoverList;
    NSUInteger page;

}

@end

@implementation HBTaskBalanceVC

#pragma mark - life cycle

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear:HBTaskBalanceVC");
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear:HBTaskBalanceVC");
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
    return 60.;
    
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
    static NSString *str = @"HBCommissionBalanceCell";
    HBCommissionBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [HBCommissionBalanceCell loadFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HBCommissionModel *model = marDiscoverList[indexPath.row];
    cell.lbTitle.text   = model.ChargeDesc;
    cell.lbDetail.text  = model.OperateDT;
    cell.lbNote.text    = model.Status;
    cell.lbAmount.text  = model.Charge;
    return cell;
}

#pragma mark - http event

- (void)httpGetCommissionList:(NSInteger)indexPage  //
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    NSDictionary *dic = @{@"PageSize": @"10",
                          @"PageIndex": @(indexPage),
                          @"chargeType": @(2),
                          };
    [helper.parameters addEntriesFromDictionary:dic];
    
    task = [helper postPath:@"Act121" object:[HBCommissionModel new] finished:^(HDError *error, id object, BOOL isLast, id json)
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
    [self httpGetCommissionList:page];
}

- (void)loadMoreData
{
    page += 1;
    [self httpGetCommissionList:page];
}
@end
