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
    NSMutableArray          *marNewsList;
    NSMutableArray          *marHotTaskList;
    UIViewController        *webViewCtr;
    IBOutlet UITableView    *tbv;
    
}

@end

@implementation HDHotTaskVC
    
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self httpGetHotTask:1];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HDHotTaskModel *model = marNewsList[indexPath.section];
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
    return marNewsList.count;
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
    HDHotTaskModel *model = marHotTaskList[indexPath.row];
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
                [NJProgressHUD dismiss];
                if (error) {
                    [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
                    
                    return ;
                }
                
                if (indexPage == 1) {
                    marNewsList = [[NSMutableArray alloc] initWithArray:object];
                } else {
                    [marNewsList addObjectsFromArray:object];
                }
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

@end
