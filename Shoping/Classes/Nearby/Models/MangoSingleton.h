//
//  MangoSingleton.h
//  UILessonTwelve -- Singltongiten
//
//  Created by scjy on 15/12/3.
//  Copyright (c) 2015年 WangXueJuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MangoSingleton : NSObject
//5.声明一个属性,接收传递值
@property (nonatomic, strong) NSString *inputText;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDictionary *dic;

//1.单例方法，必须是类方法，返回值是这个类本身，保证程序中只有一个对象存在
+ (MangoSingleton *)sharInstance;

@end
