//
//  GuidePageViewController.m
//  Shoping
//
//  Created by scjy on 16/3/29.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "GuidePageViewController.h"
#import "TabViewController.h"

#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

@interface GuidePageViewController ()<UIScrollViewDelegate>

@end

@implementation GuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    [self guidePage];
    
}

- (void)guidePage {
    NSArray *imgArray = @[[UIImage imageNamed:@"7.jpg"],[UIImage imageNamed:@"6.png"],[UIImage imageNamed:@"8.png"]];
    UIScrollView *scrollView1 = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView1.tag = 200;
    scrollView1.pagingEnabled = YES;
    scrollView1.showsHorizontalScrollIndicator = NO;
    scrollView1.showsVerticalScrollIndicator = NO;
    scrollView1.delegate = self;
    scrollView1.contentSize = CGSizeMake(scrollView1.bounds.size.width * 3, scrollView1.bounds.size.height);
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(i * scrollView1.bounds.size.width, 0, scrollView1.bounds.size.width, scrollView1.bounds.size.height)];
        imageView.image = imgArray[i];
        [scrollView1 addSubview:imageView];
        if(i == 2){
            imageView.userInteractionEnabled = YES;
            UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake((imageView.bounds.size.width-150)/2 , imageView.bounds.size.height-60, 150, 50)];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"点击进入" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 25.0;
            button.backgroundColor = kColor;
            [imageView addSubview:button];
        }
    }
    
    [self.view addSubview:scrollView1];
    
    UIPageControl *pageC=[[UIPageControl alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-80)/2, self.view.bounds.size.height-30-60, 80, 30)];
    pageC.tag = 201;
    pageC.numberOfPages = 3.0;
    [self.view addSubview:pageC];

}

-(void)buttonClick:(UIButton *)button{
    TabViewController *tabBarView = [[TabViewController alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //重新设置tabBar的颜色
    tabBarView.tabBar.tintColor = kColor;
    window.rootViewController = tabBarView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    UIPageControl *pageC = (UIPageControl *)[self.view viewWithTag:201];
    pageC.currentPage = index;
    
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
