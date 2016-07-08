//
//  DDPhotoAlbumLayout.h
//  DDPhotoAlbum
//
//  Created by dd2333 on 16/6/27.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPhotoAlbumLayout : UICollectionViewLayout

/**
 *  列间距
 */
@property (nonatomic,assign) CGFloat columnMargin;
/**
 *  行间距
 */
@property (nonatomic,assign) CGFloat rowMargin;
/**
 *  列数
 */
@property (nonatomic,assign) NSInteger columnsCount;
/**
 *  四周距离
 */
@property (nonatomic,assign) UIEdgeInsets itemInset;

@end
