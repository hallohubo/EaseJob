//
//  HDMainVC.m
//  Destination
//
//  Created by hufan on 2019/6/1.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "HDMainVC.h"
#import "HB3DScrollView.h"
#import "HBInformationCell.h"
#import "HBLoginPageVC.h"

#import "NJNavigationController.h"
#import "AppDelegate.h"
#import "HBBannerModel.h"
#import "HBNewsModle.h"
#import "LMJScrollTextView.h"

#define BANNER_RATIO 0.64
#define BANNER_MODEL @"BANNER_MODEL"

@interface HDMainVC ()<UINavigationControllerDelegate>
{
    IBOutlet LMJScrollTextView  *vNews;
    IBOutlet UIView             *vHeadView;
    IBOutlet UIPageControl      *pageControl;
    IBOutlet HB3DScrollView     *scv_banner;
    IBOutlet UIView             *vScrollviewContent;
    IBOutlet UIView             *vMessage;
    IBOutlet UITableView        *tbv;
    IBOutlet UIButton           *btnCheck;
    
    IBOutlet UIButton           *btnRegister;
    IBOutlet UIButton           *btnVote;
    IBOutlet UIButton           *btnAttention;
    IBOutlet UIButton           *btnBrowse;
    IBOutlet UIButton           *btnDownloa;
    IBOutlet UIButton           *btnforward;
    IBOutlet UIButton           *btnPost;
    IBOutlet UIButton           *btnComment;
    IBOutlet UIButton           *btnECommerce;
    IBOutlet UIButton           *btnAll;
    
    NSArray                     *ar_bannerList;
    NSMutableArray              *mar_pakageList;
    NSMutableArray              *marOrderList;
    NSMutableArray              *marHeadScrollImageList;

    
    NSURLSessionDataTask        *task;
    NSTimer                     *timer;
    HDHUD                       *hud;
    int                         needReload; //失败一次+1，<= 0不用重新请求
}

@end

@implementation HDMainVC

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self setTableHead];
    [self setBannerView:nil];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    [self httpGetBannerImages];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)dealloc
{
    self.navigationController.delegate = nil;
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    scv_banner.scrollEnabled = YES;
    if ([scrollView isEqual:scv_banner]) {
        if (scv_banner.currentPage == ar_bannerList.count + 1) {
            [scv_banner loadPageIndex:1 animated:NO];
        }
        if (scv_banner.currentPage == 0) {
            [scv_banner loadPageIndex:ar_bannerList.count animated:NO];
        }
        int i = scrollView.contentOffset.x / (HDDeviceSize.width - 6.);
        if (i > ar_bannerList.count + 1) {
            pageControl.currentPage = i - 2;
        }else{
            pageControl.currentPage = i-1;
        }
        return;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:scv_banner]) {
        if (scv_banner.currentPage == ar_bannerList.count + 1) {
            [scv_banner loadPageIndex:1 animated:NO];
        }
        if (scv_banner.currentPage == 0) {
            [scv_banner loadPageIndex:ar_bannerList.count animated:NO];
        }
        int i = scrollView.contentOffset.x / (HDDeviceSize.width - 6.);
        if (i > ar_bannerList.count + 1) {
            pageControl.currentPage = i - 2;
        }else{
            pageControl.currentPage = i-1;
        }
        [self setAutoScrollStart];
        return;
    }else {
        scv_banner.scrollEnabled = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:tbv]) {
        scv_banner.scrollEnabled = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    //    if (refresh.refreshHeader) {
    //        [refresh.refreshHeader egoRefreshScrollViewDidEndDragging:scrollView];
    //    }
}
#pragma mark - 3DScrollView event

- (void)setAutoScrollStart
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:3. target:self selector:@selector(bannerScroll) userInfo:nil repeats:YES];
}

