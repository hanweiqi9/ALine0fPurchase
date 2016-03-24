
//
//  OneBrandTableViewCell.m
//  Shoping
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "OneBrandTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface OneBrandTableViewCell ()
{
    NSInteger _clickCount;
}
@property (nonatomic, strong) UIImageView *storePicImage;  //图片
@property (nonatomic, strong) UILabel *znNameLabel;  //名字
@property (nonatomic, strong) UILabel *tagLabel;  //标签
@property (nonatomic, strong) UIImageView *discountImageView; //折扣
@property (nonatomic, strong) UIButton *likeBtn;  //关注

@end

@implementation OneBrandTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configView];
    }
    return self;
    
}

- (void)configView {
    //图片
    self.storePicImage = [[UIImageView alloc] initWithFrame:CGRectMake(4, 5, kWidth / 4 - 10, kWidth / 4 - 10)];
    self.storePicImage.layer.cornerRadius = kWidth / 34;
    self.storePicImage.clipsToBounds = YES;
    [self.contentView addSubview:self.storePicImage];
    //中文label
    self.znNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 4 + 7, 5, kWidth - kWidth / 4 - 14 , kWidth / 12 - 3)];
    [self.contentView addSubview:self.znNameLabel];
    
    //discounceImage
    self.discountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 4 + 20, kWidth / 12 + 13 + kWidth / 12 , (kWidth - (kWidth / 4 + 5)) / 2 - 90, kWidth / 12 - 10)];
    self.discountImageView.image = [UIImage imageNamed:@"brand_discount"];
    [self.contentView addSubview:self.discountImageView];
    //关注
    self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeBtn.frame = CGRectMake(kWidth * 0.75 + 25, kWidth / 8 + 13, kWidth * 0.1 - 13, kWidth * 0.1 - 13);
    [self.likeBtn setImage:[UIImage imageNamed:@"brand_favor_no"] forState:UIControlStateNormal];
    [self.likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.likeBtn];
    //分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, kWidth / 8 + 23 + kWidth / 12, kWidth - 4, 2)];
    lineLabel.backgroundColor = [UIColor grayColor];
    lineLabel.alpha = 0.2;
    [self.contentView addSubview:lineLabel];
    
}

//为setmodel方法赋值
-(void)setOneModel:(OneBrandModel *)oneModel {
    NSDictionary *dict = [NSDictionary dictionary];
    //为tagLabel赋值
    for (NSInteger i = 0; i < oneModel.categoryName.count; i++) {
        if (i < 4) {
            self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 4 - 10 + i * 60 , kWidth / 12, (kWidth - (kWidth / 4 + 5)) / 2 - 42, kWidth / 12 - 3)];
        }else {
            self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 4 - 10 + (i - 4) * 60 , kWidth / 12 + kWidth / 12 - 12, (kWidth - (kWidth / 4 + 5)) / 2 - 40, kWidth / 12 - 3)];
        }
        [self.contentView addSubview:self.tagLabel];
        self.tagLabel.textColor = [UIColor grayColor];
        self.tagLabel.font = [UIFont systemFontOfSize:13.0];
        self.tagLabel.textAlignment = NSTextAlignmentCenter;
        dict = oneModel.categoryName[i];
        self.tagLabel.text = dict[@"categoryName"];

    }
    //为图片赋值
    [self.storePicImage sd_setImageWithURL:[NSURL URLWithString:oneModel.brandLogoUrl] placeholderImage:nil];
    //赋值名字

    if ([oneModel.brandNameZh isEqualToString:@""]) {
        
        self.znNameLabel.text = oneModel.brandNameEn;
    } else {
        
        self.znNameLabel.text = oneModel.brandNameZh;
    }

}

//点击关注按钮响应事件
- (void)likeBtnAction:(UIButton *)btn {
    _clickCount += 1;
    if (_clickCount % 2 != 0) {
        [self.likeBtn setImage:[UIImage imageNamed:@"brand_favor_yes"] forState:UIControlStateNormal];
    } else {
         [self.likeBtn setImage:[UIImage imageNamed:@"brand_favor_no"] forState:UIControlStateNormal];
    
    }

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
