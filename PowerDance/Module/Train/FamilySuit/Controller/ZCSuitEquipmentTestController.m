//
//  ZCSuitEquipmentTestController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/8/1.
//

#import "ZCSuitEquipmentTestController.h"
#import "ZCBasePlayVideoView.h"
#import "ZCSuitEquipmentTestBaseView.h"
#import "ZCSuitEquipmentProcessView.h"
#import "ZCClassTrainOverView.h"

@interface ZCSuitEquipmentTestController ()

@property (nonatomic,strong) ZCBasePlayVideoView *playView;

@property (nonatomic,strong) UIScrollView *scView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) ZCSuitEquipmentTestBaseView *baseView;

@property (nonatomic,strong) ZCSuitEquipmentProcessView *processView;

@end

@implementation ZCSuitEquipmentTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubView];
    
    [self configureBaseInfo];
}

- (void)setupSubView {
    self.view.backgroundColor = [ZCConfigColor whiteColor];
    self.scView = [[UIScrollView alloc] init];
    if (@available(iOS 11.0, *)) {
        self.scView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets      = NO;
    }
    self.scView.showsVerticalScrollIndicator = NO;
    self.scView.bounces = NO;
    [self.view addSubview:self.scView];
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.contentView = [[UIView alloc] init];
    [self.scView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scView);
        make.width.mas_equalTo(self.scView);
    }];
        
    UIView *playView = [[ZCBasePlayVideoView alloc] init];
    playView.backgroundColor = [ZCConfigColor bgColor];
    [self.contentView addSubview:playView];
    [playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(490));
    }];
    self.playView = [[ZCBasePlayVideoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(490))];
    self.playView.player.smallControlView.hidden = YES;
    [playView addSubview:self.playView];
    
    self.baseView = [[ZCSuitEquipmentTestBaseView alloc] init];
    [self.contentView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(playView.mas_bottom).offset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(100));
    }];
    
    self.processView = [[ZCSuitEquipmentProcessView alloc] init];
    [playView addSubview:self.processView];
    [self.processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(playView);
        make.bottom.mas_equalTo(playView.mas_bottom).inset(AUTO_MARGIN(30));
    }];
    
    UIButton *confireBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"结束测试", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
    [self.view addSubview:confireBtn];
    [confireBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(AUTO_MARGIN(25));
    }];
    [confireBtn addTarget:self action:@selector(comfireOperate) forControlEvents:UIControlEventTouchUpInside];
    confireBtn.backgroundColor = [ZCConfigColor txtColor];
    [confireBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    
}

- (void)comfireOperate {
    ZCClassTrainOverView *overView = [[ZCClassTrainOverView alloc] init];
    [self.view addSubview:overView];
    [overView showAlertView];
    overView.titleStr = NSLocalizedString(@"测试还未完成，确定退出？", nil);
    overView.leftStr = NSLocalizedString(@"重新测试", nil);
    overView.rightStr = NSLocalizedString(@"直接退出", nil);
    kweakself(self);
    overView.handleTrainOperate = ^(NSInteger type) {
        if (type == 1) {
            NSLog(@"222");
            [HCRouter router:@"SuitTestTrainResult" params:self.params viewController:self animated:YES];
        } else {
            NSLog(@"111");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        }
    };
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.backStyle = UINavBackButtonColorStyleBack;
}

@end
