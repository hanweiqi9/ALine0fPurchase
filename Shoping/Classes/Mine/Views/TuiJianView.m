//
//  TuiJianView.m
//  Shoping
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kRedirectURI @"https://api.weibo.com/oauth2/default.html"

#import "TuiJianView.h"
#import "AppDelegate.h"
#import "WXApi.h"

@interface TuiJianView ()<WXApiDelegate>
@property(nonatomic,strong) UIView *grayView;
@property(nonatomic,strong) UIView *shareView;

@end

@implementation TuiJianView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

-(void)configView{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.grayView.backgroundColor = [UIColor blackColor];
    self.grayView.alpha = 0.5;
    [window addSubview:self.grayView];
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - kHeight*2/5, kWidth, kHeight *2/5)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [window addSubview:self.shareView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kWidth * 1/3, kHeight * 1/66, kWidth * 1/3 , 30)];
    title.text = @"分享到";
    title.alpha = 0.5;
    title.font = [UIFont systemFontOfSize:15.0];
    title.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:title];
    
    UIButton *weixinBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake(kWidth/5, kHeight*1/66+30, kWidth/5, kWidth/5);
    [weixinBtn setImage:[UIImage imageNamed:@"share_wechat"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(weixinAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:weixinBtn];
    
    UILabel *weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/5-5, kHeight*1/66+25+kWidth/5, kWidth/4, 30)];
    weixinLabel.text = @"微信好友";
    weixinLabel.font = [UIFont systemFontOfSize:16.0];
    weixinLabel.textAlignment = NSTextAlignmentCenter;
    weixinLabel.alpha = 0.6;
    [self.shareView addSubview:weixinLabel];
    
    UIButton *firendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    firendBtn.frame = CGRectMake(kWidth*3/5, kHeight*1/66+30, kWidth/5, kWidth/5);
    [firendBtn setImage:[UIImage imageNamed:@"share_friends"] forState:UIControlStateNormal];
    [firendBtn addTarget:self action:@selector(firendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:firendBtn];
    UILabel *firendLabel =[[UILabel alloc] initWithFrame:CGRectMake(kWidth*3/5-5, kHeight*1/66+25+kWidth/5, kWidth/4, 30)];
    firendLabel.text = @"微信朋友圈";
    firendLabel.font = [UIFont systemFontOfSize:16.0];
    firendLabel.textAlignment = NSTextAlignmentCenter;
    firendLabel.alpha = 0.6;
    [self.shareView addSubview:firendLabel];
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(0, kWidth * 6/13, kWidth, 30);
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removeBtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.shareView.frame = CGRectMake(0, kHeight-(kHeight * 250/667), kWidth, kHeight * 350/667);
    }];
    
}

//weixin
-(void)weixinAction{
    SendMessageToWXReq *req =[[SendMessageToWXReq alloc]init];
    req.text = @"想购物，快来一线购吧！";
    req.bText = YES;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];

}

//朋友圈
-(void)firendAction{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res5thumb.png"]];
    
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"en" ofType:@".png"];
    
    ext.imageData = [NSData dataWithContentsOfFile:filePath];
    
    UIImage* image = [UIImage imageWithData:ext.imageData];
    ext.imageData = UIImagePNGRepresentation(image);
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.text = @"一线购，带你逛意想不到的商品！";
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
    
    
}

-(void)removeAction{
    [self.shareView removeFromSuperview];
    [self.grayView removeFromSuperview];
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
