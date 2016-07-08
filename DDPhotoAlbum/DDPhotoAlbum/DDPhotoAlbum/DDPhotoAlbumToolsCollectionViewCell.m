//
//  DDPhotoAlbumToolsCollectionViewCell.m
//  DDPhotoAlbum
//
//  Created dd2333 on 16/7/5.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import "DDPhotoAlbumToolsCollectionViewCell.h"
#import "DDPhotoAlbum.h"

@implementation DDPhotoAlbumToolsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //图片
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_imageView];
        
        //关闭btn
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"DDPhotoAlbum.bundle/Image/close.png"] forState:UIControlStateNormal];
        [_closeBtn setBackgroundColor:[UIColor whiteColor]];
        _closeBtn.layer.borderWidth = 0.5;
        _closeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _closeBtn.clipsToBounds = YES;
        [_closeBtn setUserInteractionEnabled:NO];
        [self addSubview:_closeBtn];
        
        //添加约束
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _closeBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[_imageView]-%f-|",DD_TOOLBAR_ITEM_INSET,DD_TOOLBAR_ITEM_INSET] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[_imageView]-%f-|",DD_TOOLBAR_ITEM_INSET,DD_TOOLBAR_ITEM_INSET] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_closeBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.3 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_closeBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.3 constant:0]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[_closeBtn]"] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_closeBtn)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[_closeBtn]"] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_closeBtn)]];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _closeBtn.layer.cornerRadius = _closeBtn.frame.size.width/2;
}

@end
