//
//  DDPhotoAlbumCollectionViewCell.m
//  DDPhotoAlbum
//
//  Created by dd2333 on 16/6/27.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import "DDPhotoAlbumCollectionViewCell.h"
#import "DDPhotoAlbum.h"

@interface SelectedView : UIView

@end

@implementation SelectedView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, CGRectInset(rect, 0, 0));
    CGContextSetFillColorWithColor(context, RGBA(255, 255, 255, 1).CGColor);
    CGContextFillPath(context);
    
    CGContextAddEllipseInRect(context, CGRectInset(rect, 1, 1));
    CGContextSetFillColorWithColor(context, DD_MAIN_COLOR.CGColor);
    CGContextFillPath(context);
    
    CGContextSetLineWidth(context, 2);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(context, RGBA(255, 255, 255, 1).CGColor);
    CGContextMoveToPoint(context, 10./44.*rect.size.width, 20./44.*rect.size.width);
    CGContextAddLineToPoint(context, 19./44.*rect.size.width, 29./44.*rect.size.width);
    CGContextAddLineToPoint(context, 33./44.*rect.size.width, 14./44.*rect.size.width);
    CGContextStrokePath(context);
}

@end

@interface DDPhotoAlbumCollectionViewCell ()

@property (nonatomic, strong) UIView *maskView;

@end

@implementation DDPhotoAlbumCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
        
        _maskView = [[UIView alloc]init];
        [_maskView setBackgroundColor:RGBA(255, 255, 255, 0.5)];
        [self addSubview:_maskView];
        
        SelectedView *selectedView = [[SelectedView alloc]initWithFrame:CGRectMake(frame.size.width/16*11, frame.size.width/16*11, frame.size.width/4, frame.size.width/4)];
        [_maskView addSubview:selectedView];
        [_maskView setHidden:YES];
        
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];

        _maskView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_maskView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_maskView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_maskView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_maskView)]];

        selectedView.translatesAutoresizingMaskIntoConstraints = NO;
        [_maskView addConstraint:[NSLayoutConstraint constraintWithItem:selectedView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_maskView attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0]];
        [_maskView addConstraint:[NSLayoutConstraint constraintWithItem:selectedView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_maskView attribute:NSLayoutAttributeHeight multiplier:0.25 constant:0]];
        [_maskView addConstraint:[NSLayoutConstraint constraintWithItem:selectedView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_maskView attribute:NSLayoutAttributeTrailing multiplier:0.7 constant:0]];
        [_maskView addConstraint:[NSLayoutConstraint constraintWithItem:selectedView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_maskView attribute:NSLayoutAttributeBottom multiplier:0.7 constant:0]];
    }
    return self;
}

- (void)setHighlightSelected:(BOOL)highlightSelected{
    if (highlightSelected) {
        [_maskView setHidden:NO];
    }else{
        [_maskView setHidden:YES];
    }
}

@end
