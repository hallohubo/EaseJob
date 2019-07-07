//
//  HBMarginVC.m
//  Destination
//
//  Created by 胡勃 on 7/7/19.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HBMarginVC.h"
#import "HBCommissionBalanceCell.h"


@interface HBMarginVC ()
{
    IBOutlet UITableView    *tbv;
    NSURLSessionTask        *task;
}

@end

@implementation HBMarginVC

#pragma mark - life cycle

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear:HBMarginVC");
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear:HBMarginVC");
}


- (void)viewDidLoad {
    [super viewDidLoad];
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
    return 100.;
    
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"HBDiscoverCell";
    HBCommissionBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [HBCommissionBalanceCell loadFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //    HBDiscoverModel *model = marDiscoverList[indexPath.section];
    //
    //    cell.vBackground.layer.cornerRadius = 6.f;
    //    cell.vBackground.layer.masksToBounds= YES;
    //
    //    [cell.imvPhoto setImage:HDIMAGE(@"main_cellHeadImage")];
    //    cell.lbMainheading.text = model.TaskTitle;
    //    NSString *strAmount = HDFORMAT(@"%@/%@", model.HasSaleNum, model.Quantity);
    //    cell.lbSubheading.text  = strAmount;
    //    cell.lbMoney.text = model.Commission;//@"¥ +1.99元";
    
    return cell;
}

#pragma mark - http event

- (void)httpGetRecentlyNews:(NSInteger)indexPage  //
{
    //    HDHttpHelper *helper = [HDHttpHelper instance];
    //    NSDictionary *dic = @{@"PageSize": @"10",
    //                          @"PageIndex": @(indexPage),
    //                          @"type": @"0",
    //                          };
    //    [helper.parameters addEntriesFromDictionary:dic];
    //
    //    task = [helper postPath:@"Act204" object:[HBDiscoverModel new] finished:^(HDError *error, id object, BOOL isLast, id json)
    //            {
    //                if (error) {
    //                    if (error.code != 0 ) {
    //                        [HDHelper say:error.desc];
    //                    }
    //                    return ;
    //                }
    //                if (!object) {
    //                    return;
    //                }
    //                marDiscoverList = object;
    //
    //
    //            }];
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //这一步是实现跟踪器时刻跟随scrollView滑动的效果,如果对self.pageMenu.scrollView赋了值，这一步可省
    //     [vPageMenu moveTrackerFollowScrollView:scrollView];
}


@end
