//
//  SBSettingView.h
//  EverydayPushTag
//
//  Created by poplar on 2018/7/23.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBSettingView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *affirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;


+ (instancetype)settingView;
@end
