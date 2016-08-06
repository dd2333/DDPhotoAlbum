//
//  DDPhotoAlbumViewController.h
//  DDPhotoAlbum
//
//  Created by dd2333 on 16/6/27.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectedBlock)(NSArray *images,NSArray *thumbnailImages);
typedef void (^DidCancelBlock)();

@interface DDPhotoAlbumViewController : UIViewController

/**
 *  选择照片的最大个数,min 1,max 9,default 9
 */
@property (nonatomic, assign) NSUInteger maxPhotos;

/**
 *  是否显示照相机按钮,default YES
 */
@property (nonatomic, assign) BOOL isShowCamera;

/**
 *  点击完成按钮执行该block
 */
@property (nonatomic, copy) DidSelectedBlock didSelectedBlock;

/**
 *  点击取消按钮执行该block
 */
@property (nonatomic, copy) DidCancelBlock didCancelBlock;

- (void)setDidSelectedBlock:(DidSelectedBlock)didSelectedBlock;

- (void)setDidCancelBlock:(DidCancelBlock)didCancelBlock;

#pragma mark - check
/**
 *  是否允许访问相册
 *
 *  @return 是否允许访问相册
 */
- (BOOL)isPermissionAlbum;

/**
 *  是否允许访问相机
 *
 *  @return 是否允许访问相机
 */
- (BOOL)isPermissionCamera;

@end