- (void)bannerScroll
{
    [scv_banner loadNextPage:YES];
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
    return section == 0 ? 60. :.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v60 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60)];
    v60.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (tableView.bounds.size.width-20), 60)];
    v1.backgroundColor = [UIColor whiteColor];
    
    [v60 addSubview:v1];
    [v1 makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(v60);
        //make.size.equalTo(v);
        make.left.equalTo(v60).offset(10);
        make.top.equalTo(v60).offset(0);
    }];
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:v1.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = v1.bounds;
    maskLayer.path = maskPath.CGPath;
    v1.layer.mask = maskLayer;
    
    if (section == 0){
        UILabel *lbColum = [[UILabel alloc] init];
        [lbColum setBackgroundColor:HDCOLOR_RED];
        [v1 addSubview:lbColum];
        [lbColum makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(v1);
            make.size.mas_equalTo(CGSizeMake(2, 20));
            make.left.equalTo(v1).offset(10);
        }];
        
        UILabel *lb = [[UILabel alloc] init];
        [lb setFont:HDFONT_TITLE];
        [lb setText:@"热门资讯"];
        [lb setBackgroundColor:[UIColor whiteColor]];
        [v1 addSubview:lb];
        [lb makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(v1);
            make.size.mas_equalTo(CGSizeMake(80, 30));
            make.left.equalTo(v1).offset(20);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(loadMoreInformation)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"更多资讯" forState:UIControlStateNormal];
        [button setTintColor:[UIColor darkGrayColor]];
        button.frame = CGRectMake(0, 0, 100., 30.0);
        
        [v1 addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(v1.centerY);
            make.right.equalTo(v1.mas_right).offset(-20);        }];
        
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5., 9.)];
        [imv setImage:HDIMAGE(@"main_rightArrow")];
        [v1 addSubview:imv];
        [imv makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(v1.centerY);
            make.right.equalTo(v1.mas_right).offset(-10);
        }];

        [v60 updateConstraints];
    }

    return v60;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"HBInformationCell";
    HBInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [HBInformationCell loadFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.imvPhoto setImage:HDIMAGE(@"main_cellHeadImage")];
    cell.lbMainheading.text = @"趣头条看新闻赚钱";
    cell.lbSubheading.text  = @"已抢4/15";
    cell.lbMoney.text = @"¥ +1.99元";
   
    return cell;
}

#pragma mark - Button event

- (void)loadMoreInformation
{
    
}

- (void)goBannerDetail:(UITapGestureRecognizer *)tap
{
    
}

- (IBAction)checkTaskDetail:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:{//注册
//            [self.navigationController pushViewController:[HBLoginPageVC new] animated:YES];
//            break;
        }
        case 1:{//投票
//            [LBXAlertAction sayWithTitle:@"提示" message:@"确定要退出吗?" buttons:@[@"取消", @"确定"] chooseBlock:^(NSInteger buttonIdx) {
//                if (buttonIdx == 1) {
//                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"firstInsurePersonID"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    
//                    HDGI.loginUser = nil;
//                    [HDLoginUserModel clearFromLocal];
//                    Dlog(@"JIGUANG:别名取消");
//                    
//                    NJNavigationController * naviVC = [[NJNavigationController alloc] initWithRootViewController:[HBLoginPageVC new]];
//                    [[UIApplication sharedApplication].keyWindow setRootViewController:naviVC];
//                    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
//
//                }
//            }];
            break;
        }
        case 2:{//关注
            
            break;
        }
        case 3:{//浏览
            
            break;
        }
        case 4:{//下载
            
            break;
        }
        case 5:{//转发
            
            break;
        }
        case 6:{//发帖
            
            break;
        }
        case 7:{//评论
            
            break;
        }
        case 8:{//电商
            
            break;
        }
        case 9:{//全部
            
            break;
        }

        default:
            break;
    }
}

#pragma mark - Http event

- (void)httpGetBannerImages {//获取轮播图
    HDHttpHelper *helper = [HDHttpHelper instance];
    [helper.parameters addEntriesFromDictionary:@{@"position": HDSTR(@"1")}];
    [NJProgressHUD show];
    
    task = [helper postPath:@"Act006" object:[HBBannerModel class] finished:^(HDError *error, id object, BOOL isLast, id json)
    {
        [NJProgressHUD dismiss];
        if (error) {
            if (error.code != 0) {
                [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            }
            return ;
        }
        
        ar_bannerList = object;
        [self setBannerView:ar_bannerList];
    }];
}

- (void)httpGetNewsList:(NSInteger)indexPage {//获取资讯
    HDHttpHelper *helper = [HDHttpHelper instance];
    NSDictionary *dic = @{@"PageSize": @"10",
                          @"PageIndex": @(indexPage)
                          };
    [helper.parameters addEntriesFromDictionary:dic];

    task = [helper postPath:@"Act008" object:[HBNewsModle class] finished:^(HDError *error, id object, BOOL isLast, id json)
    {
        if (error) {
            if (error.code != 0 ) {
                [HDHelper say:error.desc];
            }
            return ;
        }
        marOrderList = [[NSMutableArray alloc] initWithArray:object];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:marOrderList];
        NSDictionary *dic = @{@"news":data};
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"news"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }];
}
#pragma mark - setter and getter

