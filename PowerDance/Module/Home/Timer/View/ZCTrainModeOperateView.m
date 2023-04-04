//
//  ZCTrainModeOperateView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/10.
//

#import "ZCTrainModeOperateView.h"
#import "BLETimerServer.h"

@interface ZCTrainModeOperateView ()

@property (nonatomic,strong) NSArray *typeArr;

@end

@implementation ZCTrainModeOperateView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    CGFloat width = (SCREEN_W - AUTO_MARGIN(40))/3.0;
    for (int i = 0; i < self.typeArr.count; i ++) {
        NSDictionary *dic = self.typeArr[i];
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading).offset(width*i);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(AUTO_MARGIN(70));
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        ZCSimpleButton *item = [self createShadowButtonWithTitle:dic[@"title"] font:14 color:[ZCConfigColor txtColor]];
        [contentView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(contentView);
            make.centerX.mas_equalTo(contentView.mas_centerX);
            make.width.mas_equalTo(AUTO_MARGIN(70));
        }];
        [item setImage:kIMAGE(dic[@"image"]) forState:UIControlStateNormal];
        [item setViewCornerRadiu:AUTO_MARGIN(35)];
        [item dn_layoutButtonEdgeInset:DNEdgeInsetStyleTop space:10];
        item.tag = i;
        [item addTarget:self action:@selector(itemOperate:) forControlEvents:UIControlEventTouchUpInside];

    }
}

- (void)itemOperate:(UIButton *)sender {
    if ([BLETimerServer defaultBLEServer].selectCharacteristic) {
        [sender routerWithEventName:[NSString stringWithFormat:@"%tu", sender.tag]];
    } else {
        [self makeToast:NSLocalizedString(@"请连接计时器", nil) duration:1.5 position:CSToastPositionCenter];
    }
}

- (NSArray *)typeArr {
    if (!_typeArr) {
        _typeArr = @[@{@"title":NSLocalizedString(@"退出", nil), @"image":@"train_sport_exit"},
                     @{@"title":NSLocalizedString(@"暂停", nil), @"image":@"train_sport_stop"},
                     @{@"title":NSLocalizedString(@"开始", nil), @"image":@"train_mode_start"}
                    ];
    };
    return _typeArr;
}
@end
