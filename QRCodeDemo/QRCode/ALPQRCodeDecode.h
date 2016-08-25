//
//  ALPQRCodeDecode.h
//  AllLivePlayer
//
//  Created by 胥佰淼 on 16/8/24.
//  Copyright © 2016年 hzky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ALPQRCodeDecodeDelegate <NSObject>

- (void)barcodeDetected:(NSString *)str;

@end

@interface ALPQRCodeDecode : NSObject

@property (nonatomic, weak) id delegate;

- (instancetype)initWithDelegate:(UIViewController<ALPQRCodeDecodeDelegate> *)viewController;

- (BOOL)startReading;
- (BOOL)stopReading;

@end
