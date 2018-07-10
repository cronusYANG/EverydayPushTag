//
//  SBDataManager.m
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/10.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "SBDataManager.h"
#import "SBFileManager.h"

@implementation SBDataManager
+ (void)saveData:(id)data withFileName:(NSString *)name
{
    NSString *path = [SBFileManager creatDocumentFile:@"dataFile"];
    NSString *filename = [[NSString alloc]initWithFormat:@"%@.dat",name];
    NSString *filePath = [path stringByAppendingPathComponent:filename];
    [NSKeyedArchiver archiveRootObject:data toFile:filePath];
}

+ (id)loadDataWithPath:(NSString *)name
{
    NSString *path = [SBFileManager creatDocumentFile:@"dataFile"];
    NSString *filename = [[NSString alloc]initWithFormat:@"%@.dat",name];
    NSString *filePath = [path stringByAppendingPathComponent:filename];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (BOOL)removeDataWithPath:(NSString *)name {
    NSString *path = [SBFileManager creatDocumentFile:@"dataFile"];
    NSString *filename = [[NSString alloc]initWithFormat:@"%@.dat",name];
    NSString *filePath = [path stringByAppendingPathComponent:filename];
    return [SBFileManager removeItem:filePath];
}

@end
