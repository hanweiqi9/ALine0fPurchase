//
//  ResultTableViewCell.h
//  Shoping
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultModel.h"
#import "SearchBeij.h"
@interface ResultTableViewCell : UITableViewCell
@property (nonatomic, strong) SearchResultModel *searchModel;
@property (nonatomic, strong) SearchBeij *beiModel;
@end
