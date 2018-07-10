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

@interface SBHomeController ()
@property(strong,nonatomic) SBTimeView *timeView;
@property(strong,nonatomic) SBTagView *tagView;
@property (strong,nonatomic) NSTimer *timer;
@property(assign,nonatomic) BOOL ispush;
@property(strong,nonatomic) NSMutableArray *mArray;
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
    [self createTimer:0.5];
    
    UIPanGestureRecognizer *removeSelfView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelfView:)];
    [self.view addGestureRecognizer:removeSelfView];
}

- (void)removeSelfView:(UIPanGestureRecognizer *)gesture
{
    
    if (!_ispush) {
        _ispush = YES;
        SBRecordController *vc = [[SBRecordController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
//    [self.view removeFromSuperview];
}

- (void)dealloc {
    [self.timer invalidate];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _ispush = NO;
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.timer invalidate];
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
    self.view.backgroundColor = [UIColor yellowColor];
    
    _timeView = [[SBTimeView alloc] init];
    [self.view addSubview:_timeView];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(110);
        make.centerX.equalTo(self.view);
        make.left.right.offset(0);
    }];
    
    _tagView = [[SBTagView alloc] init];
    [self.view addSubview:_tagView];
    
    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.offset(300);
    }];
    
    [_tagView.tagBtn addTarget:self action:@selector(clickTag) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clickTag{
    
    NSString *time = [[[SBTimeManager alloc] init] dateToStringWithDateFormat:@"HH:mm:ss"];
    NSString *date = [[[SBTimeManager alloc] init] dateToStringWithDateFormat:@"yyyy年MM月dd日"];
    NSString *record = [NSString stringWithFormat:@"%@-%@",date,time];
    
//    NSMutableArray *arr = [NSMutableArray array];
    [_mArray addObject:record];
    
    [SBDataManager saveData:_mArray withFileName:@"TIMEDATA"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
