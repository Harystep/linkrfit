//
//  ZCTimerEditView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/29.
//

#import "ZCTimerEditView.h"
#import "BLETimerServer.h"
#import "ZCAlertTimePickView.h"

@interface ZCTimerEditView ()

@property (nonatomic,strong) NSArray *modeArr;

@property (nonatomic,strong) ZCAlertTimePickView *pick;

@end

@implementation ZCTimerEditView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self configureViewShadowColor:self];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"可编辑训练模式", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self).offset(AUTO_MARGIN(20));
    }];
    
    UIView *wrcView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W-AUTO_MARGIN(120), AUTO_MARGIN(54), AUTO_MARGIN(60), AUTO_MARGIN(120))];
    [self addSubview:wrcView];
    [wrcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(54));
        make.width.mas_equalTo(AUTO_MARGIN(60));
    }];
    [self configureViewShadowColor:wrcView];
    
    ZCSimpleButton *item = [self createShadowButtonWithTitle:@"WRC" font:14 color:[ZCConfigColor txtColor]];
    item.tag = 5;
    item.backgroundColor = rgba(235, 235, 235, 1);
    [item setViewCornerRadiu:6];
    [wrcView addSubview:item];
    [item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(wrcView);
    }];
    [item addTarget:self action:@selector(itemOperate:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *itemView = [[UIView alloc] init];
    [self addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lb.mas_bottom);
        make.leading.mas_equalTo(self.mas_leading);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.trailing.mas_equalTo(wrcView.mas_leading);
    }];
    [self setupItemViewSubviews:itemView];
}

- (void)setupItemViewSubviews:(UIView *)itemView {
    CGFloat width = (SCREEN_W - AUTO_MARGIN(180)) / 2.0;
    CGFloat height = AUTO_MARGIN(50);
    CGFloat margin = AUTO_MARGIN(20);
    CGFloat topHeight = AUTO_MARGIN(18);
    CGFloat leadWidth = AUTO_MARGIN(20);
    for (int i = 0; i < self.modeArr.count; i ++) {
        int row = i / 2;
        int col = i % 2;
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake((width + margin)*col + leadWidth, (height + margin)*row + topHeight, width, height);
        [itemView addSubview:view];
        [self configureViewShadowColor:view];
        NSDictionary *dic = self.modeArr[i];
        ZCSimpleButton *item = [self createShadowButtonWithTitle:dic[@"title"] font:14 color:[ZCConfigColor txtColor]];
        [item setImage:kIMAGE(dic[@"image"]) forState:UIControlStateNormal];
        [item dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:4];
        item.backgroundColor = rgba(235, 235, 235, 1);
        [item setViewCornerRadiu:6];
        [itemView addSubview:item];
        item.frame = CGRectMake((width + margin)*col + leadWidth, (height + margin)*row + topHeight, width, height);
        item.tag = i;
        [item addTarget:self action:@selector(itemOperate:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)itemOperate:(UIButton *)sender {
    if ([BLETimerServer defaultBLEServer].selectCharacteristic != nil) {
        
        if (sender.tag == 5) {
            [HCRouter router:@"TimerWRCMode" params:@{@"data":@"WRC"} viewController:self.superViewController animated:YES];
        } else {
            switch (sender.tag) {
                case 0:
                    
                    [HCRouter router:@"TimerUp" params:@{} viewController:self.superViewController animated:YES];
                    break;
                case 1:
                    
                    [HCRouter router:@"TimerStopWatch" params:@{} viewController:self.superViewController animated:YES];
                    break;
                case 2:
                    [HCRouter router:@"TimerDown" params:@{} viewController:self.superViewController animated:YES];
                    break;
                case 3:
                    [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool getClockMode] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
                    [self timeOperate];
                    break;
                default:
                    break;
            }
        }
    } else {
        [self makeToast:NSLocalizedString(@"请连接计时器", nil) duration:1.5 position:CSToastPositionCenter];
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
}

- (void)setTimerCurrentTime:(NSString *)content {
    if ([BLETimerServer defaultBLEServer].selectCharacteristic != nil) {
        [[BLETimerServer defaultBLEServer].selectPeripheral writeValue:[ZCBluthDataTool setTimerCurrentTime:content] forCharacteristic:[BLETimerServer defaultBLEServer].selectCharacteristic type:CBCharacteristicWriteWithResponse];
        
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

- (NSArray *)modeArr {
    if (!_modeArr) {
        _modeArr = @[
            @{@"title":NSLocalizedString(@"正计时", nil), @"image":@"timer_smart_up"},
            @{@"title":NSLocalizedString(@"秒表", nil), @"image":@"timer_smart_stop-w"},
            @{@"title":NSLocalizedString(@"倒计时", nil), @"image":@"timer_smart_down"},
            @{@"title":NSLocalizedString(@"时间", nil), @"image":@"timer_smart_clock"},
        ];
    }
    return _modeArr;
}

@end
