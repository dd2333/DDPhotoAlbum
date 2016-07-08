//
//  DDPhotoAlbumLayout.m
//  DDPhotoAlbum
//
//  Created by dd2333 on 16/6/27.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import "DDPhotoAlbumLayout.h"

@interface DDPhotoAlbumLayout()

/**
 *  布局属性
 */
@property (nonatomic,strong) NSMutableArray *attrsArray;

@end

@implementation DDPhotoAlbumLayout{
    CGFloat _maxY;
    CGFloat _maxX;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initArgu];
    }
    return self;
}

- (void)initArgu{
    self.columnsCount = 4;
    self.columnMargin = 5;
    self.rowMargin = 5;
    self.itemInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.attrsArray = [[NSMutableArray alloc]initWithCapacity:10];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (void)prepareLayout{
    [super prepareLayout];
    
    [self.attrsArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i<count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (self.collectionView.frame.size.width - self.itemInset.left - self.itemInset.right - self.columnMargin*(self.columnsCount-1))/self.columnsCount;
    
    CGFloat x = self.itemInset.left + (width+self.columnMargin)*(indexPath.row%self.columnsCount);
    CGFloat y = self.itemInset.top + (width+self.rowMargin)*(indexPath.row/self.columnsCount);
    
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attrs.frame = CGRectMake(x, y, width, width);
    
    _maxX = self.collectionView.frame.size.width;
    _maxY = y + width +self.itemInset.bottom;
    return attrs;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;
}

- (CGSize)collectionViewContentSize{
    return CGSizeMake(_maxX, _maxY);
}

@end
