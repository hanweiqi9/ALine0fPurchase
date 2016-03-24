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



@interface AppDelegate ()<WeiboSDKDelegate,WXApiDelegate>

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
    
    self.tablebarVC = [[UITabBarController alloc] init];
    //首页
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *MainNav = mainStory.instantiateInitialViewController;
    //设置图片
    MainNav.tabBarItem.image = [UIImage imageNamed:@"tab_home_normal"];
    MainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -2, 0);
    MainNav.tabBarItem.title = @"首页";
    //设置选中图片
    UIImage *mainImage = [UIImage imageNamed:@"tab_home_selected"];
    MainNav.tabBarItem.selectedImage = [mainImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //附近
    UIStoryboard *nearbyStory = [UIStoryboard storyboardWithName:@"Nearby" bundle:nil];
    UINavigationController *nearNav = nearbyStory.instantiateInitialViewController;
    nearNav.tabBarItem.title = @"附近";
    //设置图片
    nearNav.tabBarItem.image = [UIImage imageNamed:@"tab"];
    nearNav.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -2, 0);
    //设置选中图片
    UIImage *nearImage = [UIImage imageNamed:@"tabselect"];
    nearNav.tabBarItem.selectedImage = [nearImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //全球逛
    UIStoryboard *globalStory = [UIStoryboard storyboardWithName:@"GlobalShop" bundle:nil];
    UINavigationController *globalNav = globalStory.instantiateInitialViewController;
    //设置图片
    globalNav.tabBarItem.image = [UIImage imageNamed:@"tab_mall_normal"];
    globalNav.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -2, 0);
    globalNav.tabBarItem.title = @"全球购";
    //设置选中图片
    UIImage *globalImage = [UIImage imageNamed:@"tab_mall_selected"];
    globalNav.tabBarItem.selectedImage = [globalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //发现
    UIStoryboard *discoverStory = [UIStoryboard storyboardWithName:@"Discover" bundle:nil];
    UINavigationController *discoverNav = discoverStory.instantiateInitialViewController;
    discoverNav.tabBarItem.title = @"发现";
    //设置图片
    discoverNav.tabBarItem.image = [UIImage imageNamed:@"tab_discover_normal"];
    discoverNav.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -2, 0);
    //设置选中图片
    UIImage *discoverImage = [UIImage imageNamed:@"tab_discover_selected"];
    discoverNav.tabBarItem.selectedImage = [discoverImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //我的
    UIStoryboard *mineStory = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UINavigationController *MineNav = mineStory.instantiateInitialViewController;
    //设置图片
    MineNav.tabBarItem.image = [UIImage imageNamed:@"tab_person_normal"];
    MineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -2, 0);
    MineNav.tabBarItem.title = @"我的";
    //设置选中图片
    UIImage *mineImage = [UIImage imageNamed:@"tab_person_selected"];
    MineNav.tabBarItem.selectedImage = [mineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //添加到tabBarVC上
    self.tablebarVC.viewControllers = @[MainNav, nearNav, globalNav, discoverNav, MineNav];
    self.tablebarVC.tabBar.tintColor = kColor;
    self.window.rootViewController = self.tablebarVC;

    
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
