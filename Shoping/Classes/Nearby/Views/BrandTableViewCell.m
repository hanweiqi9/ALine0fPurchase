//
//  BrandTableViewCell.m
//  Shoping
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "BrandTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface BrandTableViewCell ()
@property (nonatomic, strong) UIImageView *storePicImage;
@property (nonatomic, strong) UILabel *enNameLabel;
@property (nonatomic, strong) UILabel *znNameLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIImageView *discountImageView;
@property (nonatomic, strong) UILabel *floorLabel;


@end

@implementation BrandTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configView];
    }
    return self;

}

- (void)configView {

    //图片
    self.storePicImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, kWidth / 4, kWidth / 4)];
    self.storePicImage.layer.cornerRadius = kWidth / 32;
    self.storePicImage.clipsToBounds = YES;
    [self.contentView addSubview:self.storePicImage];
    //英文label
    self.enNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 4 + 17, 2, (kWidth - (kWidth / 4 + 5)) / 2 - 30 , kWidth / 12 - 3)];
    [self.contentView addSubview:self.enNameLabel];
    //中文label
    self.znNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 4 + (kWidth - (kWidth / 4 + 5)) / 2 - 10, 2, (kWidth - (kWidth / 4 + 5)) / 2, kWidth / 12 - 3)];
    [self.contentView addSubview:self.znNameLabel];


    //discounceImage
    self.discountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 4 + 20, kWidth / 12 + 15 + kWidth / 12 , (kWidth - (kWidth / 4 + 5)) / 2 - 90, kWidth / 12 - 10)];
    self.discountImageView.image = [UIImage imageNamed:@"brand_discount"];
    [self.contentView addSubview:self.discountImageView];
    //楼层
    self.floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth * 0.75 + 10, kWidth / 8 + 35, kWidth * 0.25 - 10, kWidth / 12 - 10)];
    self.floorLabel.textColor = [UIColor grayColor];
    self.floorLabel.font = [UIFont systemFontOfSize:15.0];
    self.floorLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.floorLabel];
    
    //分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, kWidth / 8 + 35 + kWidth / 12 - 5, kWidth - 4, 2)];
    lineLabel.backgroundColor = [UIColor grayColor];
    lineLabel.alpha = 0.2;
    [self.contentView addSubview:lineLabel];
    
}


//为model的set方法赋值
-(void)setBrandModel:(BrandModel *)brandModel {
    //为tag标签label赋值
    for (NSInteger i = 0; i < brandModel.categoryName.count; i++) {

        if (i < 4) {
             self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 4 - 5 + i * 60 , kWidth / 12 -5, (kWidth - (kWidth / 4 + 5)) / 2 - 40, kWidth / 12 - 3)];
        } else {
         self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 4 - 5 + (i - 4) * 60 , kWidth / 12 + kWidth / 12 - 15, (kWidth - (kWidth / 4 + 5)) / 2 - 40, kWidth / 12 - 3)];
    }
       [self.contentView addSubview:self.tagLabel];
        self.tagLabel.textColor = [UIColor grayColor];
        self.tagLabel.font = [UIFont systemFontOfSize:13.0];
        self.tagLabel.textAlignment = NSTextAlignmentCenter;
        NSDictionary *dict = [NSDictionary dictionary];
        dict = brandModel.categoryName[i];
        self.tagLabel.text = dict[@"categoryName"];
    }
    //赋值图片
    [self.storePicImage sd_setImageWithURL:[NSURL URLWithString:brandModel.storePicUrl] placeholderImage:nil];
    //英文名字
    self.enNameLabel.text = brandModel.brandNameEn;
    //中文名字
    if (![brandModel.brandNameZh isEqual:[NSNull null]]) {
        self.znNameLabel.text = brandModel.brandNameZh;

    }
        //楼层
    self.floorLabel.text = brandModel.floor;

}


- (void)awakeFromNib {
    // Initialization code

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
