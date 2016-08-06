//
//  DDPhotoAlbumViewController.m
//  DDPhotoAlbum
//
//  Created by dd2333 on 16/6/27.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import "DDPhotoAlbumViewController.h"
#import "DDPhotoAlbum.h"
#import "DDPhotoAlbumLayout.h"
#import "DDPhotoAlbumCollectionViewCell.h"
#import "DDPhotoAlbumToolsView.h"
#import "DDPhotoAlbumSelectView.h"
#import "DDPhotoAlbumModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface DDPhotoAlbumViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UINavigationItem *customNavigationItem;
@property (nonatomic, strong) UINavigationBar *customNavigationBar;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DDPhotoAlbumToolsView *toolsView;
@property (nonatomic, strong) DDPhotoAlbumSelectView *albumSelectView;
@property (nonatomic, strong) DDPhotoAlbumLayout *layout;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) NSArray *albumsInfo;          //全部相册信息

@property (nonatomic, strong) NSArray *thumbImages;     //当前相册缩略图
@property (nonatomic, strong) NSArray *imagesURL;       //当前相册url

@property (nonatomic, assign) NSInteger selectedAlbumIndex;  //记录当前选择的相册

@property (nonatomic, strong) NSMutableArray *selectedThumbImages;  //已选择的缩略图
@property (nonatomic, strong) NSMutableArray *selectedImagesURL;    //已选择的图片url

@property (nonatomic, strong) NSLayoutConstraint *selectViewTopConstraint;

@end

@implementation DDPhotoAlbumViewController{
    BOOL _navigationBarHidden;          //记录navagationBar的状态
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _maxPhotos = 9;
        _selectedAlbumIndex = -1;
        _isShowCamera = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isShowCamera) {
        self.imagePickerController = [[UIImagePickerController alloc]init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self initUI];
    [self getAlbums];
}

- (void)viewWillAppear:(BOOL)animated{
    _navigationBarHidden = self.navigationController.navigationBarHidden;
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAlbums) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = _navigationBarHidden;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isShowCamera{
    if ([self isPermissionCamera]) {
        return _isShowCamera;
    }else{
        return NO;
    }
}

- (NSMutableArray *)selectedThumbImages{
    if (!_selectedThumbImages) {
        _selectedThumbImages = [[NSMutableArray alloc]init];
    }
    return _selectedThumbImages;
}

- (NSMutableArray *)selectedImagesURL{
    if (!_selectedImagesURL) {
        _selectedImagesURL = [[NSMutableArray alloc]init];
    }
    return _selectedImagesURL;
}

- (void)dealloc{
    
}

#pragma mark - public

- (void)setMaxPhotos:(NSUInteger)maxPhotos{
    _maxPhotos = MAX(MIN(maxPhotos, 9),1);
}

- (void)setPreLoadingImages:(NSArray*)thumbImages imageUrls:(NSArray*)imageUrls{
    if (thumbImages && imageUrls) {
        if (thumbImages.count > 0 &&
            thumbImages.count <= 9 &&
            imageUrls.count == thumbImages.count) {
            _selectedThumbImages = [[NSMutableArray alloc]initWithArray:thumbImages];
            _selectedImagesURL = [[NSMutableArray alloc]initWithArray:imageUrls];
        }else{
            [NSException raise:@"DDPhotoAlbum" format:@"The images count should be more than 0 and less than or equal to 9"];
        }
    }else{
        _selectedThumbImages = nil;
        _selectedImagesURL = nil;
    }
}

#pragma mark - handle

//点击返回按钮
- (void)backBtnClick:(id)sender{
    [self back];
    if (self.didCancelBlock) {
        self.didCancelBlock();
    }
}

//点击相簿按钮
- (void)albumItemClick:(id)sender{
    self.albumSelectView.albumsInfo = self.albumsInfo;
    [self.albumSelectView.tableView reloadData];
    [self.view removeConstraint:self.selectViewTopConstraint];
    self.selectViewTopConstraint = [NSLayoutConstraint constraintWithItem:_albumSelectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:self.selectViewTopConstraint];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        
    }];
}

- (void)openCamera{
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}
#pragma mark - data

/**
 *  获取全部相册
 */
