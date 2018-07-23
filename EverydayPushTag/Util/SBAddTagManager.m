//
//  SBAddTagManager.m
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/22.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "SBAddTagManager.h"
#import "SBModel.h"
#import "SBTimeManager.h"
#import "SBDataManager.h"
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>
#import "SBNotificationManager.h"
#import "AppDelegate.h"

@implementation SBAddTagManager

+ (void)addTag{
    id saveTime = [SBDataManager loadDataWithPath:TIMEDATA];
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
        [[self getCurrentViewController] presentViewController:actionSheet animated:YES completion:nil];
    }
    
}

+ (void)recordCover:(BOOL)cover{
    NSMutableArray *mArr = [NSMutableArray array];
    id data = [SBDataManager loadDataWithPath:TIMEDATA];
    if (data) {
        mArr = data;
        if(cover){
            SBModel *model = [[SBModel alloc] init];
            for (int i = 0; i < mArr.count; i++) {
                model = mArr[i];
                if ([SBTimeManager isSameDay:model.date]) {
                    [mArr removeObjectAtIndex:i];
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
    [mArr addObject:model];
    [SBDataManager saveData:mArr withFileName:TIMEDATA];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"记录成功" message:time preferredStyle:UIAlertControllerStyleAlert];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动提示
    //提示音
    SystemSoundID soundIDTest = 1013;
    AudioServicesPlaySystemSound(soundIDTest);
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSTimeInterval countdown = 3600 * 9;
        if ([self timeInterval]>3600) {
            countdown = [self timeInterval];
        }
        NSString *body = [NSString stringWithFormat:@"今天%@打的卡,现在可以走了",time];
        [SBNotificationManager getOffWorkToNotificationWithTitle:@"下班了时间到" subtitle:@"" body:body timeInterval:countdown];
    }];
    [actionSheet addAction:action1];
    [[self getCurrentViewController] presentViewController:actionSheet animated:YES completion:nil];
}

+ (void)saveIntervalTime:(NSString *)timeInterval{
    [SBDataManager saveData:timeInterval withFileName:TIMEINTERVAL];
}

+ (NSTimeInterval)timeInterval{
   id data = [SBDataManager loadDataWithPath:TIMEINTERVAL];
    NSString *str = data;
    NSTimeInterval timeInterval = [str integerValue] * 3600;
    return timeInterval;
}

+ (UIViewController *) getCurrentViewController {
    UIApplication *application = [UIApplication sharedApplication];
    AppDelegate *myAppDelegate = (AppDelegate *)[application delegate];
    UIViewController *viewController;
    if ([myAppDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)myAppDelegate.window.rootViewController;
        viewController = nav.visibleViewController;
    }
    return viewController;
}
@end
