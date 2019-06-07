//
//  UIView+NJSnapshot.m
//  Destination
//
//  Created by TouchWorld on 2018/12/28.
//  Copyright © 2018 Redirect. All rights reserved.
//

#import "UIView+NJSnapshot.h"

@implementation UIView (NJSnapshot)
- (UIImage *)nj_snapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outpu = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outpu;
}

- (UIImage *)nj_snapshotAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self nj_snapshot];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *outpu = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outpu;
}

@end
