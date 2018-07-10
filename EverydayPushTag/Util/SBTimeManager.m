//
//  SBTimeManager.m
//  EverydayPushTag
//
//  Created by poplar on 2018/7/10.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "SBTimeManager.h"

@implementation SBTimeManager

- (NSDate *)nowTime{
    return [NSDate date];
}

- (NSString *)dateToStringWithDateFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:[self nowTime]];
    return strDate;
}

- (NSString*)weekdayStringFromDate{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:[self nowTime]];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

@end
