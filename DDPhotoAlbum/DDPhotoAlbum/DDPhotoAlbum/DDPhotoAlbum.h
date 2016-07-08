//
//  DDPhotoAlbum.h
//  DDPhotoAlbum
//
//  Created by dd2333 on 16/6/27.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#ifndef DDPhotoAlbum_h
#define DDPhotoAlbum_h

//头文件
#import "DDPhotoAlbumViewController.h"

//宏
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_SCALE  [[UIScreen mainScreen]scale]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define DDLocalMsg(key) NSLocalizedStringFromTable(key, @"DDPhotoAlbum", @"")

//界面参数
#define DD_MAIN_COLOR RGBA(246,16,84,1)     //主色调

#define DD_NAVAGATIONBAR_BG_COLOR RGBA(255,255,255,1)     //自定义导航栏bg color
#define DD_NAVAGATIONBAR_TINT_COLOR RGBA(246,16,84,1)     //自定义导航栏Tint color
#define DD_NAVAGATIONBAR_TITLE_COLOR RGBA(0,0,0,1)     //自定义导航栏Title color
#define DD_NAVAGATIONBAR_HEIGHT 44.f        //自定义导航栏height

#define DD_ITEM_COLUMN_MARGIN 5                 //列间距
#define DD_ITEM_ROW_MARGIN 5                    //行间距
#define DD_ITEM_COLUMN_COUNT 4                    //列数
#define DD_ITEM_COLUMN_COUNT_LANDSCAPE 7          //横屏下的列数
#define DD_ITEM_INSET UIEdgeInsetsMake(0, 0, 0, 0)  //内边距

#define DD_TOOLBAR_HEIGHT 120.f            //底部工具栏高度
#define DD_TOOLBAR_FONTSIZE 14.f            //底部工具栏文字大小
#define DD_TOOLBAR_ITEM_INSET 4.f            //底部工具栏缩略图内边距

#endif
