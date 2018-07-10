//
//  SBTagView.m
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/9.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "SBTagView.h"
#import <Masonry.h>

#define BTN_W 150

@implementation SBTagView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    _tagBtn = [[UIButton alloc] init];
    [_tagBtn setImage:[UIImage imageNamed:@"tag"] forState:UIControlStateNormal];
    _tagBtn.layer.borderWidth = 2;
    _tagBtn.layer.cornerRadius = BTN_W/2;
    _tagBtn.layer.masksToBounds = YES;
    [self addSubview:_tagBtn];
    
    [_tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.with.offset(BTN_W);
    }];
}

@end
