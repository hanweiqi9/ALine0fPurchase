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
#import <AMapSearchKit/AMapSearchKit.h>
#import "MangoSingleton.h"



#define kAppKey @"e2baf0ac4039a02b714d7b228a086ff3"
#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface MapViewController ()<MAMapViewDelegate,AMapSearchDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    AMapSearchAPI *_searchRoad;
    UILongPressGestureRecognizer *_longTapGesture;
    MAPointAnnotation *_distanAnnotation;  //目的地坐标
    MAPointAnnotation *_anotitaon;  //点击tableView得到的大头针
}

@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) NSString *titles;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIButton *rotePlayBtn;  //路径规划
@property (nonatomic, strong) MAPointAnnotation *pointAnnotation;  //起点坐标
@property (nonatomic, strong) MangoSingleton *mango;
@property (nonatomic, strong) NSArray *pathPolylines;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) MAPolylineView *polylineView;
@property (nonatomic, strong) MAPointAnnotation *endPointAnnotation;
@property (nonatomic, strong) MAPointAnnotation *currentPointAnotion;
@property (nonatomic, strong) NSArray *pois;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //自定义导航栏标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 4, 0, kWidth / 4, 44)];
    label.text =  @"地址详情";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;    [self.view addSubview:self.tableView];
    _pois = [[NSArray alloc] init];
    //配置用户key
    [MAMapServices sharedServices].apiKey = kAppKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 44, kWidth, kHeight - 190)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = 1;
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 22);
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 22);
    
    [self.view addSubview:_mapView];
    //开始定位
    _mapView.showsUserLocation = YES;
    
    [AMapSearchServices sharedServices].apiKey = kAppKey;
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    //起点坐标
    self.pointAnnotation = [[MAPointAnnotation alloc] init];
    self.pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.lat, self.lng);

    [_mapView addAnnotation:self.pointAnnotation];


    //添加长按手势
    _longTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAction:)];
    _longTapGesture.delegate = self;
    [_mapView addGestureRecognizer:_longTapGesture];
    
    //初始化按钮
    [self initButton];
    //地理编码
    [self reGeoAction];
    
}

- (void)initButton {
    //自定义导航栏左侧返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"titlebarback"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton addTarget:self action:@selector(backLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBtn;

    [self.view addSubview:self.rotePlayBtn];
    //初始化搜索按钮
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn.frame = CGRectMake(kWidth / 2 + kWidth / 4, 6, 90, 30);
    [self.searchBtn setTitle:@"周边" forState:UIControlStateNormal];
    self.searchBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self.searchBtn setTitleColor:[UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.searchBtn setImage:[UIImage imageNamed:@"search_icon1"] forState:UIControlStateNormal];
    self.searchBtn.layer.cornerRadius = 30 / 2;
    self.searchBtn.clipsToBounds = YES;
    [self.searchBtn addTarget:self action:@selector(searchAroundAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.searchBtn];
}

#pragma mark ---------------------- tableView协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        
    }
    AMapPOI *poi = _pois[indexPath.row];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;

    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pois.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //为点击的poi点添加标注
    AMapPOI *poi = _pois[indexPath.row];
    _anotitaon = [[MAPointAnnotation alloc] init];
    _anotitaon.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    _anotitaon.title = poi.name;
    _anotitaon.subtitle = poi.address;
    [_mapView addAnnotation:_anotitaon];
    
    
}

#pragma mark ---------------------------- 协议方法
//当位置更新时，会进位置回调函数
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.lat, self.lng);

    _mapView.centerCoordinate = coordinate;
    if(updatingLocation)
    {
        //取出当前位置的坐标
//        NSLog(@"11111latitude : %f,1111longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
    }
    
}

//实现POI搜索对应的回调函数
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count > 0) {
        _pois = response.pois;
        [_tableView reloadData];
        
        //清空标注
        [_mapView removeAnnotations:_annotations];
        [_annotations removeAllObjects];
    }
    

}


//大头针标注
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if (annotation == _distanAnnotation){
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[_mapView viewForAnnotation:annotation];
        _distanAnnotation.title = @"目的地";
        annotationView.canShowCallout = YES;
           
        return annotationView;
    }
    if (annotation == _anotitaon) {
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[_mapView viewForAnnotation:annotation];
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    
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

//添加大头针
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
        view.canShowCallout = NO;
    } else if (view.annotation == _distanAnnotation) {
        view.canShowCallout = YES;
    } else if (view.annotation == _anotitaon) {
        view.canShowCallout = YES;
    }

}

-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        [self reGeoAction];
    }
}

//路线规划完成
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response{
    if (response.route == nil) {
        return;
    }
    
    [_mapView removeOverlays:_pathPolylines];
    _pathPolylines = nil;
    _pathPolylines = [self polylinesForPath:response.route.paths[0]];
    //让地图显示两个大头针
    if (_anotitaon == nil) {
        [_mapView showAnnotations:@[_distanAnnotation, _mapView.userLocation] animated:YES];

    } else if (_distanAnnotation == nil){
         [_mapView showAnnotations:@[_anotitaon, _mapView.userLocation] animated:YES];
    }
    [_mapView addOverlays:_pathPolylines];
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 22);
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 22);
    [_mapView setZoomLevel:11.5 animated:YES];
    
}

