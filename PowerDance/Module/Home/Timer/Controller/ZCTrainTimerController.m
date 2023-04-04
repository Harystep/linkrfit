//
//  ZCTrainTimerController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/9.
//

#import "ZCTrainTimerController.h"
#import "ZCTimerModeView.h"
#import "ZCTimerOtherFuncView.h"
#import "BLETimerServer.h"

@interface ZCTrainTimerController ()<BLEServerDelegate, UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scView;
@property (nonatomic,strong) UIView       *contentView;
@property (nonatomic,strong) ZCTimerModeView      *modeView;
@property (nonatomic,strong) ZCTimerOtherFuncView *funcView;
@property (nonatomic,strong) ZCTimerOtherFuncView  *setView;
@property (nonatomic,strong) BLETimerServer *defaultBLEServer;

@end

@implementation ZCTrainTimerController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    
    [ZCDataTool saveTimerTypeStatus:0];
    
    self.scView = [[UIScrollView alloc] init];
    self.scView.showsVerticalScrollIndicator = NO;
    self.scView.delegate = self;
    [self.view addSubview:self.scView];
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGINY(20));
    }];
    self.contentView = [[UIView alloc] init];
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView);
    }];
    
    self.modeView = [[ZCTimerModeView alloc] init];
    [self.contentView addSubview:self.modeView];
    [self.modeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(AUTO_MARGIN(288));
    }];
    
    self.funcView = [[ZCTimerOtherFuncView alloc] init];
    [self.contentView addSubview:self.funcView];
    self.funcView.type = 0;
    [self.funcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.modeView.mas_bottom).offset(AUTO_MARGINY(15));
        make.height.mas_equalTo(AUTO_MARGIN(146));
    }];
    
    self.setView = [[ZCTimerOtherFuncView alloc] init];
    [self.contentView addSubview:self.setView];
    self.setView.type = 1;
    [self.setView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.funcView.mas_bottom).offset(AUTO_MARGINY(15));
        make.height.mas_equalTo(AUTO_MARGIN(146));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGINY(30));
    }];
    
    
    self.defaultBLEServer = [BLETimerServer defaultBLEServer];
    self.defaultBLEServer.delegate = self;
    
    if ([BLETimerServer defaultBLEServer].selectPeripheral != nil) {
        self.modeView.status = TimerConnectStatusSuccess;
    } else {        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[BLETimerServer defaultBLEServer] startScan];
        });
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"come -- %f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -40) {
        if (self.modeView.status != TimerConnectStatusSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[BLETimerServer defaultBLEServer] startScan];
            });
        }
    }
}

- (void)didFoundPeripheral {
    NSLog(@"come here");
}

- (void)didConnect {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.modeView.status = TimerConnectStatusSuccess;
        NSLog(@"status:%zd", self.modeView.status);
    });
}

- (void)didDisconnect {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.modeView.status = TimerConnectStatusNot;
//        [self.defaultBLEServer startScan];
    });
}

- (void)configureBaseInfo {
    self.view.backgroundColor = rgba(246, 246, 246, 1);
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"智能计时器", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backStyle = UINavBackButtonColorStyleBack;
}

- (void)dealloc {
    [[BLETimerServer defaultBLEServer] stopScan];
    [[BLETimerServer defaultBLEServer] disConnect];
    [BLETimerServer defaultBLEServer].selectPeripheral = nil;
}

@end
