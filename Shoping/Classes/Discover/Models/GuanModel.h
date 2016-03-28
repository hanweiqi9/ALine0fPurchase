//
//  GuanModel.h
//  Shoping
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuanModel : NSObject
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *subTitle;
@property(nonatomic,retain) NSString *titImage;
//@property(nonatomic,retain) NSString *timeText;
@property(nonatomic,retain) NSString *titId;

-(instancetype)initWithDictionary:(NSMutableDictionary *)dic;

@end