- (void)getAlbums{
    NSMutableArray *albums = [[NSMutableArray alloc]init];
    self.assetsLibrary = [[ALAssetsLibrary alloc]init];
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [albums addObject:group];
        }else{
            [self getAlbumsInfo:albums];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

/**
 *  获取全部相册信息
 *
 *  @param albums 相册数组
 */
- (void)getAlbumsInfo:(NSArray*)albums{
    NSMutableArray *mutAlbumsInfo = [[NSMutableArray alloc]init];
    for (int i = 0; i < albums.count; i++) {
        ALAssetsGroup *assetsGroup = albums[i];
        NSString *name = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        NSNumber *type = [assetsGroup valueForProperty:ALAssetsGroupPropertyType];
        UIImage *image = [UIImage imageWithCGImage:assetsGroup.posterImage];
        NSInteger count = [assetsGroup numberOfAssets];
        
        DDPhotoAlbumModel *m = [[DDPhotoAlbumModel alloc]init];
        m.name = name;
        m.type = type;
        m.count = count;
        m.posterImage = image;
        m.assetsGroup = assetsGroup;
        
        [mutAlbumsInfo addObject:m];
        
        //默认第一次显示type16，即相机胶卷
        if (self.selectedAlbumIndex < 0 && [type longValue] == 16) {
            self.selectedAlbumIndex = i;
        }
    }
    
    self.albumsInfo = mutAlbumsInfo;
    [self getALbumDetail:self.selectedAlbumIndex];
}

/**
 *  获取指定相册
 *
 *  @param index 索引
 */
- (void)getALbumDetail:(NSUInteger)index{
    DDPhotoAlbumModel *m = self.albumsInfo[index];
    self.customNavigationItem.title = m.name;
    [self getPhoto:m.assetsGroup];
}

/**
 *  获取相册内的图片
 *
 *  @param assetsGroup 相册
 */
- (void)getPhoto:(ALAssetsGroup*)assetsGroup{
    NSMutableArray *mutThumbImages = [[NSMutableArray alloc]init];
    NSMutableArray *mutImagesURL = [[NSMutableArray alloc]init];
    
    [assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
                [mutThumbImages addObject:[UIImage imageWithCGImage:result.thumbnail]];
                [mutImagesURL addObject:[[result defaultRepresentation]url]];
            }
        }else{
            self.thumbImages = mutThumbImages;
            self.imagesURL = mutImagesURL;
            [self.collectionView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.thumbImages.count > 0) {
                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.thumbImages.count - (self.isShowCamera?0:1) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
                    [self showUI];
                }
                
            });
        }
    }];
}

/**
 *  根据url获取原始图片
 *
 *  @param urls       url数组
 *  @param completion 全部获取后执行该block
 */
- (void)getOriginPhotos:(NSArray*)urls completion:(void(^)(NSArray* photos))completion{
    NSMutableArray *selectedImages = [[NSMutableArray alloc]init];
    for (int i = 0; i < urls.count; i++) {
        [self.assetsLibrary assetForURL:urls[i] resultBlock:^(ALAsset *asset) {
            UIImage *img = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [selectedImages addObject:img];
            if (selectedImages.count == urls.count) {
                if (completion) {
                    completion(selectedImages);
                }
            }
        } failureBlock:^(NSError *error) {
            ;
        }];
    }
}

/**
 *  根据url获取图片所在索引
 *
 *  @param url url
 *
 *  @return 索引
 */
- (NSInteger)indexOfImageURL:(NSURL*)url{
    for (int i = 0; i < self.selectedImagesURL.count; i++) {
        NSURL *sURL = self.selectedImagesURL[i];
        if ([url.absoluteString isEqualToString:sURL.absoluteString]) {
            return i;
        }
    }
    return -1;
}

