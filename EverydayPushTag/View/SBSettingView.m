//
//  SBSettingView.m
//  EverydayPushTag
//
//  Created by poplar on 2018/7/23.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "SBSettingView.h"
#import "SBAddTagManager.h"

@interface SBSettingView()<UITextFieldDelegate>

@end

@implementation SBSettingView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    _timeTF.delegate = self;
    _timeTF.keyboardType = UIKeyboardTypeNumberPad;
    [_cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [_affirmBtn addTarget:self action:@selector(clickAffirm) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickAffirm{
    NSInteger inter = [_timeTF.text integerValue];
    if (_timeTF.text.length && inter<= 24) {
        [SBAddTagManager saveIntervalTime:_timeTF.text];
        [self removeFromSuperview];
    }
}

-(void)clickCancel{
    [self removeFromSuperview];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 2;
    
}

+ (instancetype)settingView {
    
    UINib *nib = [UINib nibWithNibName:@"SBSettingView" bundle:nil];
    
    SBSettingView *settingView = [nib instantiateWithOwner:nil options:nil][0];
    
    return settingView;
}

@end