- (void)setup
{
    self.navigationController.delegate = self;//设置导航控制器的代理为self
    
    scv_banner.backgroundColor  = [UIColor groupTableViewBackgroundColor];
    pageControl.numberOfPages = ar_bannerList.count;
    needReload = 0;
    
    [vMessage addBorderWidth:0.f color:nil cornerRadius:5.0];
    UIWindow* desWindow=[UIApplication sharedApplication].keyWindow;
    
    CGRect frame = [vNews convertRect:vNews.bounds toView:desWindow];
    Dlog(@"WINDowframe:%@", NSStringFromCGRect(frame));
    
    Dlog(@"frame:%@", NSStringFromCGRect(vNews.frame));
    Dlog(@"frame:%@", NSStringFromCGRect(vNews.bounds));
    Dlog(@"VMframe:%@", NSStringFromCGRect(vMessage.frame));
    Dlog(@"Vmframe:%@", NSStringFromCGRect(vMessage.bounds));
    Dlog(@"tbvframe:%@", NSStringFromCGRect(tbv.frame));
    Dlog(@"tbvframe:%@", NSStringFromCGRect(tbv.bounds));
    Dlog(@"vHeadframe:%@", NSStringFromCGRect(vHeadView.frame));
    Dlog(@"vHeadframe:%@", NSStringFromCGRect(vHeadView.bounds));
    
    

    vNews = [[LMJScrollTextView alloc] initWithFrame:frame textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
    [vNews setMoveSpeed:0.1];
//    _scrollTextView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vNews];
    
    [vNews startScrollWithText:@" 向左连续滚动字符串     " textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13]];
}

- (void)setTableHead
{
    CGFloat height = 290 + (HDDeviceSize.width) * BANNER_RATIO;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HDDeviceSize.width, height)];
    [v addSubview:vHeadView];
    [vHeadView makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(v);
        make.center.equalTo(v);
    }];
    
    tbv.tableHeaderView = v;
}

- (void)setBannerView:(NSArray *)ar
{
    for (int i = 0; i < scv_banner.subviews.count; i++) {
        UIView *v = scv_banner.subviews[i];
        [v removeFromSuperview];
        i = 0;
    }
    CGFloat height = (HDDeviceSize.width) * BANNER_RATIO;
    if (!ar || ar.count < 1) {
        HBBannerModel *mTemp0 = [HBBannerModel new];
        HBBannerModel *mTemp1 = [HBBannerModel new];
        
        mTemp0.ImgUrl = @"local";
        mTemp1.ImgUrl = @"local";
        ar_bannerList = @[mTemp0, mTemp1];
        ar = ar_bannerList;
    }
    pageControl.numberOfPages = ar.count;
    pageControl.hidesForSinglePage = YES;
    
    NSMutableArray *mar = [[NSMutableArray alloc] initWithArray:ar];
    [mar insertObject:[ar lastObject] atIndex:0];
    [mar addObject:[ar firstObject]];
    marHeadScrollImageList = [[NSMutableArray alloc] init];
    marHeadScrollImageList = mar;//used for geting the link when click image;
    
    scv_banner.contentSize = CGSizeMake((HDDeviceSize.width) * mar.count, 10.);
    [scv_banner loadPageIndex:1 animated:NO];
    
    for (int i = 0; i < mar.count; i++) {
        HBBannerModel *m = mar[i];
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake((HDDeviceSize.width) * i, 0, HDDeviceSize.width, height)];
        if ([m.ImgUrl isEqualToString:@"local"]) {//取写死本地的数据
            [imv setImage:HDIMAGE(@"main_banner")];//
        }else{
            [imv sd_setImageWithURL:[NSURL URLWithString:m.ImgUrl] placeholderImage:HDIMAGE(@"main_banner")];
        }
        imv.userInteractionEnabled = YES;
        imv.contentMode     = UIViewContentModeScaleAspectFill;
        imv.clipsToBounds   = YES;
        imv.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBannerDetail:)];
        [imv addGestureRecognizer:tap];
        [scv_banner addSubview:imv];//ar_bannerList
    }
    [self setAutoScrollStart];
}
@end

