//
//  ZCTimerNormalView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/29.
//

#import "ZCTimerNormalView.h"
#import "BLETimerServer.h"

@interface ZCTimerNormalView ()

@property (nonatomic,strong) NSArray *modeArr;

@end

@implementation ZCTimerNormalView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self configureViewShadowColor:self];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"常规训练模式", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self).offset(AUTO_MARGIN(20));
    }];
    
    [self setupItemViewSubviews:self];
    
    [self setupBottomSubViews];
}

- (void)setupBottomSubViews {
    
    CGFloat topHeight = AUTO_MARGIN(124);
    CGFloat width = (SCREEN_W - AUTO_MARGIN(100)) / 2.0;
    CGFloat margin = AUTO_MARGIN(20);
    CGFloat height = AUTO_MARGIN(50);
    for (int i = 0; i < 2; i ++) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake((width + margin)*i + margin, topHeight, width, height);
        [self configureViewShadowColor:view];
        [self addSubview:view];
        if (i == 0) {
            [self setupBottomItemViewSubviews:view items:@[@"MMA1", @"MMA2"]];
        } else {
            [self setupBottomItemViewSubviews:view items:@[@"FGB1", @"FGB2"]];
        }
    }
}

- (void)setupBottomItemViewSubviews:(UIView *)itemView items:(NSArray *)items{
    UIView *sepView = [[UIView alloc] init];
    [itemView addSubview:sepView];
    sepView.backgroundColor = rgba(211, 211, 211, 1);
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(itemView.mas_centerX);
        make.centerY.mas_equalTo(itemView.mas_centerY);
        make.width.mas_equalTo(AUTO_MARGIN(1));
        make.height.mas_equalTo(AUTO_MARGIN(14));
    }];
    for (int i = 0; i < items.count; i ++) {
        ZCSimpleButton *item = [self createShadowButtonWithTitle:items[i] font:14 color:[ZCConfigColor txtColor]];
        item.backgroundColor = rgba(235, 235, 235, 1);
        [item setViewCornerRadiu:6];
        [itemView addSubview:item];
        if (i == 0) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.bottom.mas_equalTo(itemView);
                make.trailing.mas_equalTo(sepView.mas_leading);
            }];
        } else {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.top.bottom.mas_equalTo(itemView);
                make.leading.mas_equalTo(sepView.mas_trailing);
            }];
        }
        [item addTarget:self action:@selector(itemCombinationOperate:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)itemCombinationOperate:(UIButton *)sender {
    NSString *content = sender.titleLabel.text;
    //TimerAutoMode
    if ([BLETimerServer defaultBLEServer].selectCharacteristic) {
        [HCRouter router:@"TimerAutoMode" params:@{@"data":content} viewController:self.superViewController animated:YES];
    } else {
        [self makeToast:NSLocalizedString(@"请连接计时器", nil) duration:1.5 position:CSToastPositionCenter];
    }
}

- (void)setupItemViewSubviews:(UIView *)itemView {
    CGFloat width = (SCREEN_W - AUTO_MARGIN(80) - AUTO_MARGIN(22)) / 3.0;
    CGFloat height = AUTO_MARGIN(50);
    CGFloat margin = AUTO_MARGIN(11);
    CGFloat topHeight = AUTO_MARGIN(54);
    CGFloat leadWidth = AUTO_MARGIN(20);
    for (int i = 0; i < self.modeArr.count; i ++) {
        int row = i / 3;
        int col = i % 3;
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake((width + margin)*col + leadWidth, (height + margin)*row + topHeight, width, height);
        [itemView addSubview:view];
        [self configureViewShadowColor:view];
        ZCSimpleButton *item = [self createShadowButtonWithTitle:self.modeArr[i] font:14 color:[ZCConfigColor txtColor]];
        item.backgroundColor = rgba(235, 235, 235, 1);
        [item setViewCornerRadiu:6];
        [itemView addSubview:item];
        item.frame = CGRectMake((width + margin)*col + leadWidth, (height + margin)*row + topHeight, width, height);
        item.tag = i;
        [item addTarget:self action:@selector(itemOperate:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)itemOperate:(UIButton *)sender {
 
    if ([BLETimerServer defaultBLEServer].selectCharacteristic) {
        [HCRouter router:@"TimerAutoMode" params:@{@"data":self.modeArr[sender.tag]} viewController:self.superViewController animated:YES];
    } else {
        [self makeToast:NSLocalizedString(@"请连接计时器", nil) duration:1.5 position:CSToastPositionCenter];
    }
}

//- (void)configureViewShadowColor:(UIView *)targetView {
//    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(0, 0, targetView.width, targetView.height);
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
        // @"MMA1", @"MMA2", @"FGB1", @"FGB2", @"WRC"
        _modeArr = @[@"MIIT", @"HIIT", @"TABATA"];
    }
    return _modeArr;
}

@end
