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
#import "HBBannerModel.h"       //轮播图
#import "HBNewsModle.h"         //前3条公告信息
#import "HBTaskNewsModel.h"     //前10条热门资讯
#import "HBAllTaskTypeModle.h"  //Act201 获取所有任务类型及其设置值

#import "LMJScrollTextView.h"

#import "HBAnnouncementVC.h"    //公告列表分页
#import "HDHotTaskVC.h"         //任务列表分页
#import "HDDiscoverVC.h"        //所有类型任务

#import "HLGifHeader.h"

#define BANNER_RATIO 0.64
#define BANNER_MODEL @"BANNER_MODEL"



@interface HDMainVC ()<UINavigationControllerDelegate, UIWebViewDelegate>
{
    IBOutlet LMJScrollTextView  *vNews;
    IBOutlet UIView             *vHeadView;
    IBOutlet UIPageControl      *pageControl;
    IBOutlet HB3DScrollView     *scv_banner;
    IBOutlet UIView             *vScrollviewContent;
    IBOutlet UIView             *vMessage;
    IBOutlet UITableView        *tbv;
    IBOutlet UIButton           *btnCheck;
    IBOutlet NSLayoutConstraint *lcAllTaksHeight;//adjust all task view height
    IBOutlet NSLayoutConstraint *lcHeadHeight;
    
    IBOutlet UIButton           *btn0, *btn1, *btn2, *btn3, *btn4,
                                *btn5, *btn6, *btn7, *btn8, *btn9;
    
    IBOutlet UILabel            *lb0, *lb1, *lb2, *lb3, *lb4,
                                *lb5, *lb6, *lb7, *lb8, *lb9;
    
    IBOutlet UIImageView        *imv0, *imv1, *imv2, *imv3, *imv4,
                                *imv5, *imv6, *imv7, *imv8, *imv9;
    
    NSArray                     *ar_bannerList;
    NSMutableArray              *marAllTaskList;
    NSMutableArray              *marOrderList;
    NSMutableArray              *marHeadScrollImageList;
    NSMutableArray              *marTaskNewsList;
    UIViewController            *webViewCtr;

    
    NSURLSessionDataTask        *task;
    NSTimer                     *timer;
    NSUInteger page;
//    UITabBarController          *tabbarCtr;
    
    NSArray     *arLables;
    NSArray     *arImgviews;
    NSArray     *arButtons;
}

@end

@implementation HDMainVC

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupInit];
    [self setTableviewRefreshInit];
    [self setTableHead:290];
    [self setBannerView:nil];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    [self loadNewData];
    [self httpGetBannerImages];
    [self httpGetRecentlyAnnounce:nil];
    [self httpGetAllTask];
}

