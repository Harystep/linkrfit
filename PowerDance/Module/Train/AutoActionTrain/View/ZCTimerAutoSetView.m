//
//  ZCTimerAutoSetView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/29.
//

#import "ZCTimerAutoSetView.h"
#import "BLETimerServer.h"

@interface ZCTimerAutoSetView ()

@property (nonatomic,assign) NSInteger volume;
@property (nonatomic,assign) NSInteger light;
@property (nonatomic,assign) NSInteger downStatus;
@property (nonatomic,assign) NSInteger hourStatus;

@end

@implementation ZCTimerAutoSetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.volume = 1;
    self.light = 1;
    self.downStatus = [ZCBluthDataTool getTrainDownStatus];
    self.hourStatus = [ZCBluthDataTool getTrainHour12Status];
    
    [self configureViewShadowColor:self];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"计时器设置", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self).offset(AUTO_MARGIN(20));
    }];
    
    [self setupBaseSubviews:@[@"timer_volume_count", @"timer_light_count"]];
    
    UIView *sepView = [[UIView alloc] init];
    [self addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(36));
        make.width.mas_equalTo(AUTO_MARGIN(1));
        make.height.mas_equalTo(AUTO_MARGIN(17));
        make.centerX.mas_equalTo(self);
    }];
    sepView.backgroundColor = rgba(43, 42, 51, 0.2);
    for (int i = 0; i < 2; i ++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.tag = i;
        [self addSubview:itemView];
        if (i == 1) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(sepView.mas_trailing).offset(AUTO_MARGIN(10));
                make.centerY.mas_equalTo(sepView.mas_centerY);
                make.height.mas_equalTo(AUTO_MARGIN(40));
                make.trailing.mas_equalTo(self.mas_trailing);
            }];
        } else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
                make.centerY.mas_equalTo(sepView.mas_centerY);
                make.height.mas_equalTo(AUTO_MARGIN(40));
                make.trailing.mas_equalTo(sepView.mas_trailing);
            }];
        }
        [self setupItemSubviews:itemView];
    }
}

- (void)setupItemSubviews:(UIView *)itemView {
    NSString *title = @"";
    if (itemView.tag == 1) {
        title = NSLocalizedString(@"12小时制", nil);
    } else {
        title = NSLocalizedString(@"训练倒计时", nil);
    }
    UILabel *lb = [self createSimpleLabelWithTitle:title font:AUTO_MARGIN(14) bold:NO color:[ZCConfigColor txtColor]];
    [itemView addSubview:lb];
    
    UISwitch *btn = [[UISwitch alloc] init];
    [itemView addSubview:btn];
    btn.tag = itemView.tag;
    [btn addTarget:self action:@selector(switchOperate:) forControlEvents:UIControlEventValueChanged];
    if (itemView.tag == 1) {
        if (self.hourStatus) {
            btn.on = YES;
        }
    } else {
        if (self.downStatus) {
            btn.on = YES;
        }
    }
    if (itemView.tag == 1) {
        
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(itemView.mas_centerY);
            make.leading.mas_equalTo(itemView.mas_leading).offset(AUTO_MARGIN(15));
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(itemView.mas_trailing).inset(AUTO_MARGIN(20));
            make.centerY.mas_equalTo(lb.mas_centerY);
            make.height.mas_equalTo(AUTO_MARGIN(24));
        }];
        
    } else {
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(itemView.mas_centerY);
            make.leading.mas_equalTo(itemView.mas_leading);
        }];
            
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(itemView.mas_trailing).inset(AUTO_MARGIN(15));
            make.centerY.mas_equalTo(lb.mas_centerY);
            make.height.mas_equalTo(AUTO_MARGIN(24));
        }];
    }
}

- (void)switchOperate:(UISwitch *)switchBtn {
    if ([BLETimerServer defaultBLEServer].selectCharacteristic != nil) {
        if (switchBtn.on) {
            if (switchBtn.tag == 1) {
                [self setTimerModeData:[ZCBluthDataTool hoursSmall12Change]];
                [ZCBluthDataTool saveTrainHour12Status:YES];
            } else {
                [self setTimerModeData:[ZCBluthDataTool timerDelayOpen]];
                [ZCBluthDataTool saveTrainDownStatus:YES];
            }
        } else {
            if (switchBtn.tag == 1) {
                [self setTimerModeData:[ZCBluthDataTool hoursSmall24Change]];
                [ZCBluthDataTool saveTrainHour12Status:NO];
            } else {
                [self setTimerModeData:[ZCBluthDataTool timerDelayClose]];
                [ZCBluthDataTool saveTrainDownStatus:NO];
            }
        }
    } else {
        
        [self makeToast:NSLocalizedString(@"请连接计时器", nil) duration:1.5 position:CSToastPositionCenter];
    }
}


- (void)setupBaseSubviews:(NSArray *)items {
    CGFloat width = (SCREEN_W - AUTO_MARGIN(100)) / 2.0;
    CGFloat height = AUTO_MARGIN(50);
    CGFloat margin = AUTO_MARGIN(20);
    CGFloat topHeight = AUTO_MARGIN(54);
    CGFloat leadWidth = AUTO_MARGIN(20);
    for (int i = 0; i < items.count; i ++) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake((width + margin)*i + leadWidth, topHeight, width, height);
        [self addSubview:view];
        [self configureViewShadowColor:view];
        ZCSimpleButton *item = [self createShadowButtonWithTitle:@"" font:14 color:[ZCConfigColor txtColor]];
        [item setImage:kIMAGE(items[i]) forState:UIControlStateNormal];
        item.backgroundColor = rgba(235, 235, 235, 1);
        [item setViewCornerRadiu:6];
        [self addSubview:item];
        item.frame = CGRectMake((width + margin)*i + leadWidth, topHeight, width, height);
        item.tag = i;
        [item addTarget:self action:@selector(itemOperate:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)itemOperate:(UIButton *)sender {
    if ([BLETimerServer defaultBLEServer].selectCharacteristic != nil) {
        NSData *data;
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
                
            default:
                break;
        }
        [self setTimerModeData:data];
    } else {
        [self makeToast:NSLocalizedString(@"请连接计时器", nil) duration:1.5 position:CSToastPositionCenter];
    }
}

- (void)setTimerModeData:(NSData *)data {
    if ([BLETimerServer defaultBLEServer].selectCharacteristic != nil) {
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:data forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
        
    }
}

//- (void)configureViewShadowColor:(UIView *)targetView {
//    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(0,0,targetView.width,targetView.height);
//
//    view.layer.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0].CGColor;
//    view.layer.cornerRadius = 10;
//    view.layer.shadowColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
//    view.layer.shadowOffset = CGSizeMake(-6,-5);
//    view.layer.shadowOpacity = 1;
//    view.layer.shadowRadius = 10;
//    [targetView addSubview:view];
//
//    UIView *viewShadow1 = [[UIView alloc] init];
//    viewShadow1.frame = CGRectMake(0,0,targetView.width,targetView.height);
//
//    viewShadow1.layer.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0].CGColor;
//    viewShadow1.layer.cornerRadius = 10;
//    viewShadow1.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
//    viewShadow1.layer.shadowOffset = CGSizeMake(6,10);
//    viewShadow1.layer.shadowOpacity = 1;
//    viewShadow1.layer.shadowRadius = 10;
//
//    [targetView addSubview:viewShadow1];
//}
@end
