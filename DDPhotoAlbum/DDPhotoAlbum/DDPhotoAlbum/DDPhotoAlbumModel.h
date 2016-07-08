//
//  DDPhotoAlbumModel.h
//  DDPhotoAlbum
//
//  Created by dd2333 on 16/7/6.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAssetsGroup;
@class UIImage;

@interface DDPhotoAlbumModel : NSObject

/**
 *  名称
 */
@property (nonatomic, strong) NSString *name;

/**
 *  类型
 */
@property (nonatomic, strong) NSNumber *type;

/**
 *  相册数
 */
@property (nonatomic, assign) NSInteger count;

/**
 *  封面
 */
@property (nonatomic, strong) UIImage *posterImage;

/**
 *  相册
 */
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end
