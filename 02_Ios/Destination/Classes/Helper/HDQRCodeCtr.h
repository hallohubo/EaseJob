//
//  HDQRCodeHelper.h
//  Demo
//
//  Created by hufan on 2018/3/1.
//  Copyright © 2018年 hufan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDQRCodeCtr : UIViewController

@property (nonatomic, copy) void (^scanFinishedBlock)(NSString *result);

@end
