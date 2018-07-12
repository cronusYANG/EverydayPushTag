//
//  SBHomeController.m
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/9.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "SBHomeController.h"
#import "SBTimeView.h"
#import <Masonry.h>
#import "SBTagView.h"
#import "SBTimeManager.h"
#import "SBDataManager.h"
#import "SBRecordController.h"
#import "SBModel.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface SBHomeController ()
@property(strong,nonatomic) SBTimeView *timeView;
@property(strong,nonatomic) SBTagView *tagView;
@property (strong,nonatomic) NSTimer *timer;
@property(assign,nonatomic) BOOL ispush;
@property(strong,nonatomic) NSMutableArray *mArray;

@property(strong,nonatomic) UILabel *centerLabel;
@end

@implementation SBHomeController

//-(NSMutableArray *)mArray{
//    if (!_mArray) {
//        _mArray = [NSMutableArray array];
//    }
//    return _mArray;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    _mArray = [NSMutableArray array];
    [self setupUI];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeSelfView];
}

- (void)removeSelfView
{
    
    if (!_ispush) {
        _ispush = YES;
        SBRecordController *vc = [[SBRecordController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)dealloc {
    [self.timer invalidate];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _ispush = NO;
    [self.navigationController setNavigationBarHidden:YES];
    [self createTimer:0.5];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.timer invalidate];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

//创建定时器
- (void)createTimer:(NSTimeInterval)animationDuration {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:animationDuration target:self selector:@selector(timing) userInfo:nil repeats:YES];
    self.timer.fireDate = [NSDate distantPast];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)timing{
    [self.timeView updateTime];
}

-(void)setupUI{
//    self.view.backgroundColor = [UIColor yellowColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile"]];
    [self.view addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    
    _timeView = [[SBTimeView alloc] init];
    [self.view addSubview:_timeView];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(110);
        make.centerX.equalTo(self.view);
        make.left.right.offset(0);
        make.height.offset(115);
    }];
    
    [_timeView.signIn addTarget:self action:@selector(clickTag) forControlEvents:UIControlEventTouchUpInside];
    
//    _tagView = [[SBTagView alloc] init];
//    [self.view addSubview:_tagView];
//
//    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.width.offset(WIDTH);
//        make.height.offset(HEIGHT/2);
//    }];
    
//    [_tagView.tagBtn addTarget:self action:@selector(clickTag) forControlEvents:UIControlEventTouchUpInside];
    
//    _centerLabel = [[UILabel alloc] init];
//    _centerLabel.text = @"轻  触  中  心  区  域  记  录";
//    _centerLabel.textColor = [UIColor blackColor];
//    _centerLabel.font = [UIFont systemFontOfSize:19];
//    [_centerLabel sizeToFit];
//    [self.view addSubview:_centerLabel];
//
//    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.centerY.equalTo(self.view).offset(20);;
//    }];
    
//    [self labelAnimate];
}

-(void)labelAnimate{
    
    
        [UIView animateWithDuration:2 animations:^{
            self.centerLabel.alpha = 0;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
                self.centerLabel.alpha = 1;
            } completion:^(BOOL finished) {
                [self labelAnimate];
            }];
        }];
    
    
    
    NSLog(@"=====递归");
}

-(void)clickTag{
    id saveTime = [SBDataManager loadDataWithPath:@"TIMEDATA"];
    NSMutableArray *arr = [NSMutableArray array];
    arr = saveTime;
    SBModel *model = [[SBModel alloc] init];
    BOOL isSameDay = false;
    for (int i = 0; i < arr.count; i++) {
        model = arr[i];
        if ([SBTimeManager isSameDay:model.date]) {
            isSameDay = true;
        }
    }
    if (!isSameDay) {
        [self recordCover:NO];
    }else{
        NSString *mes = [NSString stringWithFormat:@"今天已经记录一次,时间为:%@,是否覆盖?",model.record];
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"提示" message:mes preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self recordCover:YES];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }

}

-(void)recordCover:(BOOL)cover{
    if (cover) {
        id data = [SBDataManager loadDataWithPath:@"TIMEDATA"];
        if (data) {
            _mArray = data;
            SBModel *model = [[SBModel alloc] init];
            for (int i = 0; i < _mArray.count; i++) {
                model = _mArray[i];
                if ([SBTimeManager isSameDay:model.date]) {
                    [_mArray removeObjectAtIndex:i];
                }
            }
        }
    }
    

    NSString *time = [SBTimeManager dateToStringWithDateFormat:@"HH:mm:ss"];
    NSString *date = [SBTimeManager dateToStringWithDateFormat:@"yyyy年MM月dd日"];
    NSString *record = [NSString stringWithFormat:@"%@-%@-%@",date,[SBTimeManager weekdayStringFromDate],time];
    SBModel *model = [[SBModel alloc] init];
    model.record = record;
    model.date = [SBTimeManager nowTime];
    model.week = [SBTimeManager weekdayStringFromDate];
    [_mArray addObject:model];
    [SBDataManager saveData:_mArray withFileName:@"TIMEDATA"];

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"记录成功" message:time preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheet addAction:action1];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
