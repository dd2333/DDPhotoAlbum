//
//  DDPhotoAlbumToolsView.h
//  DDPhotoAlbum
//
//  Created by dd2333 on 16/7/4.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPhotoAlbumToolsView : UIView

@property (nonatomic, copy) void (^didSelectedItem) (NSUInteger indexItem);
@property (nonatomic, copy) void (^doneBtnClick) ();

/**
 *  实例化方法
 *
 *  @param frame    frame
 *  @param maxCount 选中图片的最大个数
 *
 *  @return 实例化对象
 */
- (instancetype)initWithFrame:(CGRect)frame maxCount:(NSUInteger)maxCount;

/**
 *  刷新数据
 *
 *  @param images 图片
 */
- (void)refresh:(NSMutableArray*)images;

@end
