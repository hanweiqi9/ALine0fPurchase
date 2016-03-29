//
//  TwoDetailTableViewCell.m
//  Shoping
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "TwoDetailTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@implementation TwoDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configView];
    }
    return self;

}

- (void)configView {
    self.mainPicUrl = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, kWidth - 10, kHeight * 0.4)];
    [self.contentView addSubview:self.mainPicUrl];
    
}

-(void)setTwoModel:(TwoCellModel *)twoModel {
    NSString *str = @"http://api.gjla.com/app_admin_v400/";
    NSString *urlStr = twoModel.mainPicUrl;
    [self.mainPicUrl sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str,urlStr]] placeholderImage:nil];
   
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
