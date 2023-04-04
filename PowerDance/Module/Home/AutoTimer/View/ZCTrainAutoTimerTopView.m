//
//  ZCTrainAutoTimerTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/18.
//

#import "ZCTrainAutoTimerTopView.h"

@interface ZCTrainAutoTimerTopView ()

@property (nonatomic,strong) NSArray *titleArr;

@end

@implementation ZCTrainAutoTimerTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"在线计时训练", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(30));
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(20));
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(lb.mas_bottom);
        make.height.mas_equalTo(AUTO_MARGIN(185));
    }];
    [self createContentViewSubviews:contentView];
    
    UIImageView *bottomIv = [[UIImageView alloc] init];
    bottomIv.image = kIMAGE(@"timer_normal_iocn");
    [bottomIv setViewCornerRadiu:10];
    [self addSubview:bottomIv];
    [bottomIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.top.mas_equalTo(contentView.mas_bottom);
    }];
    bottomIv.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [bottomIv addGestureRecognizer:tap];
    
    UIButton *lbBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"倒计时/正计时秒表", nil) font:12 color:[ZCConfigColor whiteColor]];
    lbBtn.userInteractionEnabled = NO;
    [bottomIv addSubview:lbBtn];
    [lbBtn setImage:kIMAGE(@"train_arrow") forState:UIControlStateNormal];
    [lbBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleRight space:0];
    [lbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomIv.mas_centerY);
        make.trailing.mas_equalTo(bottomIv.mas_trailing).inset(AUTO_MARGIN(15));
    }];
    
    UILabel *subL = [self createSimpleLabelWithTitle:NSLocalizedString(@"计时器自定义训练", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(20));
        make.top.mas_equalTo(bottomIv.mas_bottom).offset(AUTO_MARGIN(30));
    }];
}
#pragma -- mark 点击正/倒计时
- (void)tapClick {
    [HCRouter router:@"AutoTimerTab" params:@{} viewController:self.superViewController animated:YES];
}

- (void)createContentViewSubviews:(UIView *)contentView {
    CGFloat marginX = (SCREEN_W - AUTO_MARGIN(40) - AUTO_MARGIN(200)) / 3.0;
    CGFloat marginY = AUTO_MARGIN(20);
    CGFloat width = AUTO_MARGIN(50);
    CGFloat height = AUTO_MARGIN(62);
    for (int i = 0; i < self.titleArr.count; i ++) {
        int col = i % 4;
        int row = i / 4;
        NSDictionary *dic = self.titleArr[i];
        UIButton *btn = [self createSimpleButtonWithTitle:dic[@"title"] font:12 color:[ZCConfigColor subTxtColor]];
        [contentView addSubview:btn];
        btn.frame = CGRectMake((width + marginX) * col, marginY + (marginY + height)*row, width, height);
        [btn setImage:kIMAGE(dic[@"image"]) forState:UIControlStateNormal];
        [btn dn_layoutButtonEdgeInset:DNEdgeInsetStyleTop space:6];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnOperate:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)btnOperate:(UIButton *)sender {
    if (sender.tag == 7) {//WRC
        [HCRouter router:@"AutoWRCTrain" params:@{} viewController:self.superViewController animated:YES];
    } else {
        NSString *content = sender.titleLabel.text;       
        [HCRouter router:@"AutoTimer" params:@{@"data":content} viewController:self.superViewController animated:YES];
    }
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[
            @{@"title":@"HIIT", @"image":@"train_HIIT"},
            @{@"title":@"MIIT", @"image":@"train_MIIT"},
            @{@"title":@"TABATA", @"image":@"train_TABATA"},
            @{@"title":@"MMA1", @"image":@"train_MMA1"},
            @{@"title":@"MMA2", @"image":@"train_MMA2"},
            @{@"title":@"FGB1", @"image":@"train_FGB1"},
            @{@"title":@"FGB2", @"image":@"train_FGB2"},
            @{@"title":@"WRC", @"image":@"train_WRC"},
        ];
    }
    return _titleArr;
}

@end
