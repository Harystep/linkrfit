//
//  CFFFillUserInfoViewController.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import "CFFFillUserInfoViewController.h"
#import "CFFFillUserInfoViewStep1.h"
#import "CFFFillUserInfoViewStep2.h"


@interface CFFFillUserInfoViewController ()

@end

@implementation CFFFillUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubviews];
    self.pageIndex.enabled = NO;
}

#pragma mark - funcs

- (void)loadSubviews {
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.lblStep];
    [self.topView addSubview:self.lblMsg];
    [self.topView addSubview:self.lblSubMsg];
    [self.topView addSubview:self.pageIndex];
    [self.view addSubview:self.btnBottom];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(kCFF_FILL_USER_INFO_TOP_HEIGHT));
    }];
    
    [self.lblSubMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(15);
        make.right.equalTo(self.topView).offset(-45);
        make.bottom.equalTo(self.topView.mas_bottom).offset(-24);
    }];
    
    [self.lblMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(15);
        make.bottom.equalTo(self.lblSubMsg.mas_top).offset(-2);
        make.height.equalTo(@33);
    }];
    
    [self.lblStep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(15);
        make.bottom.equalTo(self.lblMsg.mas_top).offset(-10);
        make.height.equalTo(@33);
    }];
    
    [self.pageIndex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(0);        
        make.bottom.equalTo(self.topView.mas_bottom).offset(- 10);
    }];
    
    [self.btnBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(33);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(- 20);
        make.height.equalTo(@56);
    }];
}

#pragma mark - lazy load

- (UIImageView *)topView {
    if (!_topView) {
        _topView = [[UIImageView alloc] init];
        _topView.userInteractionEnabled = YES;
//        _topView.backgroundColor = kCFF_BG_COLOR_GREEN_COMMON;
        _topView.image = [UIImage imageNamed:@"input_user_info_bg"];
//        _topView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _topView;;
}

- (UILabel *)lblStep {
    if (!_lblStep) {
        _lblStep = [[UILabel alloc] init];
        _lblStep.textColor = [UIColor whiteColor];
        _lblStep.font = FONT_SYSTEM(24);
    }
    return _lblStep;
}

- (UILabel *)lblMsg {
    if (!_lblMsg) {
        _lblMsg = [[UILabel alloc] init];
        _lblMsg.textColor = [UIColor whiteColor];
        _lblMsg.font = FONT_SYSTEM(24);
    }
    return _lblMsg;
}

- (UILabel *)lblSubMsg {
    if (!_lblSubMsg) {
        _lblSubMsg = [[UILabel alloc] init];
        _lblSubMsg.textColor = [UIColor whiteColor];
        _lblSubMsg.numberOfLines = 0;
        _lblSubMsg.font = FONT_SYSTEM(12);
    }
    return _lblSubMsg;
}

- (UIButton *)btnBottom {
    if (!_btnBottom) {
        _btnBottom =[UIButton buttonWithType:UIButtonTypeCustom];
        _btnBottom.backgroundColor = [ZCConfigColor txtColor];
        [_btnBottom.titleLabel setFont:FONT_SYSTEM(18)];
        _btnBottom.layer.cornerRadius = 28;
        _btnBottom.clipsToBounds = YES;
    }
    return _btnBottom;
}

- (UIPageControl *)pageIndex {
    if (!_pageIndex) {
        _pageIndex = [[UIPageControl alloc] init];
        _pageIndex.numberOfPages = 0;
        _pageIndex.currentPage = 0;
        _pageIndex.hidden = YES;
    }
    return _pageIndex;
}

@end
