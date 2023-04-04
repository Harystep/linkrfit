//
//  ZCTimerModeView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/9.
//

#import "ZCTimerModeView.h"
#import "BLETimerServer.h"

@interface ZCTimerModeView ()

@property (nonatomic,strong) UILabel *statusL;

@property (nonatomic,strong) NSArray *modeArr;

@end

@implementation ZCTimerModeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [ZCConfigColor whiteColor];
        [self setViewCornerRadiu:10];
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.statusL = [self createSimpleLabelWithTitle:NSLocalizedString(@"计时器连接中···", nil) font:14 bold:NO color:rgba(43, 42, 51, 0.5)];
    [self addSubview:self.statusL];
    [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self).inset(AUTO_MARGIN(20));
    }];
    
    UIView *itemView = [[UIView alloc] init];
    [self addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.statusL.mas_bottom).offset(AUTO_MARGINY(20));
        make.bottom.mas_equalTo(self);
    }];
    [self setupItemViewSubviews:itemView];
}


- (void)setStatus:(NSInteger)status {
    _status = status;
    if (status == TimerConnectStatusSuccess) {
        self.statusL.text = NSLocalizedString(@"计时器已经连接，选择模式开始训练！", nil);
    } else {
        self.statusL.text = NSLocalizedString(@"计时器已断开连接", nil);
    }
}

- (void)setupItemViewSubviews:(UIView *)itemView {
    CGFloat width = (SCREEN_W - AUTO_MARGIN(80) - AUTO_MARGIN(22)) / 3.0;
    CGFloat height = AUTO_MARGIN(64);
    CGFloat margin = AUTO_MARGIN(11);
    for (int i = 0; i < self.modeArr.count; i ++) {
        ZCSimpleButton *item = [self createShadowButtonWithTitle:self.modeArr[i] font:14 color:[ZCConfigColor txtColor]];
        item.backgroundColor = rgba(246, 246, 246, 1);
        [item setViewCornerRadiu:6];
        [itemView addSubview:item];
        int row = i / 3;
        int col = i % 3;
        if (i == self.modeArr.count - 1) {
            item.frame = CGRectMake((width + margin)*col, (height + margin)*row, width*2+margin, height);
        } else {
            item.frame = CGRectMake((width + margin)*col, (height + margin)*row, width, height);
        }
        item.tag = i;
        [item addTarget:self action:@selector(itemOperate:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)itemOperate:(UIButton *)sender {
 
    if ([BLETimerServer defaultBLEServer].selectCharacteristic) {
        if ([self.modeArr[sender.tag] isEqualToString:@"WRC"]) {
            
            [HCRouter router:@"TimerWRCMode" params:@{@"data":self.modeArr[sender.tag]} viewController:self.superViewController animated:YES];
        } else {
            [HCRouter router:@"TimerAutoMode" params:@{@"data":self.modeArr[sender.tag]} viewController:self.superViewController animated:YES];
        }
    } else {
        [self makeToast:NSLocalizedString(@"请连接计时器", nil) duration:1.5 position:CSToastPositionCenter];
    }
}

- (NSArray *)modeArr {
    if (!_modeArr) {
        _modeArr = @[@"MIIT", @"HIIT", @"TABATA", @"MMA1", @"MMA2", @"FGB1", @"FGB2", @"WRC"];
    }
    return _modeArr;
}

@end