- (void)dealloc
{
    self.navigationController.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    
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
    return marTaskNewsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"HBInformationCell";
    HBInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell){
        cell = [HBInformationCell loadFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HBTaskNewsModel *model = marTaskNewsList[indexPath.row];
    [cell.imvPhoto setImage:HDIMAGE(@"main_cellHeadImage")];
    cell.lbMainheading.text = model.TaskTitle;
    NSString *strAmount = HDFORMAT(@"%@/%@", model.HasSaleNum, model.Quantity);
    cell.lbSubheading.text  = strAmount;
    cell.lbMoney.text = model.Commission;//@"¥ +1.99元";
    
    return cell;
}

#pragma mark - Button event

- (void)loadMoreInformation     //jump to more hot task page
{
    [self.navigationController pushViewController:[HDHotTaskVC new] animated:YES];
}

- (void)goBannerDetail:(UITapGestureRecognizer *)tap
{
    UIView *v = tap.view;
    NSURL *url = nil;
    int tab = v.tag;
    if (v.tag < marHeadScrollImageList.count) {
        HBBannerModel *bannerModel = marHeadScrollImageList[v.tag];
        NSString *strLinkType   = HDSTR(bannerModel.LinkType);
        NSString *strExternalLink   = HDSTR(bannerModel.ExternalLink);
       
        if ([strLinkType isEqualToString:@"0"]) {
            Dlog(@"0代表无跳转");
            return;
        }
        if (!strExternalLink || strExternalLink.length < 1) {
            Dlog(@"主页主宣传图链接为空");
            return;
        }
        
        url = [NSURL URLWithString:HDSTR(bannerModel.ExternalLink)];
        NSString *strUrl = url.absoluteString;
        if (strUrl.length < 1) {
            return;
        }
        if (url) {
            webViewCtr = [UIViewController new];
            webViewCtr.title = @"活动详情";
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
}

- (IBAction)checkoutAnnouncementsList:(UIButton *)sender
{
    [self.navigationController pushViewController:[HBAnnouncementVC new] animated:YES];
}

#pragma mark - Http event

- (void)httpGetAllTask {//获取所有任务类型及其设置值
    HDHttpHelper *helper = [HDHttpHelper instance];
    [NJProgressHUD show];
    
    task = [helper postPath:@"Act201" object:[HBAllTaskTypeModle class] finished:^(HDError *error, id object, BOOL isLast, id json)
    {
        [NJProgressHUD dismiss];
        if (error) {
            if (error.code != 0) {
                [LBXAlertAction sayWithTitle:@"提示" message:error.desc buttons:@[ @"确认"] chooseBlock:nil];
            }
            return ;
        }
        if (![object isKindOfClass:[NSArray class]]) {
            return;
        }
        
        marAllTaskList = object;
        Dlog(@"maralltask:%@", marAllTaskList);
        [self setAllTaskView];
    }];
}

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
        if (![object isKindOfClass:[NSArray class]]) {
            return;
        }
        ar_bannerList = object;
        [self setBannerView:ar_bannerList];
    }];
}

- (void)httpGetRecentlyAnnounce:(NSInteger)indexPage    //获取3条公告走马灯
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    task = [helper postPath:@"Act008" object:[HBNewsModle class] finished:^(HDError *error, id object, BOOL isLast, id json)
    {
        if (error) {
            if (error.code != 0 ) {
                [HDHelper say:error.desc];
            }
            return ;
        }
        NSArray *ar = object;
        NSString *strContent = [NSString string];
        if (!ar || ar.count < 1) {
            strContent = @"                      平台暂时没有新的公告信息!                                             ";
            [self setFlowWords:strContent];
            return;
        }else {
            for (id obj in ar) {
                HBNewsModle *modle = obj;
                strContent = HDFORMAT(@"        %@        %@  ", strContent, modle.NoticeTitle);
            }
            [self setFlowWords:strContent];
        }
    }];
}

- (void)httpGetHotTenTask:(NSInteger)indexPage //获取前10条热门任务
{
    HDHttpHelper *helper = [HDHttpHelper instance];
    NSDictionary *dic = @{@"PageSize":  @"10",
                          @"PageIndex": @(indexPage)
                          };
    [helper.parameters addEntriesFromDictionary:dic];
    
    task = [helper postPath:@"Act202" object:[HBTaskNewsModel class] finished:^(HDError *error, id object, BOOL isLast, id json)
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
            marTaskNewsList = [NSMutableArray arrayWithArray:dataArr];
            [tbv reloadData];
            return;
        }
        
        [marTaskNewsList addObjectsFromArray:dataArr];
        [tbv reloadData];
        
    }];
}

#pragma mark - setter and getter

- (void)setupInit
{
    self.navigationController.delegate = self;//设置导航控制器的代理为self
    
    [vMessage addBorderWidth:0.f color:nil cornerRadius:5.0];
    
    scv_banner.backgroundColor  = [UIColor groupTableViewBackgroundColor];
    pageControl.numberOfPages = ar_bannerList.count;
    
    arLables   = @[lb0, lb1, lb2, lb3, lb4, lb5, lb6, lb7, lb8, lb9];
    arImgviews = @[imv0, imv1, imv2, imv3, imv4, imv5, imv6, imv7, imv8, imv9];
    arButtons  = @[btn0, btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9];
    [self setUIObjectHiden:arLables];
    [self setUIObjectHiden:arButtons];
    [self setUIObjectHiden:arImgviews];
}

