//
//  HBPopularInformationsVC.m
//  Destination
//
//  Created by 胡勃 on 6/24/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HDHotTaskVC.h"
#import "HDHotTaskModel.h"
#import "HBInformationCell.h"

@interface HDHotTaskVC ()<UIWebViewDelegate>//所有资讯列表页面
{
    NSURLSessionDataTask    *task;
    NSMutableArray          *marPopularNewsList;
    UIViewController        *webViewCtr;
    IBOutlet UITableView    *tbv;
    NSUInteger page;
}

@end

@implementation HDHotTaskVC
    
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setTableviewRefreshInit];
    [self loadNewData];
 
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HDHotTaskModel *model = marPopularNewsList[indexPath.section];
//    [self showAnnouncementPage:model.NoticeUrl];
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



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return marPopularNewsList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"HBInformationCell";
    HBInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [HBInformationCell loadFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HDHotTaskModel *model = marPopularNewsList[indexPath.row];
    [cell.imvPhoto setImage:HDIMAGE(@"main_cellHeadImage")];
    cell.lbMainheading.text = model.TaskTitle;
    NSString *strAmount = HDFORMAT(@"%@/%@", model.HasSaleNum, model.Quantity);
    cell.lbSubheading.text  = strAmount;
    cell.lbMoney.text = model.Commission;//@"¥ +1.99元";
    
    return cell;
}

#pragma mark - Http event

- (void)httpGetHotTask:(NSInteger)indexPage
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    NSDictionary *dic = @{@"PageSize":  @"10",
                          @"PageIndex": @(indexPage)
                          };
    [helper.parameters addEntriesFromDictionary:dic];
    [NJProgressHUD show];
    task = [helper postPath:@"Act203" object:[HDHotTaskModel class] finished:^(HDError *error, id object, BOOL isLast, id json)
            {
                [tbv.mj_footer endRefreshing];
                [tbv.mj_header endRefreshing];
                if (error) {
                    [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
                    
                    return ;
                }
                
                NSArray * dataArr = [NSArray array];
                if ([object isKindOfClass:[NSArray class]] && object) {
                    NSArray * dataArr = object;
                }else {
                    return;
                }
                
                if (dataArr.count < 1) {
                    [NJProgressHUD showInfoWithStatus:@"暂时没有公告信息"];
                    [NJProgressHUD dismissWithDelay:1.2];
                    return ;
                }
                
                if(page == 0){
                    [marPopularNewsList removeAllObjects];
                }
                
                if(page > 0 && (dataArr == nil || dataArr.count == 0)){
                    page -= 1;
                    [NJProgressHUD showInfoWithStatus:@"已经到底了"];
                    [NJProgressHUD dismissWithDelay:1.2];
                    return ;
                }
                
                [marPopularNewsList addObjectsFromArray:dataArr];
                [tbv reloadData];
                
            }];
}

#pragma mark - touch even

- (void)showAnnouncementPage:(NSString *)strUrlLink
{
    if (!strUrlLink || strUrlLink.length < 1) {
        Dlog(@"HBAnnouncementVC: this announcement don't contains a urlLink!");
        return;
    }
    
    NSURL *url = [NSURL URLWithString:HDSTR(strUrlLink)];
    NSString *strUrl = url.absoluteString;
    
    if (url) {
        webViewCtr = [UIViewController new];
        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        web.scalesPageToFit = YES;
        [webViewCtr.view addSubview:web];
        [web makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(webViewCtr.view);
            make.size.equalTo(webViewCtr.view);
        }];
        [web loadRequest:[NSURLRequest requestWithURL:url]];
        web.delegate = self;
        
        [self.navigationController pushViewController:webViewCtr animated:YES];
    }
}

#pragma mark - setter and getter

- (void)setupUI
{
    self.title = @"公告列表";
}

- (void)setTableviewRefreshInit
{
    page = 0;
    
    tbv.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tbv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


#pragma mark - other

- (void)loadNewData
{
    page = 0;
    [self httpGetHotTask:page];
}

- (void)loadMoreData
{
    page += 1;
    [self httpGetHotTask:page];
}

@end
