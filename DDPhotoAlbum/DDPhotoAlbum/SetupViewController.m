//
//  SetupViewController.m
//  DDPhotoAlbum
//
//  Created by dd2333 on 16/7/8.
//  Copyright © 2016年 dd2333. All rights reserved.
//

#import "SetupViewController.h"
#import "ViewController.h"

@interface SetupViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *showCameraSwitch;
@property (weak, nonatomic) IBOutlet UILabel *photosLabel;
@property (weak, nonatomic) IBOutlet UISlider *photosSlider;
@end

@implementation SetupViewController{
    ViewController *_viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _viewController = [self.navigationController.viewControllers firstObject];
    
    self.photosLabel.text = [NSString stringWithFormat:@"Max Photos: %ld",_viewController.maxPhotos];
    self.showCameraSwitch.on = _viewController.isShowCamera;
    [self.photosSlider setValue:_viewController.maxPhotos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showCameraSwitchChanged:(UISwitch*)sender {
    _viewController.isShowCamera = sender.on;
}

- (IBAction)photoSliderChanged:(UISlider*)sender {
    NSUInteger count = (int)ceil(sender.value);
    self.photosLabel.text = [NSString stringWithFormat:@"Max Photos: %ld",count];
    _viewController.maxPhotos = count;
}
@end
