//
//  ViewController.m
//  QRCodeDemo
//
//  Created by 胥佰淼 on 16/8/25.
//  Copyright © 2016年 胥佰淼. All rights reserved.
//

#import "ViewController.h"
#import "ALPQRCodeDecode.h"

@interface ViewController () <ALPQRCodeDecodeDelegate>

@property (nonatomic, strong) ALPQRCodeDecode *barCode;

@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bgImageView.image = [UIImage imageNamed:@"s_qrcode_bg"];
    
    _barCode = [[ALPQRCodeDecode alloc] initWithDelegate:self];
    [_barCode startReading];
    [self.view addSubview:_bgImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ALPQRCodeDecodeDelegate method

- (void)barcodeDetected:(NSString *)str {
    NSLog(@"codeL:%@", str);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"扫描结果" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_barCode startReading];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_barCode startReading];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:^{
        //        [_barCode stopReading];
    }];
    
    [_barCode stopReading];
}

@end
