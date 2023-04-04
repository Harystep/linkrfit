//
//  ZCTimerOtherFuncView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/9.
//

#import "ZCTimerOtherFuncView.h"
#import "BLETimerServer.h"
#import "ZCAlertTimePickView.h"

@interface ZCTimerOtherFuncView ()

@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSArray *typeArr;
@property (nonatomic,strong) UIView  *itemView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,assign) NSInteger volume;
@property (nonatomic,assign) NSInteger light;
@property (nonatomic,assign) NSInteger timeType;
@property (nonatomic,strong) UIButton *hourBtn;
@property (nonatomic,strong) UILabel  *hourL;
@property (nonatomic,strong) ZCAlertTimePickView *pick;

@end

@implementation ZCTimerOtherFuncView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [ZCConfigColor whiteColor];
        self.volume = 1;
        self.light = 1;
        self.timeType = 0;
        [self setViewCornerRadiu:10];
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:14 bold:NO color:rgba(43, 42, 51, 0.5)];
    [self addSubview:titleL];
    self.titleL = titleL;
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self).inset(AUTO_MARGIN(20));
    }];
    
    UIView *itemView = [[UIView alloc] init];
    [self addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGINY(20));
        make.bottom.mas_equalTo(self);
    }];
    self.itemView = itemView;
//    [self setupItemViewSubviews:itemView];
}

- (void)setType:(NSInteger)type {
    _type = type;
    self.typeArr = self.dataArr[type];
    [self setupItemViewSubviews:self.itemView];
    if (type) {
        self.titleL.text = NSLocalizedString(@"计时器设置", nil);
    } else {
        self.titleL.text = NSLocalizedString(@"其他功能", nil);
    }
}

- (void)setupItemViewSubviews:(UIView *)itemView {
    CGFloat width = (SCREEN_W - AUTO_MARGIN(40))/3.0;
    for (int i = 0; i < self.typeArr.count; i ++) {
        NSDictionary *dic = self.typeArr[i];
        UIView *contentView = [[UIView alloc] init];
        [itemView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(itemView.mas_top);
            make.leading.mas_equalTo(itemView.mas_leading).offset(width*i);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(AUTO_MARGIN(75));
        }];
        
        ZCSimpleButton *item = [self createShadowButtonWithTitle:@"" font:14 color:[ZCConfigColor txtColor]];
        [contentView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentView.mas_top);
            make.centerX.mas_equalTo(contentView.mas_centerX);
            make.width.mas_equalTo(AUTO_MARGIN(50));
            make.height.mas_equalTo(AUTO_MARGIN(50));
        }];
        [item setImage:kIMAGE(dic[@"image"]) forState:UIControlStateNormal];
        [item setViewCornerRadiu:AUTO_MARGIN(25)];
        item.backgroundColor = rgba(246, 246, 246, 1);
        item.tag = i;
        [item addTarget:self action:@selector(itemOperate:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *titleL = [self createSimpleLabelWithTitle:dic[@"title"] font:14 bold:NO color:[ZCConfigColor txtColor]];
        [contentView addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(item.mas_centerX);
            make.top.mas_equalTo(item.mas_bottom).offset(AUTO_MARGIN(10));
        }];
    }
}

- (void)itemOperate:(UIButton *)sender {
    NSData *data;
    if ([BLETimerServer defaultBLEServer].selectCharacteristic != nil) {
        if (self.type) {
            switch (sender.tag) {
                case 0:
                {
                    data = [ZCBluthDataTool volumeData:self.volume];
                    if ([ZCDataTool getTimerTypeStatus] == 1) {
                        if (self.volume == 1) {
                            self.volume = 0;
                        } else {
                            self.volume = 1;
                        }
                    } else {
                        if (self.volume == 3) {
                            self.volume = 0;
                        } else {
                            self.volume ++;
                        }
                    }
                }
                    break;
                case 1:
                {
                    data = [ZCBluthDataTool brightData:self.light];
                    if (self.light == 3) {
                        self.light = 1;
                    } else {
                        self.light ++;
                    }
                }
                    break;
                case 2:
                {
                    //                    [self setTimerModeData:[ZCBluthDataTool getClockMode]];
                    data = [ZCBluthDataTool getClockMode];
                    
                    [self timeOperate];
                }
                    break;
                    
                default:
                    break;
            }
            if (data != nil || [BLETimerServer defaultBLEServer].selectCharacteristic != nil) {
                [self setTimerModeData:data];
            }
        } else {
            
            switch (sender.tag) {
                case 0:
                    
                    [HCRouter router:@"TimerUp" params:@{} viewController:self.superViewController animated:YES];
                    break;
                case 1:
                    
                    [HCRouter router:@"TimerDown" params:@{} viewController:self.superViewController animated:YES];
                    break;
                case 2:
                    [HCRouter router:@"TimerStopWatch" params:@{} viewController:self.superViewController animated:YES];
                    break;
                    
                default:
                    break;
            }
        }
    } else {
        [self makeToast:NSLocalizedString(@"请连接计时器", nil) duration:1.5 position:CSToastPositionCenter];
    }
     
}

