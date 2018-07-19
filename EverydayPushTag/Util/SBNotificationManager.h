//
//  SBNotificationManager.h
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/19.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBNotificationManager : NSObject
+ (void)getOffWorkToNotificationWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body timeInterval:(NSTimeInterval)timeInterval;
@end