#pragma mark - collectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDPhotoAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.item == self.thumbImages.count) {
        [cell setHighlightSelected:NO];
        [cell.imageView setImage:[UIImage imageNamed:@"DDPhotoAlbum.bundle/Image/camera.png"]];
    }else{
        cell.imageView.image = self.thumbImages[indexPath.item];
        if ([self indexOfImageURL:self.imagesURL[indexPath.item]] >= 0) {
            [cell setHighlightSelected:YES];
        }else{
            [cell setHighlightSelected:NO];
        }
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.isShowCamera) {
        return self.thumbImages.count + 1;
    }else{
        return self.thumbImages.count;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.thumbImages.count == indexPath.item) {
        [self openCamera];
    }else{
        NSInteger index = [self indexOfImageURL:self.imagesURL[indexPath.item]];
        if (index >= 0) {
            [self.selectedThumbImages removeObjectAtIndex:index];
            [self.selectedImagesURL removeObjectAtIndex:index];
        }else{
            if (self.selectedThumbImages.count < self.maxPhotos) {
                [self.selectedThumbImages addObject:self.thumbImages[indexPath.item]];
                [self.selectedImagesURL addObject:self.imagesURL[indexPath.item]];
            }else{
                //当最大照片个数大于1时提示，等于1时直接切换图片
                if (self.maxPhotos > 1) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:DDLocalMsg(@"SelectPhotos"),self.maxPhotos] delegate:nil cancelButtonTitle:DDLocalMsg(@"OK") otherButtonTitles:nil, nil];
                    [alert show];
                }else{
                    [self.selectedThumbImages removeLastObject];
                    [self.selectedThumbImages addObject:self.thumbImages[indexPath.item]];
                    
                    [self.selectedImagesURL removeLastObject];
                    [self.selectedImagesURL addObject:self.imagesURL[indexPath.item]];
                }
            }
        }
        [collectionView reloadData];
        [self.toolsView refresh:self.selectedThumbImages];
    }
}

#pragma mark - imagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]){
        UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        [picker dismissViewControllerAnimated:YES completion:^() {
            [self getAlbums];
        }];
    }
}

#pragma mark - UI

- (void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initNavagationItem];
    [self initCollectionView];
    [self initToolsView];
    [self initAlbumSelectView];
    [self addConstraints];
}

- (void)showUI{
    if (self.customNavigationBar.alpha == 0 &&
        self.collectionView.alpha == 0 &&
        self.toolsView.alpha == 0 &&
        self.albumSelectView.alpha == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.customNavigationBar.alpha = 1;
            self.collectionView.alpha = 1;
            self.toolsView.alpha = 1;
            self.albumSelectView.alpha = 1;
        }];
    }
}

- (void)initNavagationItem{
    self.customNavigationItem = [[UINavigationItem alloc]initWithTitle:DDLocalMsg(@"Album")];
    self.customNavigationBar = [[UINavigationBar alloc]initWithFrame:CGRectZero];
    [self.customNavigationBar setBarTintColor:DD_NAVAGATIONBAR_BG_COLOR];
    [self.customNavigationBar setTintColor:DD_NAVAGATIONBAR_TINT_COLOR];
    [self.customNavigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:DD_NAVAGATIONBAR_TITLE_COLOR}];
    [self.customNavigationBar setTranslucent:NO];
    
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"DDPhotoAlbum.bundle/Image/back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.customNavigationItem setLeftBarButtonItem:backItem];
    //相簿按钮
    UIBarButtonItem *albumItem = [[UIBarButtonItem alloc]initWithTitle:DDLocalMsg(@"Album") style:UIBarButtonItemStylePlain target:self action:@selector(albumItemClick:)];
    [self.customNavigationItem setRightBarButtonItem:albumItem];
    
    [self.customNavigationBar pushNavigationItem:self.customNavigationItem animated:NO];
    [self.view addSubview:self.customNavigationBar];
    
    self.customNavigationBar.alpha = 0;
}

- (void)initCollectionView{
    self.layout = [[DDPhotoAlbumLayout alloc]init];
    [self.layout setColumnMargin:DD_ITEM_COLUMN_MARGIN];
    [self.layout setRowMargin:DD_ITEM_ROW_MARGIN];
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft ||
        [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
        self.layout.columnsCount = DD_ITEM_COLUMN_COUNT_LANDSCAPE;
    }else{
        self.layout.columnsCount = DD_ITEM_COLUMN_COUNT;
    }
    [self.layout setItemInset:DD_ITEM_INSET];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self.collectionView setBackgroundColor:RGBA(255, 255, 255, 1)];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[DDPhotoAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.collectionView.alpha = 0;
}

