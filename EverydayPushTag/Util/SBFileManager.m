//
//  SBFileManager.m
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/10.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "SBFileManager.h"

@implementation SBFileManager
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+ (NSString *)creatDocumentFile:(NSString *)fileName
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *path_document = [documentDirectory stringByAppendingPathComponent:fileName];
    if (![manager fileExistsAtPath:path_document])
    {
        [manager createDirectoryAtPath:path_document withIntermediateDirectories:YES attributes:nil error:&error];
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path_document]];
    }
    return path_document;
}

+ (NSString *)documentDirectoryFilePath:(NSString*)fileName
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *FilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    return FilePath;
}

+ (BOOL)removeItem:(NSString *)itemPath {
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager removeItemAtPath:itemPath error:&error];
}
@end
