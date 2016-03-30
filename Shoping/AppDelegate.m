//
//  AppDelegate.m
//  Shoping
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//
#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MangoSingleton.h"
#import "TabViewController.h"
#import "GuidePageViewController.h"

#define kYouMengAppKey @"56fa417fe0f55a6972001497"

@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate,CLLocationManagerDelegate, AMapSearchDelegate, UITabBarControllerDelegate>
{
    //创建一个定位的CLLocationManager对象
    CLLocationManager *_locationManger;
    //创建地理编码
    CLGeocoder *_geocoder;
    
}
@property (nonatomic, strong) UITabBarController *tabbarVC;
@end

@implementation AppDelegate
@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"] isEqualToString:@"firstLaunch"]){
        //如果归档标记存在，直接进入主页面
        self.tabbarVC =[TabViewController new];
        self.tabbarVC.tabBar.tintColor = kColor;
        self.window.rootViewController = self.tabbarVC;;
        //删除归档
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"firstLaunch"];
    }else{
        //归档标记不存在，归档标记后，进入引导页
        [[NSUserDefaults standardUserDefaults] setObject:@"firstLaunch" forKey:@"firstLaunch"];
        GuidePageViewController *guidePageVC = [[GuidePageViewController alloc] init];
        self.window.rootViewController = guidePageVC;
        self.window.backgroundColor = [UIColor whiteColor];
      
    }

    self.tabbarVC.tabBar.tintColor = kColor;
    
    //bmob
    [Bmob registerWithAppKey:@"413557b216c3e5c7ef5e11008d0c6b26"];
    //微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"894620014"];
    
    //微信
    [WXApi registerApp:@"wxb18bd78d096243ca"];
    
    //配置用户key
    [MAMapServices sharedServices].apiKey = @"4cbda1b412f083f404b754fb1efa0910";
    [AMapSearchServices sharedServices].apiKey = @"4cbda1b412f083f404b754fb1efa0910";

    //设置window的背景
    [self.window makeKeyAndVisible];

    //初始化地理编码对象
    _geocoder = [[CLGeocoder alloc] init];
    _locationManger = [[CLLocationManager alloc] init];
    //4.判断定位服务是否可用
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务未打开");
    }
    //是否授权定位
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManger requestWhenInUseAuthorization];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //设置代理
        _locationManger.delegate = self;
        //设置定位精度
        _locationManger.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //定位频率
        CLLocationDistance distance = 10.0;
        _locationManger.distanceFilter = distance;
        //启动定位
        [_locationManger startUpdatingLocation];
        
    }
    
    return YES;
}


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([WeiboSDK isCanShareInWeiboAPP]) {
         return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return [WXApi handleOpenURL:url delegate:self];
   
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([WeiboSDK isCanShareInWeiboAPP]) {
        return [WeiboSDK handleOpenURL:url delegate:self];

    }
    return [WXApi handleOpenURL:url delegate:self];
    
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
}

-(void)onReq:(BaseReq *)req{
    
}
-(void)onResp:(BaseResp *)resp{
    
}


#pragma mark -------------------------- 定位服务协议方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //从数组中取出一个位置
    CLLocation *location = [locations firstObject];
    //从location中取出坐标的精度维度
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"latitude"];
    [user setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"longitude"];
      NSLog(@"经度：%f 纬度：%f 海拔：%f 航向：%f 行走速度：%f ",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    MangoSingleton *mango = [MangoSingleton sharInstance];
    mango.latValue = coordinate.latitude;
    mango.lngValue = coordinate.longitude;
    //实现反地理编码
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        //保存数据
        [[NSUserDefaults standardUserDefaults] setValue:placemark.addressDictionary[@"city"] forKey:@"city"];
        [user synchronize];
    }];
    //如果不需要使用定位服务，及时关闭
    [_locationManger stopUpdatingLocation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
