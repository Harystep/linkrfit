//
//  ZCAutoPracticeTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/28.
//

#import "ZCAutoPracticeTopView.h"
#import "ZCAutoTimerTabController.h"

@interface ZCAutoPracticeTopView ()

@property (nonatomic,strong) NSArray *modeArr;

@end

@implementation ZCAutoPracticeTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor =  UIColor.groupTableViewBackgroundColor;
//    kColorHex(@"#F6F6F6");
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGINY(15));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    [contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"在线计时器", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(contentView.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    UIView *itemView = [[UIView alloc] init];
    [contentView addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(16));
        make.bottom.mas_equalTo(self);
    }];
    [self setupItemViewSubviews:itemView];
}

- (void)setupItemViewSubviews:(UIView *)itemView {
    CGFloat width = (SCREEN_W - AUTO_MARGIN(80) - AUTO_MARGIN(22)) / 3.0;
    CGFloat height = AUTO_MARGIN(50);
    CGFloat margin = AUTO_MARGIN(11);
    for (int i = 0; i < self.modeArr.count; i ++) {
        ZCSimpleButton *item = [self createShadowButtonWithTitle:self.modeArr[i] font:14 color:[ZCConfigColor txtColor]];
        item.backgroundColor = rgba(173, 173, 173, 0.2);
        [item setViewCornerRadiu:6];
        [itemView addSubview:item];
        int row = i / 3;
        int col = i % 3;
        if (i == 7) {
            item.frame = CGRectMake((width + margin)*col, (height + margin)*row, width*2+margin, height);
        } else if (i > 7) {
            item.frame = CGRectMake((width + margin)*(i-8), (height + margin)*3, width, height);
        } else {
            item.frame = CGRectMake((width + margin)*col, (height + margin)*row, width, height);
        }
        item.tag = i;
        [item addTarget:self action:@selector(itemOperate:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)itemOperate:(UIButton *)sender {
 
    if ([self.modeArr[sender.tag] isEqualToString:@"WRC"]) {
        [HCRouter router:@"AutoWRCTrain" params:@{} viewController:self.superViewController animated:YES];
    } else {
        if (sender.tag > 7) {
            ZCAutoTimerTabController *tab = [[ZCAutoTimerTabController alloc] init];
            tab.selectedIndex = sender.tag - 8;
            [self.superViewController.navigationController pushViewController:tab animated:YES];
        } else {
            NSString *content = sender.titleLabel.text;
            [HCRouter router:@"AutoTimer" params:@{@"data":content} viewController:self.superViewController animated:YES];
        }
    }
    
}

- (NSArray *)modeArr {
    if (!_modeArr) {
        _modeArr = @[@"MIIT", @"HIIT", @"TABATA", @"MMA1", @"MMA2", @"FGB1", @"FGB2", @"WRC", NSLocalizedString(@"正计时", nil),  NSLocalizedString(@"倒计时", nil), NSLocalizedString(@"秒表", nil)];
    }
    return _modeArr;
}

@end
