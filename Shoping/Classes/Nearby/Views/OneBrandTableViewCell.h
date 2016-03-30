//
//  OneBrandTableViewCell.h
//  Shoping
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneBrandModel.h"

@protocol likeCollectionDelegate <NSObject>


- (void)likeCollection:(UIButton *)btn;

@end

@interface OneBrandTableViewCell : UITableViewCell
@property(nonatomic,strong) UIButton *btn;

@property (nonatomic, strong) OneBrandModel *oneModel;
@property (nonatomic, assign) id<likeCollectionDelegate>delegate;
@end
