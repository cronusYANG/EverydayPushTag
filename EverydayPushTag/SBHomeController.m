//
//  SBHomeController.m
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/9.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "SBHomeController.h"
#import "SBTimeView.h"
#import "SBTagView.h"
#import "SBTimeManager.h"
#import "SBDataManager.h"
#import "SBRecordController.h"
#import "SBModel.h"
#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "SBNotificationManager.h"
#import "STLVideoFunctions.h"
#import "SBAddTagManager.h"
#import "SBSettingView.h"

@interface SBHomeController ()
@property(strong,nonatomic) SBTimeView *timeView;
@property(strong,nonatomic) SBTagView *tagView;
@property (strong,nonatomic) NSTimer *timer;
@property(assign,nonatomic) BOOL ispush;
@property(strong,nonatomic) NSMutableArray *mArray;
@property(strong,nonatomic) SBSettingView *settingView;
@end

@implementation SBHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mArray = [NSMutableArray array];
    [self setupUI];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)removeSelfView
{
    
    if (!_ispush) {
        _ispush = YES;
        SBRecordController *vc = [[SBRecordController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }

}

- (void)dealloc {
    [self.timer invalidate];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _ispush = NO;
    [self.navigationController setNavigationBarHidden:YES];
    [self createTimer:0.5];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
    
    [self.timer invalidate];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

//创建定时器
- (void)createTimer:(NSTimeInterval)animationDuration {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:animationDuration target:self selector:@selector(timing) userInfo:nil repeats:YES];
    self.timer.fireDate = [NSDate distantPast];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)timing{
    [self.timeView updateTime];
}

-(void)setupUI{
//    self.view.backgroundColor = [UIColor yellowColor];
//    
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iClarified-iOS11"]];
//    [self.view addSubview:imgView];
//
//    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.left.right.offset(0);
//    }];
    
    // 背景毛玻璃
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [self.view addSubview:effectView];
    
    _timeView = [[SBTimeView alloc] init];
    [self.view addSubview:_timeView];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(110);
        make.centerX.equalTo(self.view);
        make.left.right.offset(0);
        make.height.offset(115);
    }];
    
    [_timeView.signIn addTarget:self action:@selector(clickTag) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *recordBtn = [[UIButton alloc] init];
    [recordBtn setImage:[UIImage imageNamed:@"Timer"] forState:UIControlStateNormal];
    [self.view addSubview:recordBtn];
    
    UIButton *settingBtn = [[UIButton alloc] init];
    [settingBtn setImage:[UIImage imageNamed:@"Settings"] forState:UIControlStateNormal];
    [self.view addSubview:settingBtn];
    
    [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-5);
        make.right.offset(-8);
        make.width.height.offset(45);
    }];
    
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(recordBtn);
        make.left.offset(8);
        make.width.height.offset(45);
    }];
    [recordBtn addTarget:self action:@selector(clickRccord) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn addTarget:self action:@selector(clickSetting) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clickRccord{
    [self removeSelfView];
}

-(void)clickSetting{
    if (![self.settingView superview]) {
        self.settingView = [SBSettingView settingView];
        [self.view addSubview:self.settingView];
        
        [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
            make.width.offset(WIDTH/1.5);
            make.height.offset(HEIGHT/4);
        }];
    }
}

-(void)clickTag{
    [SBAddTagManager addTag];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
