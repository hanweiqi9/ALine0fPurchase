//
//  AppDelegate.m
//  Shoping
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//
#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#import "AppDelegate.h"
#import "ViewController.h"
#import "NearbyViewController.h"
#import "CenterViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"
#import <BmobSDK/Bmob.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAMapKit.h>
#import "LoginViewController.h"



@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate,CLLocationManagerDelegate,UITabBarControllerDelegate>
{
    //创建一个定位的CLLocationManager对象
    CLLocationManager *_locationManger;
    //创建地理编码
    CLGeocoder *_geocoder;
    
}
@property(nonatomic,strong)UINavigationController *MineNav;
@property(nonatomic,strong)UINavigationController *MainNav;
@property(nonatomic,strong)UINavigationController *nearNav;
@property(nonatomic,strong)UINavigationController *globalNav;
@property(nonatomic,strong)UINavigationController *discoverNav;


@end



@implementation AppDelegate
@synthesize wbtoken;
@synthesize wbCurrentUserID;
@synthesize wbRefreshToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //状态栏颜色
//    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];

    
    
    //bmob
    [Bmob registerWithAppKey:@"413557b216c3e5c7ef5e11008d0c6b26"];
    //微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"894620014"];
    
    //微信
    [WXApi registerApp:@"wxb18bd78d096243ca"];
    
    //配置用户key
    [MAMapServices sharedServices].apiKey = @"4cbda1b412f083f404b754fb1efa0910";
    
    self.tablebarVC = [[UITabBarController alloc] init];
    self.tablebarVC.delegate = self;
    //首页
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.MainNav = mainStory.instantiateInitialViewController;
    //设置图片
    self.MainNav.tabBarItem.image = [UIImage imageNamed:@"tab_home_normal"];
    self.MainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -2, 0);
    self.MainNav.tabBarItem.title = @"首页";
    //设置选中图片
    UIImage *mainImage = [UIImage imageNamed:@"tab_home_selected"];
    self.MainNav.tabBarItem.selectedImage = [mainImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //附近
    UIStoryboard *nearbyStory = [UIStoryboard storyboardWithName:@"Nearby" bundle:nil];
    self.nearNav = nearbyStory.instantiateInitialViewController;
    self.nearNav.tabBarItem.title = @"附近";
    //设置图片
    self.nearNav.tabBarItem.image = [UIImage imageNamed:@"tab"];
    self.nearNav.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -2, 0);
    //设置选中图片
    UIImage *nearImage = [UIImage imageNamed:@"tabselect"];
    self.nearNav.tabBarItem.selectedImage = [nearImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //全球逛
    UIStoryboard *globalStory = [UIStoryboard storyboardWithName:@"GlobalShop" bundle:nil];
    self.globalNav = globalStory.instantiateInitialViewController;
    //设置图片
    self.globalNav.tabBarItem.image = [UIImage imageNamed:@"tab_mall_normal"];
    self.globalNav.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -2, 0);
    self.globalNav.tabBarItem.title = @"全球购";
    //设置选中图片
    UIImage *globalImage = [UIImage imageNamed:@"tab_mall_selected"];
    self.globalNav.tabBarItem.selectedImage = [globalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //发现
    UIStoryboard *discoverStory = [UIStoryboard storyboardWithName:@"Discover" bundle:nil];
    self.discoverNav = discoverStory.instantiateInitialViewController;
    self.discoverNav.tabBarItem.title = @"发现";
    //设置图片
    self.discoverNav.tabBarItem.image = [UIImage imageNamed:@"tab_discover_normal"];
    self.discoverNav.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -2, 0);
    //设置选中图片
    UIImage *discoverImage = [UIImage imageNamed:@"tab_discover_selected"];
    self.discoverNav.tabBarItem.selectedImage = [discoverImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //我的
    UIStoryboard *mineStory = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    self.MineNav = mineStory.instantiateInitialViewController;
    //设置图片
    self.MineNav.tabBarItem.image = [UIImage imageNamed:@"tab_person_normal"];
    self.MineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -2, 0);
    self.MineNav.tabBarItem.title = @"我的";
    //设置选中图片
    UIImage *mineImage = [UIImage imageNamed:@"tab_person_selected"];
    self.MineNav.tabBarItem.selectedImage = [mineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //添加到tabBarVC上
    self.tablebarVC.viewControllers = @[self.MainNav, self.nearNav, self.globalNav, self.discoverNav, self.MineNav];
    self.tablebarVC.tabBar.tintColor = kColor;
    self.window.rootViewController = self.tablebarVC;
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


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController == self.tablebarVC.viewControllers[4]){
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *name = [userDefault objectForKey:@"name"];
        NSData *data = [userDefault objectForKey:@"headImage"];
        UIImage *headIma = [UIImage imageWithData:data];
        NSLog(@"%@",headIma);
        if (name !=nil) {
            LoginViewController *login = [[LoginViewController alloc] init];
            login.userStr = name;
            login.image1 = headIma;
            [((UINavigationController *)tabBarController.selectedViewController) pushViewController:login animated:nil];
          
              return NO;
        }else{
            return YES;
            
        }
    }
    else
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
