//
//  UICollectionView+HDRect.m
//  Destination
//
//  Created by hufan on 2019/5/31.
//  Copyright © 2019 Redirect. All rights reserved.
//

#import "UICollectionView+HDRect.h"

@implementation UICollectionView (HDRect)
- (CGRect)hd_rectForSection:(NSInteger)section {
    NSInteger sectionNum = [self.dataSource collectionView:self numberOfItemsInSection:section];
    if (sectionNum <= 0) {
        return CGRectZero;
    } else {
        CGRect firstRect = [self hd_rectForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        CGRect lastRect = [self hd_rectForRowAtIndexPath:[NSIndexPath indexPathForItem:sectionNum-1 inSection:section]];
        return CGRectMake(0, CGRectGetMinY(firstRect), CGRectGetWidth(self.frame), CGRectGetMaxY(lastRect) - CGRectGetMidY(firstRect));
    }
}

- (CGRect)hd_rectForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self layoutAttributesForItemAtIndexPath:indexPath].frame;
}
@end