- (void)setUIObjectHiden:(NSArray *)UIObject
{
    for (id object in UIObject) {
        [object setHidden:YES];
    }
}

- (void)setTableviewRefreshInit // add refresh body on tableview
{
    page = 1;
    tbv.mj_header = [HLGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //    tbv.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tbv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)setFlowWords:(NSString *)word //adjust announcement lable
{
    CGRect frame = [vNews convertRect:vNews.bounds toView:vMessage];
    Dlog(@"WINDowframe:%@", NSStringFromCGRect(frame));
    
    vNews = [[LMJScrollTextView alloc] initWithFrame:frame textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
    [vNews setMoveSpeed:0.03];
    [vMessage addSubview:vNews];
    
    [vNews startScrollWithText:word textColor:HDCOLOR_RED font:[UIFont systemFontOfSize:13]];
}

- (void)setTableHead:(NSInteger)intHeight//adjust the tableview's head
{
    CGFloat height = intHeight + (HDDeviceSize.width) * BANNER_RATIO;
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
    marHeadScrollImageList = mar;//used for geting the jumping_link when click image;
    
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

- (void)setAllTaskView  // according the all task case to change task's view
{
    NSRange range = NSMakeRange(marAllTaskList.count>9 ? 9 : marAllTaskList.count, marAllTaskList.count>9 ? marAllTaskList.count-9 : 0);
    [marAllTaskList removeObjectsInRange:range];
    
    HBAllTaskTypeModle *model = [HBAllTaskTypeModle new];
    model.TaskType = @"全部";
    model.TaskIcon = @"main_all";
    model.TaskTypeID = @"0";
    [marAllTaskList addObject:model];//insert "全部" item
    
    for (int i = 0; i < marAllTaskList.count; i++) {
        HBAllTaskTypeModle *model = marAllTaskList[i];
        NSURL *url  = [NSURL URLWithString:model.TaskIcon];
        UILabel *lb = arLables[i];
        lb.hidden   = NO;
        lb.text = model.TaskType;
        
        UIButton *btn   = arButtons[i];
        btn.hidden  = NO;
        btn.tag = i;
        [btn addTarget:self action:@selector(checkAllTaskDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imv = arImgviews[i];
        imv.hidden = NO;
        [imv sd_setImageWithURL:url];
        if (marAllTaskList.count == i+1) {
            [imv setImage:HDIMAGE(@"main_all")];
        }
    }
    //need to change the tableview's height at the head part of view
    lcAllTaksHeight.constant = marOrderList.count > 5 ? 210. : 130.;
    [self setTableHead:marOrderList.count > 5 ? 290 : 210];
}

#pragma mark - other

- (void)loadNewData
{
    page = 1;
    [self httpGetHotTenTask:page];
}

- (void)loadMoreData
{
    page = 1;   //main page only get ten information;
    [self httpGetHotTenTask:page];
}

- (void)checkAllTaskDetail:(UIButton *)sender
{
    HBAllTaskTypeModle *model = marAllTaskList[sender.tag];
    
    UILabel *lb = arLables[sender.tag]; //special case when type is all
    if ([lb.text isEqualToString:@"全部"]) {
        model.TaskTypeID = @"0";
    }
    
    // in this app cycle the tabBarController  is the global variable, so we can catch its point and don't worry about crashing
    UITabBarController *tab = self.tabBarController;
    NSArray *views = self.tabBarController.viewControllers;
    
    NJNavigationController *cc = views[1];
    if ([cc.tabBarItem.title isEqualToString:@"发现"]) {
        HDDiscoverVC *ctr = cc.childViewControllers[0];
        HDGI.typeID = model.TaskTypeID;
        tab.selectedIndex = 1;
    }
}

@end

