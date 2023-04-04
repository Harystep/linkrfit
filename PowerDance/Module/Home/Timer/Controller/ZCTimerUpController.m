//
//  ZCTimerUpController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/9.
//

#import "ZCTimerUpController.h"
#import "ZCTimerOperateView.h"
#import "BLETimerServer.h"

@interface ZCTimerUpController ()

@end

@implementation ZCTimerUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    [self setupSubviews];
}

- (void)setupSubviews {
    UILabel *lb = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"正计时", nil) font:60 bold:YES color:[ZCConfigColor txtColor]];
    [self.view addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(59));
    }];
    UILabel *subL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"UP", nil) font:25 bold:YES color:[ZCConfigColor txtColor]];
    [self.view addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lb.mas_centerX);
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    ZCTimerOperateView *operateView = [[ZCTimerOperateView alloc] init];
    [self.view addSubview:operateView];
    [operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(60));
        make.height.mas_equalTo(AUTO_MARGIN(110));
    }];
    [self createShowView:operateView];
    
    [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool getUPMode] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)routerWithEventName:(NSString *)eventName {
    if ([eventName integerValue] == 0) {//exit
        [self resetTimerTrain];
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([eventName integerValue] == 1) {//reset
        [self resetTimerTrain];
    } else if ([eventName integerValue] == 2) {//stop
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerStop] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    } else if ([eventName integerValue] == 3) {//start
        [self startTrainTypeData:[ZCBluthDataTool getUPMode]];
    }
}

- (void)startTrainTypeData:(NSData *)data {
//    [[BLEServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[BLEServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    
    [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerStart] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)resetTimerTrain {
    [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerReset] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
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
- (void)configureBaseInfo {
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"智能计时器", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
    
}

@end
