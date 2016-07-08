//
//  ViewController.m
//  DDPhotoAlbum
//
//  Created by dd2333 on 16/6/27.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import "ViewController.h"
#import "DDPhotoAlbum.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.maxPhotos = 9;
    self.isShowCamera = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Present DDPhotoAlbum";
            break;
        case 1:
            cell.textLabel.text = @"Push DDPhotoAlbum";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DDPhotoAlbumViewController *photoAlbumViewController = [[DDPhotoAlbumViewController alloc]init];
    photoAlbumViewController.maxPhotos = self.maxPhotos;
    photoAlbumViewController.isShowCamera = self.isShowCamera;
    [photoAlbumViewController setDidSelectedBlock:^(NSArray *images, NSArray *thumbnailImages) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Total: %ld",images.count] delegate:nil cancelButtonTitle:DDLocalMsg(@"OK") otherButtonTitles:nil, nil];
        [alert show];
    }];

    switch (indexPath.row) {
        case 0:
            {
                [self presentViewController:photoAlbumViewController animated:YES completion:nil];
            }
            break;
        case 1:
            {
                [self.navigationController pushViewController:photoAlbumViewController animated:YES];
            }
            break;
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}



@end
