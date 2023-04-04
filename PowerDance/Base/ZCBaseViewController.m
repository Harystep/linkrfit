//
//  ZCBaseViewController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/27.
//

#import "ZCBaseViewController.h"

@interface ZCBaseViewController ()

@property (nonatomic,strong) UIImageView *noneDataIv;
@property (nonatomic,strong) UILabel *noneDataTitleL;

@end

@implementation ZCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navBar = self.navigationController.navigationBar;
    self.navBar.hidden = YES;
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
        // Fallback on earlier versions
    };
    
    UIImageView *bgIcon = [[UIImageView alloc] initWithImage:kIMAGE(@"nav_bg_icon")];
    [self.view addSubview:bgIcon];
    bgIcon.hidden = YES;
    bgIcon.contentMode = UIViewContentModeScaleAspectFill;
    [bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(NAV_BAR_HEIGHT);
    }];
    self.navBgIcon = bgIcon;
}

- (void)setShowNavStatus:(BOOL)showNavStatus {
    _showNavStatus = showNavStatus;
    if (showNavStatus) {
        [self.view addSubview:self.naviView];
    }
}

- (void)backOperate {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleL.text = titleStr;
}

- (void)setBackStyle:(UINavBackButtonColorStyle)backStyle {
    if (backStyle) {
        [self.backBtn setImage:kIMAGE(@"back_btn_white") forState:UIControlStateNormal];
        self.titleL.textColor = UIColor.whiteColor;
    } else {
        [self.backBtn setImage:kIMAGE(@"back_btn_black") forState:UIControlStateNormal];
        self.titleL.textColor = [ZCConfigColor txtColor];
    }
}

- (void)setTitlePostionStyle:(UINavTitlePostionStyle)titlePostionStyle {
    _titlePostionStyle = titlePostionStyle;
    if (titlePostionStyle) {
        [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.naviView);
            make.centerY.mas_equalTo(self.backBtn);
        }];
    }
}

- (void)maskBtnClick {
    
}

- (void)configureNoneiewWithData:(NSArray *)dataArr {
    if (dataArr.count > 0) {
        self.noneView.hidden = YES;
    } else {
        self.signNoneView = YES;
        self.noneView.hidden = NO;
        self.noneDataIv.image = kIMAGE(@"base_none_data");
        self.noneDataTitleL.text = NSLocalizedString(@"暂无数据", nil);
    }
}

- (void)configureNoneiewWithData:(NSArray *)dataArr title:(NSDictionary *)dic {
    if (dataArr.count > 0) {
        self.noneView.hidden = YES;
    } else {
        self.signNoneView = YES;
        self.noneView.hidden = NO;
        self.noneDataIv.image = kIMAGE(dic[@"image"]);
        self.noneDataTitleL.text = dic[@"title"];
        
    }
}

- (void)setSignNoneView:(NSInteger)signNoneView {
    [self.view addSubview:self.noneView];
    [self.noneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
}

- (UIView *)naviView {
    if (!_naviView) {
        _naviView = [[UIView alloc] init];
        _naviView.frame = CGRectMake(0, 0, SCREEN_W, NAV_BAR_HEIGHT);
        [_naviView addSubview:self.backBtn];
        [_naviView addSubview:self.titleL];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_naviView.mas_bottom).inset(8);
            make.leading.mas_equalTo(_naviView.mas_leading).offset(AUTO_MARGIN(15));
            make.height.width.mas_equalTo(30);
        }];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(_naviView.mas_trailing).inset(AUTO_MARGIN(20));
            make.centerY.mas_equalTo(self.backBtn);
        }];
    }
    return _naviView;
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [self.view createSimpleLabelWithTitle:@"" font:20 bold:YES color:[ZCConfigColor txtColor]];
        
    }
    return _titleL;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:kIMAGE(@"back_btn_black") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backOperate) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)maskBtn {
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc] init];
        _maskBtn.backgroundColor = rgba(0, 0, 0, 0.4);
        _maskBtn.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [_maskBtn addTarget:self action:@selector(maskBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskBtn;
}

- (UIView *)noneView {
    if (!_noneView) {
        _noneView = [[UIView alloc] init];
        UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"base_none_data")];
        [_noneView addSubview:iconIv];
        _noneView.userInteractionEnabled = NO;
        self.noneDataIv = iconIv;
        _noneView.hidden = YES;
        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_noneView.mas_centerY);
            make.centerX.mas_equalTo(_noneView.mas_centerX);
        }];
        UILabel *lb = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"暂无数据", nil) font:12 bold:NO color:rgba(43, 42, 51, 0.5)];
        [lb setContentLineFeedStyle];
        lb.textAlignment = NSTextAlignmentCenter;
        [_noneView addSubview:lb];
        self.noneDataTitleL = lb;
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(_noneView).inset(AUTO_MARGIN(15));
            make.top.mas_equalTo(iconIv.mas_bottom).offset(AUTO_MARGIN(5));
        }];
    }
    return _noneView;
}

@end
