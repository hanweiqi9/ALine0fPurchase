//
//  TabViewController.m
//  Shoping
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "TabViewController.h"


@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefault objectForKey:@"name"];
    NSData *data = [userDefault objectForKey:@"headImage"];
    UIImage *headIma = [UIImage imageWithData:data];
    if (name !=nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.userStr = name;
        login.image1 = headIma;
        self.MineNav =[[UINavigationController alloc] initWithRootViewController:login];
    }else{
        UIStoryboard *mineStory = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        self.MineNav = mineStory.instantiateInitialViewController;
    }
    //我的
    //设置图片
    self.MineNav.tabBarItem.image = [UIImage imageNamed:@"tab_person_normal"];
    self.MineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -2, 0);
    self.MineNav.tabBarItem.title = @"我的";
    //设置选中图片
    UIImage *mineImage = [UIImage imageNamed:@"tab_person_selected"];
    self.MineNav.tabBarItem.selectedImage = [mineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[self.MainNav, self.nearNav, self.globalNav, self.discoverNav, self.MineNav];

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
