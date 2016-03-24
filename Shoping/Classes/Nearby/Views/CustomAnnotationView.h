//
//  CustomAnnotationView.h
//  Shoping
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"
@interface CustomAnnotationView : MAPinAnnotationView
@property (nonatomic,strong) CustomCalloutView *calloutView;

@end
