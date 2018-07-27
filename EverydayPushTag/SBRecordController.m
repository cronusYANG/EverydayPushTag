//
//  SBRecordController.m
//  EverydayPushTag
//
//  Created by POPLAR on 2018/7/10.
//  Copyright © 2018年 POPLAR. All rights reserved.
//

#import "SBRecordController.h"
#import "SBDataManager.h"
#import "SBModel.h"
#import "LYSDatePickerController.h"
#import "SBTimeManager.h"
#import "SBNotificationManager.h"
#import "SBAddTagManager.h"
#import <UserNotifications/UserNotifications.h>

static NSString *cellID = @"cell";
@interface SBRecordController ()<UITableViewDelegate,UITableViewDataSource,LYSDatePickerSelectDelegate,UIScrollViewDelegate>
@property(strong,nonatomic) UITableView *tableView;
@property(strong,nonatomic) NSMutableArray *dataArray;
@end

@implementation SBRecordController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadData];
}

-(void)setupUI{
    self.title = @"Record";
        self.view.backgroundColor = [UIColor whiteColor];
    
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iClarified-iOS11"]];
        [self.view addSubview:imgView];
    
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.offset(0);
        }];
    
    // 背景毛玻璃
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [self.view addSubview:effectView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/1.5) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    
    UIButton *dismissBtn = [[UIButton alloc] init];
    [dismissBtn setImage:[UIImage imageNamed:@"power"] forState:UIControlStateNormal];
    [self.view addSubview:dismissBtn];
    [dismissBtn addTarget:self action:@selector(clickDismissBtn) forControlEvents:UIControlEventTouchUpInside];

    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-50);
        make.width.height.offset(60);
    }];
}

-(void)clickDismissBtn{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)loadData{
    id data = [SBDataManager loadDataWithPath:TIMEDATA];
    if (data) {
        self.dataArray = data;
//        self.dataArray = (NSMutableArray *)[[_dataArray reverseObjectEnumerator] allObjects];
        [self.tableView reloadData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    SBModel *mode = [[SBModel alloc] init];
    NSMutableArray *arr = [NSMutableArray array];
    arr = (NSMutableArray *)[[_dataArray reverseObjectEnumerator] allObjects];
    mode = arr[indexPath.row];
    cell.textLabel.text = mode.record;
    NSString *imageName;
    if ([mode.week isEqualToString:@"星期一"]) {
        imageName = @"Monday";
    }else if ([mode.week isEqualToString:@"星期二"]){
        imageName = @"Tuesday";
    }else if ([mode.week isEqualToString:@"星期三"]){
        imageName = @"Wednesday";
    }else if ([mode.week isEqualToString:@"星期四"]){
        imageName = @"Thursday";
    }else if ([mode.week isEqualToString:@"星期五"]){
        imageName = @"Friday";
    }else{
        imageName = @"overtime";
    }
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView setEditing:YES animated:YES];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeekSelf;
    SBModel *model = [[SBModel alloc] init];
    NSMutableArray *arr = [NSMutableArray array];
    arr = (NSMutableArray *)[[_dataArray reverseObjectEnumerator] allObjects];
    model = arr[indexPath.row];
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [weakSelf alterDate:^(NSDate *date) {
            
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"HH:mm:ss"];
            NSString *newTime = [dateFormat stringFromDate:date];
            model.time = newTime;
            model.record = [NSString stringWithFormat:@"%@-%@-%@",model.strDate,model.week,newTime];
            [weakSelf.dataArray addObject:model];
            [SBDataManager saveData:weakSelf.dataArray withFileName:TIMEDATA];
            [weakSelf loadData];
            NSTimeInterval secondsInterval= [[SBTimeManager nowTime] timeIntervalSinceDate:date];
            NSTimeInterval countdown = (3600*9)-secondsInterval;
            if ([SBAddTagManager timeInterval]>3600) {
                countdown = [SBAddTagManager timeInterval]-secondsInterval;
            }
            NSString *body = [NSString stringWithFormat:@"今天%@打的卡,现在可以走了",newTime];
            [SBNotificationManager getOffWorkToNotificationWithTitle:@"下班了时间到" subtitle:@"" body:body timeInterval:countdown];
            
        }];
        
        tableView.editing = NO;
    }];
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
        [SBDataManager saveData:weakSelf.dataArray withFileName:TIMEDATA];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([SBTimeManager isSameDay:model.date]) {
           [SBNotificationManager removeNotification];
        }
        tableView.editing = NO;
    }];
    
    if (![SBTimeManager isSameDay:model.date]) {
        return @[action1];
    }else{
        return @[action1, action0];
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

-(void)alterDate:(void(^)(NSDate *date))date{
    LYSDatePickerController *datePicker = [[LYSDatePickerController alloc] init];
    datePicker.headerView.backgroundColor = [UIColor colorWithRed:84/255.0 green:150/255.0 blue:242/255.0 alpha:1];
    datePicker.indicatorHeight = 5;
    datePicker.delegate = self;
    datePicker.headerView.centerItem.title = @"";
    datePicker.headerView.centerItem.textColor = [UIColor whiteColor];
    datePicker.headerView.leftItem.textColor = [UIColor whiteColor];
    datePicker.headerView.rightItem.textColor = [UIColor whiteColor];
    datePicker.pickHeaderHeight = 40;
    datePicker.pickType = LYSDatePickerTypeTime;
    datePicker.minuteLoop = YES;
    datePicker.headerView.showTimeLabel = NO;
    datePicker.weakDayType = LYSDatePickerWeakDayTypeUSDefault;
    datePicker.showWeakDay = YES;
    [datePicker setDidSelectDatePicker:date];
    [datePicker showDatePickerWithController:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
