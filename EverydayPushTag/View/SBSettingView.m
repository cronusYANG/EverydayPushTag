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
    if (_timeTF.text.length && inter<=24 && inter>0) {
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
    
    return [self validateTextField:textField InRange:range ReplacementString:string];
}

- (BOOL)validateTextField:(UITextField *)textField InRange:(NSRange)range ReplacementString:(NSString*)string {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < string.length) {
        NSString * str = [string substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [str rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    if (res) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        res = newLength <= 2;
    }

    return res;
}

+ (instancetype)settingView {
    
    UINib *nib = [UINib nibWithNibName:@"SBSettingView" bundle:nil];
    
    SBSettingView *settingView = [nib instantiateWithOwner:nil options:nil][0];
    
    return settingView;
}

@end
