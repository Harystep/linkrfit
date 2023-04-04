//
//  ZCTrainFinishController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/2.
//

#import "ZCTrainFinishController.h"
#import "ZCTrainFinishTimeView.h"

@interface ZCTrainFinishController ()

@property (nonatomic,strong) ZCTrainFinishTimeView *timeView;

@end

@implementation ZCTrainFinishController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    
    [self createSubviews];
}

- (void)createSubviews {
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:kIMAGE(@"train_finish_icon")];
    [self.view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(AUTO_MARGIN(65));
    }];

    UILabel *titleL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"基础减脂", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    [self.view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.mas_equalTo(self.view).inset(AUTO_MARGIN(38));
        make.top.mas_equalTo(icon.mas_bottom).offset(AUTO_MARGIN(56));
    }];
    
    self.timeView = [[ZCTrainFinishTimeView alloc] init];
    [self.view addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(25));
    }];
    self.timeView.energeL.text = [NSString stringWithFormat:@"%.1f", [self.params[@"energy"] doubleValue]];
    self.timeView.timeL.text = [NSString stringWithFormat:@"%@", self.params[@"time"]];
    self.timeView.groupL.text = [NSString stringWithFormat:@"%@", self.params[@"num"]];
    
    UIButton *nextBtn = [self.view createSimpleButtonWithTitle:NSLocalizedString(@"退出", nil) font:15 color:UIColor.whiteColor];
    nextBtn.backgroundColor = [ZCConfigColor txtColor];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(AUTO_MARGIN(98));
    }];
    [nextBtn addTarget:self action:@selector(nextOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)nextOperate {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"训练完成!", nil);
//    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.backBtn.hidden = YES;
}

- (void)backOperate {
    
}

@end
