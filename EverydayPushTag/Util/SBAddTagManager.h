//
//  SBAddTagManager.h
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/22.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBAddTagManager : NSObject
+ (void)addTag;
+ (void)saveIntervalTime:(NSString *)timeInterval;
+ (NSTimeInterval)timeInterval;
+ (UIViewController *) getCurrentViewController;
@end
