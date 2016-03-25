//
//  TabViewController.h
//  Shoping
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "NearbyViewController.h"
#import "CenterViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"

@interface TabViewController : UITabBarController
@property(nonatomic,strong)UINavigationController *MineNav;
@property(nonatomic,strong)UINavigationController *MainNav;
@property(nonatomic,strong)UINavigationController *nearNav;
@property(nonatomic,strong)UINavigationController *globalNav;
@property(nonatomic,strong)UINavigationController *discoverNav;

@end
