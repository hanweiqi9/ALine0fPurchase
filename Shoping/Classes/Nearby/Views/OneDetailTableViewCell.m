//
//  OneDetailTableViewCell.m
//  Shoping
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "OneDetailTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height



@implementation OneDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configView];
    }
    return self;

}

- (void)configView {
    //先初始化一个label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kWidth - 20, kHeight * 0.1)];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@""]];
    //将label添加到视图上
    [self.contentView addSubview:label];
    //类型图片
    self.typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kWidth - 20) / 8, kHeight * 0.1)];
    [label addSubview:self.typeImageView];
    //内容图片
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth - 20) / 8 + 20, 6, kHeight * 0.1 - 10, kHeight * 0.1 - 10)];
    [label addSubview:self.logoImageView];
    //内容label
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 20) / 8 + 10 + kHeight * 0.1, 2, kWidth - 20 - kHeight * 0.1 - 20, kHeight * 0.1 / 2)];
     self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [label addSubview:self.nameLabel];
    //时间label
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 20) / 8 + 5 + kHeight * 0.1, kHeight * 0.1 / 2 + 7, kWidth - 20 - kHeight * 0.1 - 20, kHeight * 0.1 / 2)];
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [label addSubview:self.timeLabel];
    
    //创建分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kHeight * 0.1 + 15, kWidth - 20, 2)];
    lineLabel.backgroundColor = [UIColor grayColor];
    lineLabel.alpha = 0.3;
    [self.contentView addSubview:lineLabel];
}


//为setmodel赋值
-(void)setDetailModel:(DetailModel *)detailModel {
    NSString *str = @"http://api.gjla.com/app_admin_v400/";
    NSString *urlStr = detailModel.brandLogoUrl;
    if ([detailModel.type integerValue] == 1) {
        self.typeImageView.image = [UIImage imageNamed:@"you.png"];
        if (detailModel.costPrice != nil) {
            NSString *str1 = detailModel.costPrice;
            self.timeLabel.text = [NSString stringWithFormat:@"¥ %@",str1];
        }else {
            self.timeLabel.text = @"免 费";
        }
        self.timeLabel.textColor = kColor;
        self.nameLabel.text = detailModel.name;
        if (urlStr != NULL) {
            [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str,urlStr]] placeholderImage:nil];
        }
        
    } else {
    self.nameLabel.text = detailModel.name;
    self.typeImageView.image = [UIImage imageNamed:@"zhe.png"];
        if (![urlStr isEqualToString:@""]) {
            [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str,urlStr]] placeholderImage:nil];
        }
    //日期转换
        NSTimeInterval time = [detailModel.beginDate doubleValue] / 1000;
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *timeStr = [dateFormatter stringFromDate:date];
       //转换结束日期
        NSTimeInterval time1 = [detailModel.endDate doubleValue] / 1000;
        NSDate *date1 = [[NSDate alloc] initWithTimeIntervalSince1970:time1];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy/MM/dd"];
        NSString *timeStr1 = [dateFormatter stringFromDate:date1];
        self.timeLabel.text = [NSString stringWithFormat:@"有效期 %@ - %@", timeStr, timeStr1];
        
        
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
