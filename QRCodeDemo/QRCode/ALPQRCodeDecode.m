//
//  ALPQRCodeDecode.m
//  AllLivePlayer
//
//  Created by 胥佰淼 on 16/8/24.
//  Copyright © 2016年 hzky. All rights reserved.
//

#import "ALPQRCodeDecode.h"

@interface ALPQRCodeDecode ()  <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;


@end

@implementation ALPQRCodeDecode

- (instancetype)initWithDelegate:(UIViewController<ALPQRCodeDecodeDelegate> *)viewController {
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        return nil;
    }
    
    self = [super init];
    self.delegate = viewController;
    if (self) {
        NSError *error;
        AVCaptureDevice * videoCaptureDevide = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        //输入信号随想
        AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevide error:&error];
        if (!videoInput) {
            NSLog(@"%@", [error localizedDescription]);
            
        }
        _session = [[AVCaptureSession alloc] init];
        [_session addInput:videoInput];
        
        //输出视频流对象
        AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        
        //        dispatch_queue_t dispatchQueue;
        //        dispatchQueue = dispatch_queue_create("myQueue", NULL);
        // 通过串行队列，将捕获到的数据发送给相应的代理
        //要在viewcontroller里面实现代理方法:
        //- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        [_session addOutput:captureMetadataOutput];
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeQRCode, nil]];
        
        //显示拍摄到的画面
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
        _previewLayer.frame = [UIScreen mainScreen].bounds;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [viewController.view.layer addSublayer:_previewLayer];
    }
    
    return self;
}

- (BOOL)startReading {
    [_session startRunning];
    return YES;
    
}

- (BOOL)stopReading {
    [_session stopRunning];
    return NO;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = metadataObjects.firstObject;
        NSString *string = metadataObj.stringValue;
        if ([self.delegate respondsToSelector:@selector(barcodeDetected:)]) {
            [self.delegate barcodeDetected:string];
        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}


@end