- (void)initToolsView{
    self.toolsView = [[DDPhotoAlbumToolsView alloc]initWithFrame:CGRectZero maxCount:self.maxPhotos];
    __weak DDPhotoAlbumViewController *weakSelf = self;
    [self.toolsView setDidSelectedItem:^(NSUInteger indexItem) {
        [weakSelf.selectedThumbImages removeObjectAtIndex:indexItem];
        [weakSelf.selectedImagesURL removeObjectAtIndex:indexItem];
        [weakSelf.collectionView reloadData];
    }];
    [self.toolsView setDoneBtnClick:^{
        if (weakSelf.selectedThumbImages.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:DDLocalMsg(@"SelectPhoto"),weakSelf.maxPhotos] delegate:nil cancelButtonTitle:DDLocalMsg(@"OK") otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [weakSelf getOriginPhotos:weakSelf.selectedImagesURL completion:^(NSArray *photos) {
            if (weakSelf.didSelectedBlock) {
                weakSelf.didSelectedBlock(photos,weakSelf.selectedThumbImages,weakSelf.selectedImagesURL);
            }
            [weakSelf back];
        }];
    }];
    [self.view addSubview:self.toolsView];
    [self.toolsView refresh:self.selectedThumbImages];
    
    self.toolsView.alpha = 0;
}

- (void)initAlbumSelectView{
    self.albumSelectView = [[DDPhotoAlbumSelectView alloc]initWithFrame:CGRectZero];
    __weak DDPhotoAlbumViewController *weakSelf = self;
    [self.albumSelectView setDidSelectedAlbum:^(NSUInteger index) {
        weakSelf.selectedAlbumIndex = index;
        [weakSelf getALbumDetail:index];
        [weakSelf.view removeConstraint:weakSelf.selectViewTopConstraint];
        weakSelf.selectViewTopConstraint = [NSLayoutConstraint constraintWithItem:weakSelf.albumSelectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:weakSelf.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [weakSelf.view addConstraint:weakSelf.selectViewTopConstraint];
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            
        }];
    }];
    [self.albumSelectView setCancelSelectAlbum:^{
        [weakSelf.view removeConstraint:weakSelf.selectViewTopConstraint];
        weakSelf.selectViewTopConstraint = [NSLayoutConstraint constraintWithItem:weakSelf.albumSelectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:weakSelf.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [weakSelf.view addConstraint:weakSelf.selectViewTopConstraint];
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            
        }];
    }];
    [self.view insertSubview:self.albumSelectView belowSubview:self.toolsView];
    
    self.albumSelectView.alpha = 0;
}

- (void)addConstraints{
    
    _customNavigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _toolsView.translatesAutoresizingMaskIntoConstraints = NO;
    _albumSelectView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_customNavigationBar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_customNavigationBar)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_toolsView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolsView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_albumSelectView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_albumSelectView)]];
    
    id topLayoutGuide = self.topLayoutGuide;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[topLayoutGuide]-0-[_customNavigationBar(%f)]-0-[_collectionView]-0-[_toolsView(%f)]-0-|",DD_NAVAGATIONBAR_HEIGHT,DD_TOOLBAR_HEIGHT] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_customNavigationBar,_collectionView,_toolsView,topLayoutGuide)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_albumSelectView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:-DD_TOOLBAR_HEIGHT]];
    self.selectViewTopConstraint = [NSLayoutConstraint constraintWithItem:_albumSelectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:self.selectViewTopConstraint];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.layout.columnsCount = DD_ITEM_COLUMN_COUNT_LANDSCAPE;
    }else{
        self.layout.columnsCount = DD_ITEM_COLUMN_COUNT;
    }
}

- (void)back{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - check

/**
 *  是否允许访问相册
 *
 *  @return 是否允许访问相册
 */
- (BOOL)isPermissionAlbum{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == 1 || author == 2){
        return NO;
    }else{
        return YES;
    }
}

/**
 *  是否允许访问相机
 *
 *  @return 是否允许访问相机
 */
- (BOOL)isPermissionCamera{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == ALAuthorizationStatusAuthorized){
        return YES;
    }else{
        return NO;
    }
}

@end
