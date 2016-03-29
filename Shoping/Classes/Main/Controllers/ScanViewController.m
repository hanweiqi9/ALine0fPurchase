//
//  ScanViewController.m
//  二维码扫描
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "ScanViewController.h"
#import "UIViewController+Common.h"
#import <AVFoundation/AVFoundation.h>
#import "HtmlViewController.h"
@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewPreview;

@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;


//-(BOOL)startReading;
-(void)stopReading;

//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation ScanViewController

//- (void)viewDidAppear:(BOOL)animated{
//    [_captureSession startRunning];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"titlebarback"];
    _captureSession = nil;
    _isReading = NO;
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.layer.frame];
    
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    _viewPreview.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.6];
    //10.1.扫描框
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(kWidth/6.,kHeight/6,kWidth -kWidth/6* 2+10,kHeight / 2)];
    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
    _boxView.layer.borderWidth = 1.0f;
    
    [_viewPreview addSubview:_boxView];
    
    //10.2.扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 1);
    _scanLayer.backgroundColor = [UIColor redColor].CGColor;
    
    [_boxView.layer addSublayer:_scanLayer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    
    [timer fire];
    [_captureSession startRunning];
}
-(void)stopReading{
//    [_captureSession stopRunning];
    _captureSession = nil;
//    [_scanLayer removeFromSuperlayer];
//    [_videoPreviewLayer removeFromSuperlayer];
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString *sting =[metadataObj stringValue];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"扫描结果" message:sting preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                HtmlViewController *htmlVc = [[HtmlViewController alloc] init];
                htmlVc.urlString = [metadataObj stringValue];
                htmlVc.type = @"1";
                htmlVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:htmlVc animated:YES];
            } ];
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:nil];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            _isReading = NO;
        }
    }
//    else{
//        _isReading = YES;
//        [_captureSession startRunning];
//    }
}
- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        frame.origin.y += 5;
        
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
