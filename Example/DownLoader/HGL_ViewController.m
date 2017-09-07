//
//  HGL_ViewController.m
//  DownLoader
//
//  Created by heiguoliangle on 09/06/2017.
//  Copyright (c) 2017 heiguoliangle. All rights reserved.
//

#import "HGL_ViewController.h"
#import "HGL_DownLoader.h"
@interface HGL_ViewController ()

@end

@implementation HGL_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)start:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://hdtkapk.houdask.com/houda_v0.9.2_2017-09-04_website.apk"];
    
    NSURL *url2 = [NSURL URLWithString:@"http://free2.macx.cn:8281/tools/photo/Sip44.dmg"];
    
    [[HGL_DownLoader shareInance]downLoadWithURL:url downLoadInfo:^(long long totalSize) {
        
    } progress:^(float progress) {
        NSLog(@"下载进度 %f",progress);
    } successs:^(NSString *filePath) {
        
    } failed:^{
        
    }];
}
- (IBAction)stop:(id)sender {
    
    [[HGL_DownLoader shareInance]pause];
    
}
- (IBAction)cancel:(id)sender {
    
    [[HGL_DownLoader shareInance]cancel];
}
- (IBAction)delegate:(id)sender {
    
    [[HGL_DownLoader shareInance]cancelAndClear];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
