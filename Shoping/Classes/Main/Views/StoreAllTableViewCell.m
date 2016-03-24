//
//  StoreAllTableViewCell.m
//  Shoping
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "StoreAllTableViewCell.h"

@implementation StoreAllTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.iconView.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
