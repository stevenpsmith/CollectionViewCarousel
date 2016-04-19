//
//  CustomFlowLayout.m
//  CollectionViewCarousel
//
//  Created by Steve Smith on 4/18/16.
//  Copyright © 2016 Steve Smith. All rights reserved.
//

#import "CustomFlowLayout.h"

@implementation CustomFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect cvBounds = self.collectionView.bounds;
    CGFloat horizCenter = cvBounds.size.width / 2.0;
    CGFloat proposedContentOffsetCenterX = proposedContentOffset.x + horizCenter;
    
    NSArray<UICollectionViewLayoutAttributes *> *visibleAttr = [self layoutAttributesForElementsInRect:cvBounds];
    
    UICollectionViewLayoutAttributes *candidateAttributes;
    for (UICollectionViewLayoutAttributes *attr in visibleAttr){
        if (attr.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }
        if (!candidateAttributes){
            candidateAttributes = attr;
        }else{
            float a = attr.center.x - proposedContentOffsetCenterX;
            float b = candidateAttributes.center.x - proposedContentOffsetCenterX;
            
            if (fabsf(a) < fabsf(b)){
                candidateAttributes = attr;
            }
        }
    }
    return CGPointMake(round(candidateAttributes.center.x - horizCenter), proposedContentOffset.y);
}

@end
