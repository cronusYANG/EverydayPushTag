//
//  SBHomeController.m
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/9.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "SBHomeController.h"
#import "SBTimeView.h"
#import <Masonry.h>
#import "SBTagView.h"
#import "SBTimeManager.h"
#import "SBDataManager.h"
#import "SBRecordController.h"
#import "SBModel.h"
#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface SBHomeController ()
@property(strong,nonatomic) SBTimeView *timeView;
@property(strong,nonatomic) SBTagView *tagView;
@property (strong,nonatomic) NSTimer *timer;
@property(assign,nonatomic) BOOL ispush;
@property(strong,nonatomic) NSMutableArray *mArray;
@end

@implementation SBHomeController

//-(NSMutableArray *)mArray{
//    if (!_mArray) {
//        _mArray = [NSMutableArray array];
//    }
//    return _mArray;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    _mArray = [NSMutableArray array];
    [self setupUI];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeSelfView];
}

- (void)removeSelfView
{
    
    if (!_ispush) {
        _ispush = YES;
        SBRecordController *vc = [[SBRecordController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
    [self.navigationController setNavigationBarHidden:NO];
    
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
    
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile"]];
//    [self.view addSubview:imgView];
//
//    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.left.right.offset(0);
//    }];
    
    _timeView = [[SBTimeView alloc] init];
    [self.view addSubview:_timeView];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(110);
        make.centerX.equalTo(self.view);
        make.left.right.offset(0);
        make.height.offset(115);
    }];
    
    [_timeView.signIn addTarget:self action:@selector(clickTag) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clickTag{
    id saveTime = [SBDataManager loadDataWithPath:@"TIMEDATA"];
    NSMutableArray *arr = [NSMutableArray array];
    arr = saveTime;
    SBModel *model = [[SBModel alloc] init];
    BOOL isSameDay = false;
    for (int i = 0; i < arr.count; i++) {
        model = arr[i];
        if ([SBTimeManager isSameDay:model.date]) {
            isSameDay = true;
        }
    }
    if (!isSameDay) {
        [self recordCover:NO];
    }else{
        NSString *mes = [NSString stringWithFormat:@"今天已经记录一次,时间为:%@,是否覆盖?",model.record];
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"提示" message:mes preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self recordCover:YES];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }

}

-(void)recordCover:(BOOL)cover{
    
    id data = [SBDataManager loadDataWithPath:@"TIMEDATA"];
    if (data) {
        _mArray = data;
        if(cover){
            SBModel *model = [[SBModel alloc] init];
            for (int i = 0; i < _mArray.count; i++) {
                model = _mArray[i];
                if ([SBTimeManager isSameDay:model.date]) {
                    [_mArray removeObjectAtIndex:i];
                }
            }
        }
}
    
    NSString *time = [SBTimeManager dateToStringWithDateFormat:@"HH:mm:ss"];
    NSString *date = [SBTimeManager dateToStringWithDateFormat:@"yyyy年MM月dd日"];
    NSString *record = [NSString stringWithFormat:@"%@-%@-%@",date,[SBTimeManager weekdayStringFromDate],time];
    SBModel *model = [[SBModel alloc] init];
    model.record = record;
    model.date = [SBTimeManager nowTime];
    model.strDate = date;
    model.time = time;
    model.week = [SBTimeManager weekdayStringFromDate];
    [_mArray addObject:model];
    [SBDataManager saveData:_mArray withFileName:@"TIMEDATA"];

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"记录成功" message:time preferredStyle:UIAlertControllerStyleAlert];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动提示
    //提示音
    SystemSoundID soundIDTest = 1013;
    AudioServicesPlaySystemSound(soundIDTest);
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSTimeInterval countdown = 3600 * 9;
        NSString *subtitle = [NSString stringWithFormat:@"今天%@打的卡",time];
        [self getOffWorkToNotificationWithTitle:@"可以下班了" subtitle:subtitle body:@"Behind every successful man there's a lot of unsuccessful years." timeInterval:countdown];
    }];
    [actionSheet addAction:action1];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)getOffWorkToNotificationWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body timeInterval:(NSTimeInterval)timeInterval{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    // 标题
    content.title = title;
    // 次标题
    content.subtitle = subtitle;
    // 内容
    content.body = body;
    
    // app显示通知数量的角标
    content.badge = @0;
    
    // 通知的提示声音，这里用的默认的声音
    content.sound = [UNNotificationSound defaultSound];
    
//    NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"jianglai" withExtension:@"jpg"];
//    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"imageIndetifier" URL:imageUrl options:nil error:nil];
//
//    // 附件
//    content.attachments = @[attachment];
    
    // 标识符
    content.categoryIdentifier = @"categoryIndentifier";
    
    // 2、创建通知触发
    /* 触发器分三种：
     UNTimeIntervalNotificationTrigger : 在一定时间后触发，如果设置重复的话，timeInterval不能小于60
     UNCalendarNotificationTrigger : 在某天某时触发，可重复
     UNLocationNotificationTrigger : 进入或离开某个地理区域时触发
     */
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
    
    // 3、创建通知请求
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"KFGroupNotification" content:content trigger:trigger];
    
    // 4、将请求加入通知中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"已成功加推送%@",notificationRequest.identifier);
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
