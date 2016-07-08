//
//  DDPhotoAlbumToolsView.m
//  DDPhotoAlbum
//
//  Created by dd2333 on 16/7/4.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import "DDPhotoAlbumToolsView.h"
#import "DDPhotoAlbumToolsCollectionViewCell.h"
#import "DDPhotoAlbum.h"

#define TOOLBAR_INFO_HEIGHT 40.f      //底部信息栏高度

@interface DDPhotoAlbumToolsView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UILabel *selectedCountLabel;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation DDPhotoAlbumToolsView{
    NSUInteger _lastCount;      //记录上次所选的图片个数
}

- (instancetype)initWithFrame:(CGRect)frame maxCount:(NSUInteger)maxCount{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        NSString *info;
        if (maxCount == 1) {
            info = DDLocalMsg(@"SelectPhoto");
        }else{
            info = [NSString stringWithFormat:DDLocalMsg(@"SelectPhotos"),maxCount];
        }
        
        UIFont *infoFont = [UIFont systemFontOfSize:DD_TOOLBAR_FONTSIZE];
        
        //提示label
        UILabel *infoLabel = [[UILabel alloc]init];
        [infoLabel setTextColor:[UIColor blackColor]];
        [infoLabel setText:info];
        [infoLabel setFont:infoFont];
        [self addSubview:infoLabel];
        
        //照片统计label
        _selectedCountLabel = [[UILabel alloc]init];
        _selectedCountLabel.textColor = [UIColor whiteColor];
        _selectedCountLabel.backgroundColor = DD_MAIN_COLOR;
        _selectedCountLabel.font = infoFont;
        _selectedCountLabel.clipsToBounds = YES;
        _selectedCountLabel.text = @"0";
        _selectedCountLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_selectedCountLabel];

        //确定btn
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitle:DDLocalMsg(@"Done") forState:UIControlStateNormal];
        [_doneBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        CGFloat r,g,b;
        [DD_MAIN_COLOR getRed:&r green:&g blue:&b alpha:nil];
        [_doneBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:r-0.2 green:g-0.2 blue:b-0.2 alpha:1] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        _doneBtn.titleLabel.font = infoFont;
        _doneBtn.clipsToBounds = YES;
        [_doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_doneBtn];
        
        //照片collectionView
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayout.minimumInteritemSpacing = 0;
        self.flowLayout.minimumLineSpacing = 0;
        self.flowLayout.sectionInset = UIEdgeInsetsMake(DD_TOOLBAR_ITEM_INSET, DD_TOOLBAR_ITEM_INSET, DD_TOOLBAR_ITEM_INSET, DD_TOOLBAR_ITEM_INSET);
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView registerClass:[DDPhotoAlbumToolsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_collectionView];
        
        //添加约束
        infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _selectedCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _doneBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-8-[infoLabel]-8-[_selectedCountLabel]-<=%f-[_doneBtn(80)]-8-|",SCREEN_WIDTH] options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(infoLabel,_selectedCountLabel,_doneBtn)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[_collectionView]-0-|"] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[infoLabel(%f)]-0-[_collectionView]-0-|",TOOLBAR_INFO_HEIGHT] options:0 metrics:nil views:NSDictionaryOfVariableBindings(infoLabel,_collectionView)]];
        [_selectedCountLabel addConstraint:[NSLayoutConstraint constraintWithItem:_selectedCountLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_selectedCountLabel attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_doneBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_selectedCountLabel attribute:NSLayoutAttributeHeight multiplier:1.5 constant:0]];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.flowLayout.itemSize = CGSizeMake(self.frame.size.height - TOOLBAR_INFO_HEIGHT - 2 * DD_TOOLBAR_ITEM_INSET, self.frame.size.height - TOOLBAR_INFO_HEIGHT - 2 * DD_TOOLBAR_ITEM_INSET);
    _selectedCountLabel.layer.cornerRadius = _selectedCountLabel.frame.size.width/2;
    _doneBtn.layer.cornerRadius = _doneBtn.frame.size.height/2;
}

- (void)doneBtnClick:(UIButton*)sender{
    if (self.doneBtnClick) {
        self.doneBtnClick();
    }
}

#pragma mark - public

- (void)refresh:(NSMutableArray*)images{
    BOOL isAnimated = images.count > _lastCount;
    self.images = images;
    _lastCount = images.count;
    [self.collectionView reloadData];
    if (isAnimated) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.images.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    if (images.count > 0) {
        [_doneBtn setBackgroundImage:[self imageWithColor:DD_MAIN_COLOR size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    }else{
        CGFloat r,g,b;
        [DD_MAIN_COLOR getRed:&r green:&g blue:&b alpha:nil];
        [_doneBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:r-0.2 green:g-0.2 blue:b-0.2 alpha:1] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    }
    self.selectedCountLabel.text = [NSString stringWithFormat:@"%ld",images.count];
}

#pragma mark - collectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DDPhotoAlbumToolsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = self.images[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectedItem) {
        self.didSelectedItem(indexPath.item);
    }
    [self refresh:self.images];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

#pragma mark - custom

- (UIImage*)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (CGSize)sizeFromText:(NSString*)text
              withFont:(UIFont*)font
                inSize:(CGSize)superSize{
    return [text boundingRectWithSize:superSize
                              options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:@{NSFontAttributeName: font}
                              context:nil].size;
}

@end
