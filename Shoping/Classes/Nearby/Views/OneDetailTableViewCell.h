//
//  OneDetailTableViewCell.h
//  Shoping
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"


@interface OneDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) DetailModel *detailModel;


@end
