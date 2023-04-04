//
//  ZCSmartTimerController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/29.
//

#import "ZCSmartTimerController.h"
#import "ZCTimerEditView.h"
#import "ZCTimerAutoSetView.h"
#import "ZCTimerNormalView.h"
#import "BLETimerServer.h"

@interface ZCSmartTimerController ()<BLEServerDelegate, UIScrollViewDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIScrollView *scView;

@property (nonatomic,strong) ZCTimerEditView *editView;
@property (nonatomic,strong) ZCTimerAutoSetView *setView;
@property (nonatomic,strong) ZCTimerNormalView *normalView;
@property (nonatomic,strong) UILabel *statusL;
@property (nonatomic,assign) NSInteger connectStatus;
@property (nonatomic,strong) BLETimerServer *defaultBLEServer;

@end

@implementation ZCSmartTimerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showNavStatus = YES;
    
    [ZCDataTool saveTimerTypeStatus:0];
    
    self.view.backgroundColor = rgba(235, 235, 235, 1);    
    self.scView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scView];
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
    }];
    self.scView.showsVerticalScrollIndicator = NO;
    
    self.contentView = [[UIView alloc] init];    
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(self.scView);
        make.width.mas_equalTo(SCREEN_W);
    }];
    
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"smart_timer_icon")];
    [self.contentView addSubview:iconIv];
    iconIv.frame = CGRectMake((SCREEN_W - AUTO_MARGIN(120))/2.0, 0, AUTO_MARGIN(120), AUTO_MARGIN(37));
    
    self.statusL = [self.view createSimpleLabelWithTitle:@"正在连接中···" font:13 bold:NO color:[ZCConfigColor subTxtColor]];
    [self.contentView addSubview:self.statusL];
    self.statusL.textAlignment = NSTextAlignmentCenter;
    self.statusL.frame = CGRectMake((SCREEN_W - AUTO_MARGIN(300))/2.0, CGRectGetMaxY(iconIv.frame)+AUTO_MARGIN(15), AUTO_MARGIN(300), AUTO_MARGIN(20));
    
    self.normalView = [[ZCTimerNormalView alloc] initWithFrame:CGRectMake(AUTO_MARGIN(20), AUTO_MARGIN(85), SCREEN_W - AUTO_MARGIN(40), AUTO_MARGIN(194))];
    [self.contentView addSubview:self.normalView];
    [self.normalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(85));
        make.height.mas_equalTo(AUTO_MARGIN(194));
    }];
    
    self.editView = [[ZCTimerEditView alloc] initWithFrame:CGRectMake(AUTO_MARGIN(20), CGRectGetMaxY(self.normalView.frame)+AUTO_MARGIN(30), SCREEN_W - AUTO_MARGIN(40), AUTO_MARGIN(194))];
    [self.contentView addSubview:self.editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.normalView.mas_bottom).offset(AUTO_MARGIN(30));
        make.height.mas_equalTo(AUTO_MARGIN(194));
    }];
    
    self.setView = [[ZCTimerAutoSetView alloc] initWithFrame:CGRectMake(AUTO_MARGIN(20), CGRectGetMaxY(self.editView.frame)+AUTO_MARGIN(30), SCREEN_W - AUTO_MARGIN(40), AUTO_MARGIN(189))];
    [self.contentView addSubview:self.setView];
    [self.setView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.editView.mas_bottom).offset(AUTO_MARGIN(30));
        make.height.mas_equalTo(AUTO_MARGIN(194));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(30));
    }];
        
    self.defaultBLEServer = [BLETimerServer defaultBLEServer];
    self.defaultBLEServer.delegate = self;
    
    if ([BLETimerServer defaultBLEServer].selectPeripheral != nil) {
        [self setModelStatus:1];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[BLETimerServer defaultBLEServer] startScan];
        });
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"come -- %f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -40) {
        if (self.connectStatus) {
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
        [self setModelStatus:1];
    });
}

- (void)didDisconnect {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setModelStatus:1];

    });
}

- (void)setModelStatus:(NSInteger)status {
    self.connectStatus = status;
    if (status == 1) {
        self.statusL.text = NSLocalizedString(@"计时器已经连接，选择模式开始训练！", nil);
    } else {
        self.statusL.text = NSLocalizedString(@"计时器已断开连接", nil);
    }
}

- (void)dealloc {
    [[BLETimerServer defaultBLEServer] stopScan];
    [[BLETimerServer defaultBLEServer] disConnect];
    [BLETimerServer defaultBLEServer].selectPeripheral = nil;
}

@end
