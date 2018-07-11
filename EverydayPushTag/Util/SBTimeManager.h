//
//  SBTimeManager.h
//  EverydayPushTag
//
//  Created by poplar on 2018/7/10.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBTimeManager : NSObject
+ (NSDate *)nowTime;
+ (NSString *)dateToStringWithDateFormat:(NSString *)format;
+ (NSString*)weekdayStringFromDate;
+ (BOOL)isSameDay:(NSDate*)date;
@end
