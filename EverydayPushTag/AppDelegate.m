//
//  AppDelegate.m
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/9.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "AppDelegate.h"
#import "SBHomeController.h"
#import <UserNotifications/UserNotifications.h>
#import "SBAddTagManager.h"
#import "SBRecordController.h"

#define TYPE_3DTOUCH_RECORD @"TYPE_3DTOUCH_RECORD"
#define TYPE_3DTOUCH_TAG @"TYPE_3DTOUCH_TAG"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    SBHomeController *VC = [[SBHomeController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    [NSThread sleepForTimeInterval:2.0];
    [self requestAuthor];
    [self creatUIApplicationShortcutItems];
    return YES;
}

//创建本地通知
- (void)requestAuthor
{
    // 申请通知权限
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        // A Boolean value indicating whether authorization was granted. The value of this parameter is YES when authorization for the requested options was granted. The value is NO when authorization for one or more of the options is denied.
        if (granted) {
            
            
        }
        
    }];
    
}

- (void)creatUIApplicationShortcutItems {
    
    UIMutableApplicationShortcutItem *tagItem = [self creatUIApplicationShortcutItem:@"img" actionType:nil itemType:TYPE_3DTOUCH_TAG title:@"标记"];
    
    
    UIMutableApplicationShortcutItem *recordItem = [self creatUIApplicationShortcutItem:@"file" actionType:nil itemType:TYPE_3DTOUCH_RECORD title:@"历史记录"];
    
    NSMutableArray *items;
    if (tagItem && recordItem) {
        items = @[tagItem,recordItem].mutableCopy;
    }
    
    if (items.count > 0) {
        [UIApplication sharedApplication].shortcutItems = items;
    }
}

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    
    if (shortcutItem) {
        if ([shortcutItem.type isEqualToString:TYPE_3DTOUCH_TAG]) {
            [SBAddTagManager addTag];
        }else if ([shortcutItem.type isEqualToString:TYPE_3DTOUCH_RECORD]){
            SBRecordController *vc = [[SBRecordController alloc] init];
            [[SBAddTagManager getCurrentViewController] presentViewController:vc animated:YES completion:nil];
        }
    }
    
    if (completionHandler) {
        completionHandler(YES);
    }
}

-(UIMutableApplicationShortcutItem *)creatUIApplicationShortcutItem:(NSString*)iconName actionType:(NSString*)actionType itemType:(nullable NSString*)itemType title:(NSString*)title {
    
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithTemplateImageName:iconName];
    
    NSDictionary *userInfo = [NSDictionary dictionary];
    if (actionType) {
        userInfo = @{@"action_type":actionType};
    } else {
        userInfo = nil;
    }
    
    UIMutableApplicationShortcutItem *item = [[UIMutableApplicationShortcutItem alloc] initWithType:itemType localizedTitle:title localizedSubtitle:@"" icon:icon userInfo:userInfo];
    
    return item;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
