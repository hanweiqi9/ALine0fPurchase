//
//  MapViewController.m
//  Shoping
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"
#import "CustomAnnotationView.h"
#import "ProgressHUD.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface MapViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
}
@property (nonatomic, strong) UIView *barView;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //自定义导航栏左侧返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"titlebarback"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton addTarget:self action:@selector(backLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBtn;

    
    
}


//当位置更新时，会进位置回调函数
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.lat, self.lng);
    _mapView.centerCoordinate = coordinate;

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //配置用户key
    [MAMapServices sharedServices].apiKey = @"4cbda1b412f083f404b754fb1efa0910";
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 30, kWidth, kHeight)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    //开始定位
    _mapView.showsUserLocation = YES;
    
    _mapView.userTrackingMode = MAUserTrackingModeNone;
    [_mapView setZoomLevel:16.1 animated:YES];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.lat, self.lng);
    [_mapView addAnnotation:pointAnnotation];
    
    
}



//大头针标注
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointResueIdentifier = @"pointIdentifer";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:pointResueIdentifier];
        if (annotationView == nil) {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointResueIdentifier]
            ;

        }
       //设置气泡可以弹出
        annotationView.canShowCallout = NO;
        //设置标注动画显示
        annotationView.animatesDrop = YES;
        //设置标注可以拖到
        annotationView.draggable = YES;
        //大头针颜色
        annotationView.pinColor = MAPinAnnotationColorGreen;
        //设置中心点偏移
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    return nil;
}


-(void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MAAnnotationView *view = views[0];
    //放到该方法中用以保证userLocation的annotationView已经添加到地图上
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        //经度圈填充颜色
        pre.fillColor = [UIColor greenColor];
        //经度圈边缘颜色
        pre.strokeColor = [UIColor purpleColor];
        pre.lineWidth = 3;
        [_mapView updateUserLocationRepresentation:pre];
        view.calloutOffset = CGPointMake(0, 0);
    }

}


- (void)backLeftAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
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
