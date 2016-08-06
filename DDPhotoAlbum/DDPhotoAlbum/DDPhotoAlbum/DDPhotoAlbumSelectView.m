//
//  DDPhotoAlbumSelectView.m
//  DDPhotoAlbum
//
//  Created by dd2333 on 16/7/6.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import "DDPhotoAlbumSelectView.h"
#import "DDPhotoAlbumSelectTableViewCell.h"
#import "DDPhotoAlbum.h"
#import "DDPhotoAlbumModel.h"

@interface DDPhotoAlbumSelectView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UINavigationItem *customNavigationItem;
@property (nonatomic, strong) UINavigationBar *customNavigationBar;

@end

@implementation DDPhotoAlbumSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _customNavigationItem = [[UINavigationItem alloc]initWithTitle:DDLocalMsg(@"Album")];
        _customNavigationBar = [[UINavigationBar alloc]initWithFrame:CGRectZero];
        [_customNavigationBar setBarTintColor:DD_NAVAGATIONBAR_BG_COLOR];
        [_customNavigationBar setTintColor:DD_NAVAGATIONBAR_TINT_COLOR];
        [_customNavigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:DD_NAVAGATIONBAR_TITLE_COLOR}];
        [_customNavigationBar setTranslucent:NO];
        
        //取消按钮
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:DDLocalMsg(@"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClick:)];
        [_customNavigationItem setLeftBarButtonItem:cancelItem];
        [_customNavigationBar pushNavigationItem:_customNavigationItem animated:NO];
        [self addSubview:_customNavigationBar];
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DDPhotoAlbumSelectTableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.tableView];
        
        _customNavigationBar.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_customNavigationBar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_customNavigationBar)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[_customNavigationBar(%f)]-0-[_tableView]-0-|",DD_NAVAGATIONBAR_HEIGHT] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_customNavigationBar,_tableView)]];
    }
    return self;
}

- (void)cancelItemClick:(id)sender{
    if (self.cancelSelectAlbum) {
        self.cancelSelectAlbum();
    }
}

#pragma mark - tableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDPhotoAlbumSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    DDPhotoAlbumModel *m = self.albumsInfo[indexPath.row];
    cell.albumImageView.image = m.posterImage;
    cell.infoLabel.text = [NSString stringWithFormat:@"%@ (%ld)",m.name,(long)m.count];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectedAlbum) {
        self.didSelectedAlbum(indexPath.row);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albumsInfo.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}


@end
