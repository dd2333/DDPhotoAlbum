//
//  DDPhotoAlbumSelectTableViewCell.m
//  DDPhotoAlbum
//
//  Created by dd2333 on 16/7/6.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import "DDPhotoAlbumSelectTableViewCell.h"

#define INSET 2.f

@implementation DDPhotoAlbumSelectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _albumImageView = [[UIImageView alloc]init];
        [self addSubview:_albumImageView];
        
        _infoLabel = [[UILabel alloc]init];
        [_infoLabel setFont:[UIFont systemFontOfSize:16]];
        [_infoLabel setTextColor:[UIColor blackColor]];
        [self addSubview:_infoLabel];
        
        _albumImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[_albumImageView]-[_infoLabel]-%f-|",INSET,INSET] options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_albumImageView,_infoLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[_albumImageView]-%f-|",INSET,INSET] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_albumImageView)]];
        [_albumImageView addConstraint:[NSLayoutConstraint constraintWithItem:_albumImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_albumImageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    }
    return self;
}

@end
