
# DDPhotoAlbum

[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/dd2333/DDPhotoAlbum/blob/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/DDPhotoAlbum.svg?style=flat)](http://cocoapods.org/?q=DDPhotoAlbum)&nbsp;
[![SUPPORT](https://img.shields.io/badge/support-iOS%207%2B%20-blue.svg?style=flat)](https://en.wikipedia.org/wiki/IOS_7)&nbsp;
[![BLOG](https://img.shields.io/badge/blog-www.dd2333.com-orange.svg?style=flat)](http://www.dd2333.com)&nbsp;

  iOS library that provides for multiple image selection.<br />
  
  ![github](https://github.com/dd2333/DDPhotoAlbum/blob/master/demo.gif "github")
  
Installation
-----------------------------------
  Download DDPhotoAlbum and try out the included iPhone example apps<br />

Usage
-----------------------------------
* The simulator does not support the camera.<br />

### Cocoapods import:
* DDPhotoAlbum is available on CocoaPods. Just add the following to your project Podfile:<br />

  ```pod 'DDPhotoAlbum', '~> 1.1.1'```

* Use by including the following import:<br />
```#import <DDPhotoAlbum.h>```

### Manual import：
* Drag All files in the DDPhotoAlbum folder to project<br />
* Use by including the following import:<br />
```#import "DDPhotoAlbum.h"```

### Open the Album
    DDPhotoAlbumViewController *photoAlbumViewController = [[DDPhotoAlbumViewController alloc]init];
    photoAlbumViewController.maxPhotos = self.maxPhotos;
    photoAlbumViewController.isShowCamera = self.isShowCamera;
    photoAlbumViewController.didSelectAutoBack = YES;
    [photoAlbumViewController setPreLoadingImages:_thumbnailImages imageUrls:_imageUrls];
    [photoAlbumViewController setDidSelectedBlock:^(NSArray *images,NSArray *thumbnailImages,NSArray *imagesUrl) {
        _thumbnailImages = thumbnailImages;
        _imageUrls = imagesUrl;
        //handle
    }];
    [photoAlbumViewController setDidCancelBlock:^{
        //handle
    }];
    [self presentViewController:photoAlbumViewController animated:YES completion:nil];

