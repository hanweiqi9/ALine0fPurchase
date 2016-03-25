//
//  CustomAnnotationView.m
//  Shoping
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "MapViewController.h"
#import "MangoSingleton.h"

#define kCalloutWidth       200.0
#define kCalloutHeight      70.0

@implementation CustomAnnotationView


-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) {
        return;
    }
    if (selected) {
        if (self.calloutView == nil) {
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 2.5, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
        }

        
        MangoSingleton *mango = [MangoSingleton sharInstance];
        self.calloutView.title = mango.title;
        self.calloutView.address = mango.inputText;
        [self addSubview:self.calloutView];
        
    } else {
    
        [self.calloutView removeFromSuperview];
    }
    [super setSelected:selected animated:animated];

}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
