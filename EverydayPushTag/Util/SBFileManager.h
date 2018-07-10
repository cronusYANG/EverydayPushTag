//
//  SBFileManager.h
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/10.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBFileManager : NSObject
+ (NSString *)creatDocumentFile:(NSString *)fileName;
+ (NSString *)documentDirectoryFilePath:(NSString*)fileName;
+ (BOOL)removeItem:(NSString *)itemPath;
@end
