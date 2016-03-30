//
//  ViewController.m
//  DCQRcode
//
//  Created by point on 16/3/29.
//  Copyright © 2016年 tshiny. All rights reserved.
//

#import "ViewController.h"
#import "UIView+YL.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, weak) AVCaptureSession *session;
@property (nonatomic, weak) AVCaptureVideoPreviewLayer *layer;
@property (nonatomic, weak) AVCaptureMetadataOutput *pppp;


@property (nonatomic, assign) BOOL isLight;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isLight = NO;
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:contentView];
     contentView.backgroundColor = [UIColor redColor];
    contentView.clipsToBounds = YES;
    
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, 100, 10)];
    [self.view addSubview:lineView];
    lineView.backgroundColor = [UIColor redColor];
    lineView.clipsToBounds = YES;
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue=[NSNumber numberWithFloat:10];
    animation.toValue=[NSNumber numberWithFloat:100];
    animation.autoreverses=YES;
    animation.duration=1;
    animation.repeatCount=FLT_MAX;
    animation.removedOnCompletion=NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode=kCAFillModeForwards;
    [lineView.layer addAnimation:animation forKey:@"transform.translation.y"];

    
    
    UILabel *label = [[UILabel alloc]init];
    label.x = 20;
    label.y = 500;
    label.text =@"开始剥啄";
    [label sizeToFit];
    [self.view addSubview:label];
    [label addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        // 1.创建捕捉会话
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        self.session = session;
        
        // 2.添加输入设备(数据从摄像头输入)
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        //[session addInput:input];
        
        if ([session canAddInput: input])
        {
            [session addInput: input];
        }
        
        // 3.添加输出数据(示例对象-->类对象-->元类对象-->根元类对象)
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        _pppp = output;
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [session addOutput:output];
        
        
        // 3.1.设置输入元数据的类型(类型是二维码数据)
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        
        // 4.添加扫描图层
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        layer.frame = CGRectMake(0, 0, 100, 100);
        
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [contentView.layer addSublayer:layer];
        self.layer = layer;
        
        // 5.开始扫描
        [session startRunning];
        
        
        
        UILabel *labelLight = [[UILabel alloc]init];
        labelLight.x = 40;
        labelLight.y = 450;
        labelLight.text =@"开始闪光灯";
        [labelLight sizeToFit];
        [self.view addSubview:labelLight];
        [labelLight addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            
            if (device.torchMode == AVCaptureTorchModeOff)
            {
                
                [session beginConfiguration];
                [device lockForConfiguration:nil];
                [device setTorchMode:AVCaptureTorchModeOn];
                [device unlockForConfiguration];
                [session commitConfiguration];
            }else{
                [session beginConfiguration];
                [device lockForConfiguration:nil];
                [device setTorchMode:AVCaptureTorchModeOff];
                [device unlockForConfiguration];
                [session commitConfiguration];
            
            }

            
        }];
        
        
//        UISlider * slider= [[UISlider alloc]init];
//        slider.x = 100;
//        slider.y = 450;
//        slider.width = 100;
//        slider.height = 5;
//        [self.view addSubview:slider];
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(100, 450, 200, 20)];
        slider.minimumValue = 0.0;
        slider.maximumValue = 1;
        slider.value = 0.0;
        [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
        slider.transform =CGAffineTransformMakeRotation(M_PI/2);
        
        [self.view addSubview:slider];
        
        
        
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)updateValue:(UISlider *)slider {
       CGFloat maxScaleAndCropFactor = [[_pppp connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
    
    float f = slider.value;
//    CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
//    
           NSLog(@"=============%f",maxScaleAndCropFactor);
//            if (self.effectiveScale > maxScaleAndCropFactor)
//                self.effectiveScale = maxScaleAndCropFactor;
    
            [CATransaction begin];
            [CATransaction setAnimationDuration:.025];
            [self.layer setAffineTransform:CGAffineTransformMakeScale(f+1, f+1)];
            [CATransaction commit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
