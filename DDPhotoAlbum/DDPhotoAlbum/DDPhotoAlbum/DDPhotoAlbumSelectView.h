//
//  DDPhotoAlbumSelectView.h
//  DDPhotoAlbum
//
//  Created by dd2333 on 16/7/6.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectedAlbum) (NSUInteger index);
typedef void (^CancelSelectAlbum) ();

@interface DDPhotoAlbumSelectView : UIView

@property (nonatomic, strong) UITableView *tableView;

/**
 *  相册信息
 */
@property (nonatomic, strong) NSArray *albumsInfo;

/**
 *  选中相册后的block
 */
@property (nonatomic, copy) DidSelectedAlbum didSelectedAlbum;

/**
 *  取消相册后的block
 */
@property (nonatomic, copy) CancelSelectAlbum cancelSelectAlbum;

- (void)setDidSelectedAlbum:(DidSelectedAlbum)didSelectedAlbum;

- (void)setCancelSelectAlbum:(CancelSelectAlbum)cancelSelectAlbum;

@end
