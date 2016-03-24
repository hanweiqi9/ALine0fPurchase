
//
//  ShopTableViewCell.m
//  GlobalShoping
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "ShopTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreLocation/CoreLocation.h>
#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface ShopTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;


@end


@implementation ShopTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)setShopModel:(ShopModel *)shopModel {
    [self.imagePicture sd_setImageWithURL:[NSURL URLWithString:shopModel.mallPicUrl] placeholderImage:nil];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",shopModel.mallName];
    CGFloat distance = shopModel.distance / 1000;
    [self.addressBtn setTitle:[NSString stringWithFormat:@"%.2fkm",distance] forState:UIControlStateNormal];

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
