//
// HDHUD.m
//  DennisHu
//
//  Created by DennisHu on 14-8-15.
//
//

#import "HDHUD.h"
#import <SDAnimatedImageRep.h>
@interface HDHUD () <MBProgressHUDDelegate>{
    
}

@end

static HDHUD *HDData = NULL;
@implementation HDHUD

+ (HDHUD *)instance{
    @synchronized(self){
        if (HDData) {
            [HDData hiden];
            HDData = nil;
        }
        HDData = [[HDHUD alloc] init];
    }
    return HDData;
}

+ (HDHUD *)showLoading:(NSString *)text on:(UIView *)view {
    HDHUD *manager  = [HDHUD instance];
    manager.progressHud     = [MBProgressHUD showHUDAddedTo:view animated:YES];
    manager.progressHud.delegate        = manager;
    manager.progressHud.labelText       = text;
    manager.progressHud.backgroundColor = [UIColor clearColor];
    manager.progressHud.removeFromSuperViewOnHide = YES;
    manager.progressHud.mode = MBProgressHUDModeCustomView;
    
    //自定义imageView
    NSMutableArray *mar = [[NSMutableArray alloc] init];
    for (int i = 1; i < 16; i++) {
        UIImage *img = [UIImage imageNamed:HDFORMAT(@"load%d", i)];
        if (img) {
            [mar addObject:img];
        }
    }
    UIImageView *cusImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    cusImageV.animationImages = mar;
    cusImageV.animationDuration = 1.75;
    [cusImageV startAnimating];
    //设置hud模式
    manager.progressHud.mode = MBProgressHUDModeCustomView;
    
    //设置在hud影藏时将其从SuperView上移除,自定义情况下默认为NO
    manager.progressHud.removeFromSuperViewOnHide = YES;
    
    //设置方框view为该模式后修改颜色才有效果
//    manager.progressHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    //设置方框view背景色
    manager.progressHud.color = [UIColor clearColor];
    
    //设置总背景view的背景色，并带有透明效果
//    manager.progressHud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    manager.progressHud.customView = cusImageV;
    manager.progressHud.customView.backgroundColor = [UIColor clearColor];
    return manager;
}


+ (void)showNote:(NSString *)text on:(UIView *)view {
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText       = text;
    hud.mode            = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (void)show:(NSString *)text on:(UIView *)view{
    self.progressHud     = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.progressHud.delegate        = self;
    self.progressHud.labelText       = nil;
    self.progressHud.backgroundColor = [UIColor clearColor];
    self.progressHud.removeFromSuperViewOnHide = YES;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
}
- (void)hiden {
    [self.progressHud hide:YES];
}

@end
