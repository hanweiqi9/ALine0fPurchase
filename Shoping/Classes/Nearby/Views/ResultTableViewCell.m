//
//  ResultTableViewCell.m
//  Shoping
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "ResultTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ResultTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *storeImage;
@property (weak, nonatomic) IBOutlet UILabel *strreNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;

@end

@implementation ResultTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

//type= 2
-(void)setSearchModel:(SearchResultModel *)searchModel {
    if (searchModel.mallOrStorePicUrl != nil) {
        [self.storeImage sd_setImageWithURL:[NSURL URLWithString:searchModel.mallOrStorePicUrl] placeholderImage:nil];
    }
    
    self.strreNameLabel.text = searchModel.mallOrStoreName;
    self.addressLabel.text = searchModel.mallOrStoreAddress;
    if (![searchModel.distance isEqual:[NSNull null]]) {
        CGFloat distan = [searchModel.distance floatValue] / 1000;
         [self.distanceBtn setTitle:[NSString stringWithFormat:@"%.2fkm", distan] forState:UIControlStateNormal];
    }
   
}

//type= 1
-(void)setBeiModel:(SearchBeij *)beiModel {
    if (beiModel.brandLogoUrl != nil) {
        [self.storeImage sd_setImageWithURL:[NSURL URLWithString:beiModel.brandLogoUrl] placeholderImage:nil];
    }
    self.addressLabel.hidden = YES;
    self.distanceBtn.hidden = YES;
    self.strreNameLabel.text = beiModel.brandNameEn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
