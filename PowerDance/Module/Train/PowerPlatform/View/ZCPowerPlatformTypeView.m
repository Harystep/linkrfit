//
//  ZCPowerPlatformTypeView.m
//  PowerDance
//
//  Created by oneStep on 2023/4/11.
//

#import "ZCPowerPlatformTypeView.h"

@interface ZCPowerPlatformTypeView ()

@property (nonatomic,strong) UILabel *selectView;

@property (nonatomic,strong) UIButton *targetSetBtn;//目标设置

@property (nonatomic,strong) UILabel *unitL;

@property (nonatomic,strong) UILabel *consumeL;//消耗

@property (nonatomic,strong) UILabel *totalL;//实际拉力

@property (nonatomic,strong) UILabel *eruptL;//爆发力

@property (nonatomic,strong) UIButton *startBtn;

@property (nonatomic,strong) UIButton *stopBtn;

@end

@implementation ZCPowerPlatformTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
        self.backgroundColor = [ZCConfigColor whiteColor];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *typeView = [[UIView alloc] init];
    [self addSubview:typeView];
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(80);
        make.leading.trailing.mas_equalTo(self).inset(20);
        make.top.mas_equalTo(self.mas_top).offset(16);
    }];
    NSArray *titleArr = @[NSLocalizedString(@"常规模式", nil), NSLocalizedString(@"向心模式", nil), NSLocalizedString(@"离心模式", nil), NSLocalizedString(@"等速模式", nil), NSLocalizedString(@"弹力绳模式", nil), NSLocalizedString(@"划船模式", nil)];
    CGFloat height = 35;
    CGFloat width = (SCREEN_W - 40 - 20)/3;
    for (int i = 0; i < titleArr.count; i ++) {
        int row = i/3;
        int col = i%3;
        UILabel *itemL = [self createSimpleLabelWithTitle:titleArr[i] font:12 bold:NO color:[ZCConfigColor txtColor]];
        [typeView addSubview:itemL];
        [itemL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(typeView.mas_leading).offset((width+10)*col);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.top.mas_equalTo(typeView.mas_top).offset((height+10)*row);
        }];
        itemL.text = titleArr[i];
        itemL.textAlignment = NSTextAlignmentCenter;
        itemL.userInteractionEnabled = YES;
        [itemL setViewCornerRadiu:17.5];
        itemL.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTypeClick:)];
        [itemL addGestureRecognizer:tap];
        if (i == 0) {
            self.selectView = itemL;
            [self setupAttributeStatus:itemL status:YES];
        } else {
            [self setupAttributeStatus:itemL status:NO];
        }
    }
    
    self.targetSetBtn = [self createSimpleButtonWithTitle:@"0" font:57 color:[ZCConfigColor txtColor]];
    [self addSubview:self.targetSetBtn];
    [self.targetSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(typeView.mas_bottom).offset(36);
        make.height.mas_equalTo(45);
    }];
    self.targetSetBtn.titleLabel.font = FONT_BOLD(57);
    
    self.unitL = [self createSimpleLabelWithTitle:@"kg" font:11 bold:NO color:[ZCConfigColor subTxtColor]];
    [self addSubview:self.unitL];
    [self.unitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.targetSetBtn.mas_centerY);
        make.leading.mas_equalTo(self.targetSetBtn.mas_trailing).offset(10);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(20);
        make.top.mas_equalTo(self.targetSetBtn.mas_bottom).offset(30);
        make.height.mas_equalTo(1);
    }];
    lineView.backgroundColor = [ZCConfigColor bgColor];
    
    UIView *dataView = [[UIView alloc] init];
    [self addSubview:dataView];
    [dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(lineView.mas_bottom).offset(30);
        make.height.mas_equalTo(40);
    }];
    
    NSArray *dataArr = @[NSLocalizedString(@"实际拉力(kg)", nil), NSLocalizedString(@"燃烧卡路里(千卡)", nil), NSLocalizedString(@"爆发力(kg)", nil)];
    CGFloat dataWidth = SCREEN_W/3.0;
    for (int i = 0; i < dataArr.count; i ++) {
        UILabel *lb = [self createSimpleLabelWithTitle:dataArr[i] font:11 bold:NO color:[ZCConfigColor subTxtColor]];
        [dataView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(dataView.mas_leading).offset(dataWidth*i);
            make.width.mas_equalTo(dataWidth);
            make.bottom.mas_equalTo(dataView.mas_bottom);
        }];
        lb.textAlignment = NSTextAlignmentCenter;
        UILabel *contentL = [self createSimpleLabelWithTitle:@"0" font:24 bold:YES color:[ZCConfigColor txtColor]];
        [dataView addSubview:contentL];
        [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(lb.mas_centerX);
            make.top.mas_equalTo(dataView.mas_top);
            make.width.mas_equalTo(dataWidth);
        }];
        contentL.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            self.totalL = contentL;
        } else if (i == 1) {
            self.consumeL = contentL;
        } else {
            self.eruptL = contentL;
        }
    }
    
    self.startBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"开始运动", nil) font:14 color:[ZCConfigColor whiteColor]];
    [self addSubview:self.startBtn];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(dataView.mas_bottom).offset(30);
        make.width.mas_equalTo(185);
        make.height.mas_equalTo(40);        
    }];
    [self.startBtn layoutIfNeeded];
    [self configureLeftToRightViewColorGradient:self.startBtn width:185 height:40 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:20];
    [self.startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.stopBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"暂停运动", nil) font:14 color:rgba(138, 205, 215, 1)];
    [self addSubview:self.stopBtn];
    [self.stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(dataView.mas_bottom).offset(30);
        make.width.mas_equalTo(185);
        make.height.mas_equalTo(40);        
    }];
    [self.stopBtn setViewBorderWithColor:1 color:rgba(138, 205, 215, 1)];
    [self.stopBtn setViewCornerRadiu:20];
    self.stopBtn.hidden = YES;
    [self.stopBtn addTarget:self action:@selector(stopBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)stopBtnClick {
    self.startBtn.hidden = NO;
    self.stopBtn.hidden = YES;
}
- (void)startBtnClick {
    self.startBtn.hidden = YES;
    self.stopBtn.hidden = NO;
}

- (void)itemTypeClick:(UITapGestureRecognizer *)tap {
    if (self.selectView == tap.view)return;
    UILabel *lb = (UILabel *)tap.view;
    [self setupAttributeStatus:self.selectView status:NO];
    [self setupAttributeStatus:lb status:YES];
    self.selectView = lb;
}

- (void)setupAttributeStatus:(UILabel *)targetView status:(BOOL)status {
    if (status) {
        targetView.backgroundColor = [ZCConfigColor whiteColor];
        [targetView setViewBorderWithColor:1 color:rgba(138, 205, 215, 1)];
        targetView.textColor = rgba(138, 205, 215, 1);
    } else {
        targetView.backgroundColor = [ZCConfigColor bgColor];
        [targetView setViewBorderWithColor:1 color:[ZCConfigColor whiteColor]];
        targetView.textColor = [ZCConfigColor txtColor];
    }
}

@end
