//
//  BrandViewController.h
//  Shoping
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandViewController : UIViewController
{
    NSInteger _sortType;
    NSString *categoryId;
    NSInteger _pageNum;
}
@property (nonatomic, strong) NSMutableArray *tranlArray;
@property (nonatomic, strong) NSString *catId;

@end
