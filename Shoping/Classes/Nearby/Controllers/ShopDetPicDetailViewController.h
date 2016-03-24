//
//  ShopDetPicDetailViewController.h
//  Shoping
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwoCellModel.h"
@interface ShopDetPicDetailViewController : UIViewController
@property (nonatomic, strong) NSString *subjectId;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, strong) TwoCellModel *twoModel;


@end
