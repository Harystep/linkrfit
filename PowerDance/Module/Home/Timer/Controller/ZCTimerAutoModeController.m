//
//  ZCTimerAutoModeController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/9.
//

#import "ZCTimerAutoModeController.h"
#import "ZCSimpleTimeView.h"
#import "BLETimerServer.h"
#import "ZCTrainModeOperateView.h"

@interface ZCTimerAutoModeController ()

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ZCTimerAutoModeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    
    [self setupSubViews];
}

- (void)setupSubViews {
    UILabel *lb = [self.view createSimpleLabelWithTitle:self.params[@"data"] font:60 bold:YES color:[ZCConfigColor txtColor]];
    [self.view addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(30));
    }];
    
    UILabel *contentL = [self.view createSimpleLabelWithTitle:[ZCBluthDataTool convertModeContentWithType:self.params[@"data"]] font:12 bold:NO color:rgba(43, 42, 51, 0.5)];
    contentL.hidden = YES;
    [self.view addSubview:contentL];
    [contentL setContentLineFeedStyle];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [ZCConfigColor whiteColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(contentL.mas_bottom).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(95));
    }];
    
    ZCSimpleTimeView *timeView = [[ZCSimpleTimeView alloc] init];
    [contentView addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(contentView.mas_centerY);
    }];
    timeView.mode = [ZCBluthDataTool convertAutoModeToIndex:self.params[@"data"]];
    
    ZCTrainModeOperateView *operateView = [[ZCTrainModeOperateView alloc] init];
    [self.view addSubview:operateView];
    [operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(60));
        make.height.mas_equalTo(AUTO_MARGIN(110));
    }];
    [self createShowView:operateView];
    
    [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool sendAutoDataWithMode:self.params[@"data"]] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (UIView *)createShowView:(UIView *)view {
    
    view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = 10;
    view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    view.layer.shadowOffset = CGSizeMake(0,10);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 28;
    return view;
}

- (void)routerWithEventName:(NSString *)eventName {
    if ([eventName integerValue] == 1) {//stop
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerStop] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    } else if ([eventName integerValue] == 2) {//start
        NSLog(@"%@", self.params[@"data"]);
        
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerStart] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
        
    } else {//exit
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerReset] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)configureBaseInfo {
    self.view.backgroundColor = [ZCConfigColor bgColor];
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"智能计时器", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
}

@end
