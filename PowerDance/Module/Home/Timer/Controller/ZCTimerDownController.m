//
//  ZCTimerDownController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/9.
//

#import "ZCTimerDownController.h"
#import "ZCTimerOperateView.h"
#import "ZCTimerDownSetView.h"
#import "BLETimerServer.h"
#import "ZCTimerDownSetOtherView.h"

@interface ZCTimerDownController ()

@property (nonatomic,strong) ZCTimerDownSetOtherView *setView;

@end

@implementation ZCTimerDownController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseInfo];
    [self setupSubviews];
    
    ZCTimerOperateView *operateView = [[ZCTimerOperateView alloc] init];
    [self.view addSubview:operateView];
    [operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(30));
        make.height.mas_equalTo(AUTO_MARGIN(110));
    }];
    [self createShowView:operateView];
    if ([BLETimerServer defaultBLEServer].selectCharacteristic) {
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool getDOWNMode] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    }
    
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
    if ([BLETimerServer defaultBLEServer].selectPeripheral != nil) {
        if ([eventName integerValue] == 0) {//exit
            [self resetTimerTrain];
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([eventName integerValue] == 1) {//reset
            [self resetTimerTrain];
        } else if ([eventName integerValue] == 2) {//stop
            [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerStop] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
        } else if ([eventName integerValue] == 3) {//start
            [self startTrainTypeData:[ZCBluthDataTool getDOWNMode]];
        }
    } else {
        [self.view makeToast:NSLocalizedString(@"请连接计时器", nil) duration:1.5 position:CSToastPositionCenter];
    }
}

- (NSString *)convertTimeStringWithContent:(NSString *)content {
    if (content.length == 1) {
        return [NSString stringWithFormat:@"0%@", content];
    } else {
        return content;
    }
}

- (void)startTrainTypeData:(NSData *)data {

    [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerStart] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
 
}

- (void)resetTimerTrain {
    [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool timerReset] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)setupSubviews {
    UILabel *lb = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"倒计时", nil) font:60 bold:YES color:[ZCConfigColor txtColor]];
    [self.view addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(59));
    }];
    UILabel *subL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"DOWN", nil) font:25 bold:YES color:[ZCConfigColor txtColor]];
    [self.view addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(lb.mas_centerX);
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    self.setView = [[ZCTimerDownSetOtherView alloc] init];
    [self.view addSubview:self.setView];
    [self.setView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).offset((SCREEN_W-AUTO_MARGIN(291))/2.0);
        make.top.mas_equalTo(subL.mas_bottom).offset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(150));
        make.width.mas_equalTo(AUTO_MARGIN(AUTO_MARGIN(291)));
    }];
    
    ZCSimpleButton *saveBtn = [self.view createShadowButtonWithTitle:NSLocalizedString(@"保存", nil) font:15 color:[ZCConfigColor txtColor]];
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.setView.mas_bottom).offset(AUTO_MARGIN(15));
        make.width.mas_equalTo(AUTO_MARGIN(110));
        make.height.mas_equalTo(AUTO_MARGIN(46));
    }];
    [saveBtn setViewBorderWithColor:1 color:[ZCConfigColor txtColor]];
    [saveBtn addTarget:self action:@selector(saveOperate) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setViewCornerRadiu:AUTO_MARGIN(23)];
    
}

- (void)saveOperate {
    NSString *content = [NSString stringWithFormat:@"00:%@:%@", [self convertTimeStringWithContent:self.setView.minuteStr], [self convertTimeStringWithContent:self.setView.mouseStr]];
    [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool downModeSetMouse:[[ZCDataTool convertStringTimeToMouse:content] integerValue]] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
    
    [self.view makeToast:NSLocalizedString(@"已保存", nil) duration:1.5 position:CSToastPositionCenter];
}

- (void)configureBaseInfo {
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"智能计时器", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
    
}

@end
