//
//  UIView+NJSnapshot.h
//  Destination
//
//  Created by TouchWorld on 2018/12/28.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (NJSnapshot)
- (UIImage *)nj_snapshot;

- (UIImage *)nj_snapshotAfterScreenUpdates:(BOOL)afterUpdates;
@end

NS_ASSUME_NONNULL_END
