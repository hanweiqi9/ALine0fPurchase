//
//  LoginViewController.m
//  Shoping
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#define kColor [UIColor colorWithRed:255.0 / 255.0 green:89.0 / 255.0 blue:94.0 / 255.0 alpha:1.0];

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#import "LoginViewController.h"
#import "GuanzhuViewController.h"
#import "ShoucangViewController.h"
#import "LPLevelView.h"
#import "ShezhiViewController.h"
@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSMutableArray *imageArray;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UILabel *phoneLabel;//用户名 //头像
@property(nonatomic,strong) UILabel *headerLabel;
@property(nonatomic,strong) UIButton *setBtn;
@property(nonatomic,strong) UIView *head;
@property(nonatomic,assign) float level;
@property(nonatomic,strong) UIButton *headBtn;
@property(nonatomic,strong) UIView *score1;
@property(nonatomic,strong) UIView *grayView;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"个人中心";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, kWidth/7, 44);
    [backBtn setImage:[UIImage imageNamed:@"arrow_left_pink"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 5)];
    [backBtn addTarget:self action:@selector(backBtnActivity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
     backBtn.hidden = YES;
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
   
    
    self.setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.setBtn.frame = CGRectMake(kWidth*6/7, 0, kWidth/7, 44);
    [self.setBtn setImage:[UIImage imageNamed:@"my_shezhi"] forState:UIControlStateNormal];
    [self.setBtn addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:self.setBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    
    
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"我的关注",@"我的收藏",@"我的评论",@"客服中心", nil];
    self.imageArray = [[NSMutableArray alloc] initWithObjects:@"my_attention_icon",@"my_favor_icon",@"my_comment_icon",@"my_kefuzhongxin", nil];
    [self.view addSubview:self.tableView];
    [self tableViewHeadView];
}
-(void)backBtnActivity{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)tableViewHeadView{
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth*1/2)];
    
    heardView.backgroundColor = kColor;
    
    [heardView addSubview:self.phoneLabel];
    self.headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headBtn.frame = CGRectMake(kWidth/9, kWidth/10, kWidth/4, kWidth/4);
    self.headBtn.layer.cornerRadius = kWidth/8;
    self.headBtn.clipsToBounds = YES;
    [self.headBtn addTarget:self action:@selector(headimageAction) forControlEvents:UIControlEventTouchUpInside];
    self.headBtn.backgroundColor = [UIColor whiteColor];
    [self.headBtn setImage:self.image1 forState:UIControlStateNormal];
    [heardView addSubview:self.headBtn];
    
    self.tableView.tableHeaderView = heardView;
    
    [self setextendCell:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

#pragma mark ---------删除多余cell
-(void)setextendCell:(UITableView *)cell{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [cell setTableFooterView:view];
}
//头像
//打开系统相册
#pragma mark--------------打开系统相册
-(void)headimageAction{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打开系统方法" message:@"请选择需要的打开方式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"相机");
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate =self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickImage = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pickImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickImage.sourceType];
        }
        pickImage.delegate = self;
        pickImage.allowsEditing = YES;
        [self presentViewController:pickImage animated:YES completion:nil];
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
//相册
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo{
    [self.headBtn setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:imageData forKey:@"headImage"];
    [userDefaults synchronize];

}

//相机
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
    
}

-(void)saveImage:(UIImage *)image{
    [self.headBtn setImage:image forState:UIControlStateNormal];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:imageData forKey:@"headImage"];
    [userDefaults synchronize];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//设置
-(void)setAction{
    ShezhiViewController *shezhiView =[[ShezhiViewController alloc] init];
    [self.navigationController pushViewController:shezhiView animated:YES];
    
}


#pragma mark -------- 懒加载
-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}

-(UILabel *)phoneLabel{
    if (_phoneLabel == nil) {
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/10+kWidth/4+20, kWidth/10+40, kWidth/2, 30)];
        
        self.phoneLabel.textColor = [UIColor whiteColor];
        self.phoneLabel.font = [UIFont systemFontOfSize:17.0];
        self.phoneLabel.text = self.userStr;
    }
    return _phoneLabel;
}


#pragma mark--------------UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewRowActionStyleDestructive;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            GuanzhuViewController *guanView =[[GuanzhuViewController alloc] init];
            [self.navigationController pushViewController:guanView animated:YES];
        }
            break;
        case 1:
        {
            ShoucangViewController *shouView =[[ShoucangViewController alloc] init];
            [self.navigationController pushViewController:shouView animated:YES];
        }
            break;
        case 2:
        {
            self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
            self.grayView.backgroundColor = [UIColor blackColor];
            self.grayView.alpha = 0.5;
            [self.view addSubview:self.grayView];
            
            self.score1 = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight/2, kWidth,kWidth)];
            self.score1.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:self.score1];
            
            UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            removeBtn.frame = CGRectMake(20,kWidth/2, kWidth- 40,40);
            [removeBtn setTitle:@"给我评分" forState:UIControlStateNormal];
            [removeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [removeBtn addTarget:self action:@selector(last ) forControlEvents:UIControlEventTouchUpInside];
            removeBtn.backgroundColor = kColor;
            [self.score1 addSubview:removeBtn];
            
            LPLevelView *lView = [LPLevelView new];
            lView.frame = CGRectMake(kWidth/3,kWidth/4,kWidth/3,44);
            lView.iconColor = [UIColor orangeColor];
            lView.iconSize = CGSizeMake(20, 20);
            lView.canScore = YES;
            lView.animated = YES;
            lView.level = 3.5;
            [lView setScoreBlock:^(float level) {
                self.level = level;
            }];
            [self.score1 addSubview:lView];
        }
            break;
        case 3:
        {
            //应用内拨打电话返回应用
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://18860233262"]]];
            UIWebView *cellPhoneWebView = [[UIWebView alloc] init];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://18860233262"]]];
            [cellPhoneWebView loadRequest:request];
            [self.view addSubview:cellPhoneWebView];
        }
            break;
            default:
            break;
    }
}


-(void)last{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要评分吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"评分成功" message:@"感谢您的支持" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.score1 removeFromSuperview];
            [self.grayView removeFromSuperview];
            //            self.scoreLabel.text = [NSString stringWithFormat:@" 给我评分 (%.f 分)",self.level];
            NSString *score = [NSString stringWithFormat:@"给我评分（%.f分）",self.level];
            [self.titleArray replaceObjectAtIndex:2 withObject:score];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        [alert1 addAction:action1];
        [self presentViewController:alert1 animated:YES completion:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.score1 removeFromSuperview];
        [self.grayView removeFromSuperview];
    }];
    [alert addAction:action];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