- (void)setTimerModeData:(NSData *)data {
    if ([BLETimerServer defaultBLEServer].selectCharacteristic != nil) {
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
        
    }
}

#pragma -- mark 点击时间
- (void)timeOperate {
    ZCAlertTimePickView *pick = [[ZCAlertTimePickView alloc] init];
    [self addSubview:pick];
    self.pick = pick;
    [pick showAlertView];
    pick.titleL.text = NSLocalizedString(@"设置时间", nil);
    kweakself(self);
    pick.sureRepeatOperate = ^(NSString * _Nonnull content) {
        [weakself setTimerCurrentTime:content];
    };
    self.pick.hourType = 0;
//    [pick.contentView addSubview:self.hourBtn];
//    [pick.contentView addSubview:self.hourL];
//    [self.hourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.mas_equalTo(pick.contentView.mas_trailing).inset(AUTO_MARGIN(20));
//        make.top.mas_equalTo(pick.contentView.mas_top).offset(AUTO_MARGIN(20));
//    }];
//    [self.hourL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.mas_equalTo(self.hourBtn.mas_leading).inset(AUTO_MARGIN(12));
//        make.centerY.mas_equalTo(self.hourBtn.mas_centerY);
//    }];
}

- (void)setTimerCurrentTime:(NSString *)content {
    if ([BLETimerServer defaultBLEServer].selectCharacteristic != nil) {
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool setTimerCurrentTime:content] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
        
    }
}

- (void)hourCHangeOperate:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSData *data;
    if (sender.selected) {
        data = [ZCBluthDataTool timeTypeChange:0];
        self.hourL.text = NSLocalizedString(@"24小时制", nil);
        self.pick.hourType = 0;
    } else {
        self.hourL.text = NSLocalizedString(@"12小时制", nil);
        data = [ZCBluthDataTool timeTypeChange:1];
        self.pick.hourType = 1;
    }
    [self setTimerModeData:data];
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@[@{@"title":NSLocalizedString(@"正计时", nil), @"image":@"timer_up_count"},
                       @{@"title":NSLocalizedString(@"倒计时", nil), @"image":@"timer_down_count"},
                       @{@"title":NSLocalizedString(@"秒表", nil), @"image":@"timer_stopwatch_count"}
                    ],
                     @[@{@"title":NSLocalizedString(@"音量", nil), @"image":@"timer_volume_count"},
                       @{@"title":NSLocalizedString(@"亮度", nil), @"image":@"timer_light_count"},
                       @{@"title":NSLocalizedString(@"时间", nil), @"image":@"timer_clock_count"}
                    ],
        
        ];
    }
    return _dataArr;
}

- (UIButton *)hourBtn {
    if (!_hourBtn) {
        _hourBtn = [[UIButton alloc] init];
        [_hourBtn setImage:kIMAGE(@"timer_24hour") forState:UIControlStateSelected];
        [_hourBtn setImage:kIMAGE(@"timer_12hour") forState:UIControlStateNormal];
        [_hourBtn addTarget:self action:@selector(hourCHangeOperate:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hourBtn;
}

- (UILabel *)hourL {
    if (!_hourL) {
        _hourL = [self createSimpleLabelWithTitle:NSLocalizedString(@"12小时制", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    }
    return _hourL;
}

@end
