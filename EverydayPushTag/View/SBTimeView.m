//
//  SBTimeView.m
//  EverydayPushTag
//
//  Created by poplar on 2018/7/10.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "SBTimeView.h"
#import <Masonry.h>
#import "SBTimeManager.h"

@interface SBTimeView()
@property(strong,nonatomic) UILabel *timeLabel;
@property(strong,nonatomic) UILabel *dateLabel;
@end

@implementation SBTimeView
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = [SBTimeManager dateToStringWithDateFormat:@"HH:mm:ss"];
    _timeLabel.font = [UIFont systemFontOfSize:80];
    _timeLabel.tintColor = [UIColor blackColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_timeLabel sizeToFit];
    [self addSubview:_timeLabel];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        
    }];
    
    _dateLabel = [[UILabel alloc] init];
    NSString *date = [SBTimeManager dateToStringWithDateFormat:@"yyyy年MM月dd日"];
    NSString *week = [SBTimeManager weekdayStringFromDate];
    _dateLabel.text = [NSString stringWithFormat:@"%@ %@",date,week];
    _dateLabel.font = [UIFont systemFontOfSize:14];
    _dateLabel.tintColor = [UIColor blackColor];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [_dateLabel sizeToFit];
    [self addSubview:_dateLabel];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(4);
        make.centerX.equalTo(self.timeLabel);
    }];
    
    _signIn = [[UIButton alloc] init];
    [_signIn setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_signIn];
    
    [_signIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.offset(0);
    }];
}

-(void)updateTime{
    _timeLabel.text = [SBTimeManager dateToStringWithDateFormat:@"HH:mm:ss"];
}

//-(void)setTime:(NSString *)time{
//    _time = time;
//    
//    _timeLabel.text = time;
//}

@end
