//
//  CenterTableViewCell.m
//  Shoping
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "CenterTableViewCell.h"

@implementation CenterTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imageHead.layer.cornerRadius = 10;
    self.imageHead.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
