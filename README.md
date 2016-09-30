[![image]](http://www.dd2333.com/)
[image]: https://github.com/dd2333/DDPhotoAlbum/blob/master/dd2333.png "github"

DDPhotoAlbum
===================================
  iOS library that provides for multiple image selection.<br />
  ![github](https://github.com/dd2333/DDPhotoAlbum/blob/master/demo.gif "github")
Installation
-----------------------------------
  Download DDPhotoAlbum and try out the included iPhone example apps<br />

Requirements
-----------------------------------
* iOS 7.0+<br />
* ARC<br />

Usage
-----------------------------------
* The simulator does not support the camera.<br />

### Cocoapods import:
* Pop is available on CocoaPods. Just add the following to your project Podfile:<br />

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

License
-----------------------------------
  DDPhotoAlbum is released under the MIT license.<br />
