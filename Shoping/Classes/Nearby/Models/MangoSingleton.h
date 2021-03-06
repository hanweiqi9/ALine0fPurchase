//
//  MangoSingleton.h
//  UILessonTwelve -- Singltongiten
//
//  Created by scjy on 15/12/3.
//  Copyright (c) 2015年 WangXueJuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MangoSingleton : NSObject
//5.声明一个属性,接收传递值
//大头针内容
@property (nonatomic, strong) NSString *inputText;   //副标题
@property (nonatomic, strong) NSString *title;       //标题
@property (nonatomic, strong) NSString *imageUrl;    //图片
//字典
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, assign) double latValue;
@property (nonatomic, assign) double lngValue;
@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) NSString *nameCity;
@property (nonatomic, strong) NSString *cityId;

//1.单例方法，必须是类方法，返回值是这个类本身，保证程序中只有一个对象存在
+ (MangoSingleton *)sharInstance;

@end