- (NSArray *)polylinesForPath:(AMapPath *)path
{
    if (path == nil || path.steps.count == 0)
    {
        return nil;
    }
    
    NSMutableArray *polylines = [NSMutableArray new];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        
        NSUInteger count = 0;
        CLLocationCoordinate2D *coordinates = [self coordinatesForString:step.polyline
                                                         coordinateCount:&count
                                                              parseToken:@";"];
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        [polylines addObject:polyline];
        
        free(coordinates), coordinates = NULL;
    }];
    
    return polylines;
}

//初始化路径
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        
        MAPolylineRenderer *polylineView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 5;
        polylineView.strokeColor = kColor;
        
        return polylineView;
    }
    return nil;
}



#pragma mark ---------------------- 按钮点击方法
//搜索按钮点击方法
- (void)searchAroundAction:(UIButton *)btn {
    //周边搜索
    [AMapSearchServices sharedServices].apiKey = @"e2baf0ac4039a02b714d7b228a086ff3";
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    //经纬度
    request.location = [AMapGeoPoint locationWithLatitude:self.lat longitude:self.lng];
    request.types = @"餐饮服务|购物服务|生活服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体";
    request.sortrule = 0;
    request.requireExtension = YES;
    //输入提示
    AMapInputTipsSearchRequest *tipRequest = [[AMapInputTipsSearchRequest alloc] init];
    [_search AMapInputTipsSearch:tipRequest];
    //发起周边搜索
    [_search AMapPOIAroundSearch:request];
    
    
}

//点击 绘制路线 按钮方法
- (void)rotePlayBtnAndNavBtnAction:(UIButton *)btn {
    if (_distanAnnotation) {
        if (_distanAnnotation == nil || _search == nil) {
            NSLog(@"规划路线失败");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"长按屏幕选择目的地" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        } else {
            AMapWalkingRouteSearchRequest  *request = [[AMapWalkingRouteSearchRequest alloc] init];
            request.origin = [AMapGeoPoint locationWithLatitude:self.lat longitude:self.lng];
            request.destination = [AMapGeoPoint locationWithLatitude:_distanAnnotation.coordinate.latitude longitude:_distanAnnotation.coordinate.longitude];
            [_search AMapWalkingRouteSearch:request];
        }

        
    } else if (_anotitaon){
        if (_anotitaon == nil || _search == nil) {
        NSLog(@"规划路线失败");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择您要去的地方" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    } else {
        AMapWalkingRouteSearchRequest  *request = [[AMapWalkingRouteSearchRequest alloc] init];
        request.origin = [AMapGeoPoint locationWithLatitude:self.lat longitude:self.lng];
        request.destination = [AMapGeoPoint locationWithLatitude:_anotitaon.coordinate.latitude longitude:_anotitaon.coordinate.longitude];
        [_search AMapWalkingRouteSearch:request];

    }
  }
    
}

#pragma mark --------- 字符串解析

- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil)
    {
        return NULL;
    }
    
    if (token == nil)
    {
        token = @",";
    }
    
    NSString *str = @"";
    if (![token isEqualToString:@","])
    {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    
    else
    {
        str = [NSString stringWithString:string];
    }
    
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL)
    {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++)
    {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    return coordinates;
}

//地理编码
- (void)reGeoAction{
    if (_anotitaon) {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:_anotitaon.coordinate.latitude longitude:_anotitaon.coordinate.longitude];
        [_search AMapReGoecodeSearch:request];
    }
}


//解析地理编码
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    
    //城市地址
    self.titles = response.regeocode.addressComponent.city;
    if (self.titles.length == 0) {
        //详细地址
        self.titles = response.regeocode.addressComponent.province;
    }
    
    _mapView.userLocation.title = self.titles;
    _mapView.userLocation.subtitle = response.regeocode.formattedAddress;
    NSLog(@"%@", _mapView.userLocation);
    
}

#pragma mark ------------- 手指协议
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

//长按手势点击方法
- (void)longTapAction:(UILongPressGestureRecognizer *)tap {
    
        CLLocationCoordinate2D corrnitate = [_mapView convertPoint:[tap locationInView:_mapView] toCoordinateFromView:_mapView];
        //添加标注
        if (_distanAnnotation != nil) {
            [_mapView removeAnnotation:_distanAnnotation];
            _distanAnnotation = nil;
        }
        _distanAnnotation = [[MAPointAnnotation alloc] init];
        _distanAnnotation.coordinate = corrnitate;
        [_mapView addAnnotation:_distanAnnotation];
        
    
}

#pragma mark ----------------- 懒加载

//路径规划按钮 懒加载
-(UIButton *)rotePlayBtn {
    if (_rotePlayBtn == nil) {
        self.rotePlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rotePlayBtn.frame = CGRectMake(10, kHeight - 145, kWidth - 20, 25);
        self.rotePlayBtn.layer.cornerRadius = 25 / 2;
        self.rotePlayBtn.clipsToBounds = YES;
        [self.rotePlayBtn setTitle:@"路径规划" forState:UIControlStateNormal];
        self.rotePlayBtn.tag = 1;
        self.rotePlayBtn.backgroundColor = kColor;
        [self.rotePlayBtn addTarget:self action:@selector(rotePlayBtnAndNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotePlayBtn;
}

//初始化大头针数组
- (NSMutableArray *)annotations{
    if (_annotations == nil) {
        self.annotations = [NSMutableArray array];
    }
    return _annotations;
}

- (NSArray *)pathPolylines{
    if (_pathPolylines == nil) {
        _pathPolylines = [NSArray new];
    }
    return _pathPolylines;
}

-(UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeight - 200, kWidth, 260) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    return _tableView;
}
//导航栏返回按钮
- (void)backLeftAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
    self.searchBtn.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
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
