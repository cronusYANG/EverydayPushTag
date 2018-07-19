//
//  SBNotificationManager.m
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/19.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "SBNotificationManager.h"
#import <UserNotifications/UserNotifications.h>

@implementation SBNotificationManager
+ (void)getOffWorkToNotificationWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body timeInterval:(NSTimeInterval)timeInterval{
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

@end
