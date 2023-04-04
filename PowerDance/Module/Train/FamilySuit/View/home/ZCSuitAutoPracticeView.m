//
//  ZCSuitAutoPracticeView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/7/28.
//

#import "ZCSuitAutoPracticeView.h"
#import "ZCSuitSelectDeviceView.h"
#import "ZCSuitOperateView.h"
#import "ZCSuitNumView.h"
#import "BLESuitServer.h"

@interface ZCSuitAutoPracticeView ()

@property (nonatomic,strong) ZCSuitSelectDeviceView *deviceView;

@property (nonatomic,strong) ZCSuitNumView *firstView;

@property (nonatomic,strong) ZCSuitNumView *secondView;

@property (nonatomic,strong) ZCSuitNumView *thirdView;

@property (nonatomic,strong) UIView *detailView;

@end

@implementation ZCSuitAutoPracticeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [ZCConfigColor bgColor];
    UILabel *descL = [self createSimpleLabelWithTitle:@"" font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor txtColor]];
    [self addSubview:descL];
    [descL setAttributeStringContent:NSLocalizedString(@"Suit_Train_Desc", nil) space:8 font:FONT_SYSTEM(12) alignment:NSTextAlignmentLeft];
    [descL setContentLineFeedStyle];
    [descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    UIView *detailView = [[UIView alloc] init];
    self.detailView = detailView;
    [self addSubview:detailView];
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(325));
        make.top.mas_equalTo(descL.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    detailView.backgroundColor = [ZCConfigColor whiteColor];
    [detailView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    self.deviceView = [[ZCSuitSelectDeviceView alloc] init];
    [detailView addSubview:self.deviceView];
    [self.deviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(detailView);
    }];    
    self.deviceView.dataArr = @[];
    
    UIButton *confireBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"立即开始训练", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
    [self addSubview:confireBtn];
    [confireBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(44));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(29));
    }];
    [confireBtn addTarget:self action:@selector(comfireOperate) forControlEvents:UIControlEventTouchUpInside];
    confireBtn.backgroundColor = [ZCConfigColor txtColor];
    [confireBtn setViewCornerRadiu:AUTO_MARGIN(22)];
    
    ZCSuitOperateView *operateView = [[ZCSuitOperateView alloc] init];
    [detailView addSubview:operateView];
    [operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(detailView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.deviceView.mas_bottom).offset(AUTO_MARGIN(5));
        make.height.mas_equalTo(AUTO_MARGIN(30));
    }];    
    
    self.thirdView = [[ZCSuitNumView alloc] init];
    [detailView addSubview:self.thirdView];
    self.thirdView.backgroundColor = [ZCConfigColor bgColor];
    [self.thirdView setViewCornerRadiu:AUTO_MARGIN(10)];
    [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(detailView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(operateView.mas_bottom).offset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(130));
    }];
    
    self.secondView = [[ZCSuitNumView alloc] init];
    [detailView addSubview:self.secondView];
    self.secondView.backgroundColor = [ZCConfigColor bgColor];
    [self.secondView setViewCornerRadiu:AUTO_MARGIN(10)];
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(detailView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(operateView.mas_bottom).offset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(130));
    }];
    
    self.firstView = [[ZCSuitNumView alloc] init];
    [detailView addSubview:self.firstView];
    self.firstView.backgroundColor = [ZCConfigColor bgColor];
    [self.firstView setViewCornerRadiu:AUTO_MARGIN(10)];
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(detailView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(operateView.mas_bottom).offset(AUTO_MARGIN(10));
        make.height.mas_equalTo(AUTO_MARGIN(130));
    }];
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:@"move"]) {
        NSInteger index = [userInfo[@"index"] integerValue];
        [self.deviceView resetStatusView:index];
    } else if ([eventName isEqualToString:@"brind"]) {
        NSDictionary *dic = userInfo;
        if ([dic[@"title"] isEqualToString:NSLocalizedString(@"健腹轮", nil)]) {
            [self.detailView bringSubviewToFront:self.firstView];
        } else if ([dic[@"title"] isEqualToString:NSLocalizedString(@"跳绳", nil)]) {
            [self.detailView bringSubviewToFront:self.secondView];
        } else {
            [self.detailView bringSubviewToFront:self.thirdView];
        }
    }
}

- (void)comfireOperate {
    if (self.state == 1) {
        NSMutableArray *dataArr = [NSMutableArray array];
        for (int i = 0; i < self.deviceView.itemArr.count; i ++) {
            UIView *itemView = self.deviceView.viewArr[i];
            ZCSuitNumView *numView = [self bringViewFromIndex:itemView.tag];
            NSInteger count = [numView.numView.numF.text integerValue];
            NSInteger time = [numView.timeView.numF.text integerValue];
            if (count > 0 || time > 0) {
                NSDictionary *dataDic = @{@"mode":[NSString stringWithFormat:@"%tu", itemView.tag+1], @"num":[NSString stringWithFormat:@"%tu", count], @"time":@(time)};
                [dataArr addObject:dataDic];
            }
        }
        NSLog(@"data:%@", dataArr);
        if (dataArr.count > 0) {
            [HCRouter router:@"SuitTrain" params:@{@"data":dataArr} viewController:self.superViewController animated:YES];
        } else {
            [MAINWINDOW makeToast:NSLocalizedString(@"请设置训练数据", nil) duration:2.0 position:CSToastPositionCenter];
        }
    } else {
        [MAINWINDOW makeToast:NSLocalizedString(@"断开连接", nil) duration:2.0 position:CSToastPositionCenter];
    }
}

- (ZCSuitNumView *)bringViewFromIndex:(NSInteger)index {
    if (index == 0) {
        return self.firstView;
    } else if (index == 1) {
        return self.secondView;
    } else {
        return self.thirdView;
    }
}

@end
