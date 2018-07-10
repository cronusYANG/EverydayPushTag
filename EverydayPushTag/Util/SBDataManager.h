//
//  SBDataManager.h
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/10.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBDataManager : NSObject
+ (id)loadDataWithPath:(NSString *)name;
+ (void)saveData:(id)data withFileName:(NSString *)filename;
+ (BOOL)removeDataWithPath:(NSString *)name;
@end
