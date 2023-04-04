//
//  ZCClassPlayBottomView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/25.
//

#import "ZCClassPlayBottomView.h"

@interface ZCClassPlayBottomView ()


@end

@implementation ZCClassPlayBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    self.bigView = [[ZCBaseCircleView alloc] initWithFrame:CGRectMake((SCREEN_W - AUTO_MARGINY(160))/2.0, AUTO_MARGINY(30), AUTO_MARGINY(160), AUTO_MARGINY(160)) trackWidth:AUTO_MARGINY(10)];
    [bottomView addSubview:self.bigView];
    self.bigView.progressBgColor = UIColor.groupTableViewBackgroundColor;
    self.bigView.progressColor = rgba(250, 106, 2, 1);
        
    self.smallView = [[ZCBaseCircleView alloc] initWithFrame:CGRectMake((SCREEN_W - AUTO_MARGINY(140))/2.0, AUTO_MARGINY(40), AUTO_MARGINY(140), AUTO_MARGINY(140)) trackWidth:AUTO_MARGINY(10)];
    [bottomView addSubview:self.smallView];
    self.smallView.progressBgColor = rgba(213, 213, 213, 1);
    self.smallView.progressColor = rgba(250, 106, 2, 1);
    
    self.trainPreBtn = [[UIButton alloc] init];
    [bottomView addSubview:self.trainPreBtn];
    [self.trainPreBtn setImage:kIMAGE(@"train_pre") forState:UIControlStateNormal];
    [self.trainPreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bigView.mas_centerY);
        make.trailing.mas_equalTo(self.bigView.mas_leading).inset(AUTO_MARGIN(55));
    }];
    self.trainPreBtn.enabled = NO;
    self.trainPreBtn.tag = 0;
    [self.trainPreBtn addTarget:self action:@selector(trainOrderOperate:) forControlEvents:UIControlEventTouchUpInside];
    
    self.trainNextBtn = [[UIButton alloc] init];
    [bottomView addSubview:self.trainNextBtn];
    [self.trainNextBtn setImage:kIMAGE(@"train_next") forState:UIControlStateNormal];
    [self.trainNextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bigView.mas_centerY);
        make.leading.mas_equalTo(self.bigView.mas_trailing).inset(AUTO_MARGIN(55));
    }];
    self.trainNextBtn.tag = 1;
    [self.trainNextBtn addTarget:self action:@selector(trainOrderOperate:) forControlEvents:UIControlEventTouchUpInside];
    
    self.playBtn = [[UIButton alloc] init];
    [bottomView addSubview:self.playBtn];
    [self.playBtn configureButtonImage:@"train_play_stop" selImage:@"train_play_stop_sel"];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bigView.mas_centerY);
        make.centerX.mas_equalTo(self.bigView.mas_centerX);
        make.height.width.mas_equalTo(AUTO_MARGIN(60));
    }];
    [self.playBtn addTarget:self action:@selector(playOperate:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)playOperate:(UIButton *)sender {
//    sender.selected = !sender.selected;
    [sender routerWithEventName:@"play" userInfo:@{@"status":@(1)}];
}

- (void)trainOrderOperate:(UIButton *)sender {
    [sender routerWithEventName:@"order" userInfo:@{@"status":@(sender.tag)}];
}

@end
