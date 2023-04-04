//
//  CFFBaseViewController.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/22.
//

#import "CFFBaseViewController.h"

@interface CFFBaseViewController ()

@property (nonatomic,strong) UILabel *lblNavTitle;
@property (nonatomic,strong) UIView *vNavLeft;
@property (nonatomic,strong) UIView *vNavRight;
@property (nonatomic,strong) UIButton *btnLeft;

@end

@implementation CFFBaseViewController

#pragma mark : init

- (instancetype) initWithParams:(NSDictionary * _Nullable)dic {
    self = [super init];
    if (self) {
        self.params = dic;
    }
    return self;
}

#pragma mark : life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //隐藏掉系统的navigationBar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (!self.enableIQKeyboardManager) {
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (!self.enableIQKeyboardManager) {
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //设置可以滑动返回，如果要禁用滑动返回，在子类里设置为no即可
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.enableIQKeyboardManager = YES;
    
    @weakify(self);
    [[RACObserve(self, title) ignore:nil] subscribeNext:^(NSString *title) {
        @strongify(self);
        self.lblNavTitle.text = title;
    }];
    
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
        // Fallback on earlier versions
    };
}

#pragma mark : override

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark : func

- (void)setNeedNavBar:(BOOL)needNavBar {
    _customNavBar.hidden = NO;
    if (needNavBar && ![self.view.subviews containsObject:_customNavBar]) {
        //此时需要把navigationbar添加上去
        [self addNavBar];
    }else {
        _customNavBar.hidden = YES;
    }
    _needNavBar = needNavBar;
}

- (void)setBackButtonStyle:(CFFBackButtonStyle)backButtonStyle {
    _backButtonStyle = backButtonStyle;
    if (backButtonStyle != CFFBackButtonStyleNone && ![self.vNavLeft.subviews containsObject:self.btnLeft]) {
        [self addBackButton];
    }
}

- (void)addNavBar {
    [self.view addSubview:self.customNavBar];
    [self.customNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kCFF_STATUS_BAR_HEIGHT);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(kCFF_NAVIGATION_BAR_HEIGHT));
    }];
    
    [self.customNavBar addSubview:self.lblNavTitle];
    [self.customNavBar addSubview:self.vNavLeft];
    [self.customNavBar addSubview:self.vNavRight];
    CGFloat offset = 80;
    [self.lblNavTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.customNavBar);
        make.left.equalTo(self.customNavBar).offset(offset);
        make.right.equalTo(self.customNavBar).offset(-offset);
    }];
    [self.vNavLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.customNavBar);
        make.left.equalTo(self.customNavBar);
        make.width.equalTo(@(offset));
    }];
    [self.vNavRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.customNavBar);
        make.right.equalTo(self.customNavBar);
        make.width.equalTo(@(offset));
    }];
}

- (void)addBackButton {
    [self.vNavLeft addSubview:self.btnLeft];
    [_btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vNavLeft).offset(0);
        make.width.mas_equalTo(kCFF_NAVIGATION_BAR_HEIGHT);
        make.height.mas_equalTo(kCFF_NAVIGATION_BAR_HEIGHT);
        make.centerY.equalTo(self.vNavLeft);
    }];
    if (self.backButtonStyle == CFFBackButtonStyleBlack) {
        [self.btnLeft setImage:[UIImage imageNamed:@"back_btn_black"] forState:UIControlStateNormal];
    }else if (self.backButtonStyle == CFFBackButtonStyleWhite) {
        [self.btnLeft setImage:[UIImage imageNamed:@"back_btn_white"] forState:UIControlStateNormal];
    }
}

#pragma mark : lazy load

- (UIView *)customNavBar {
    if (!_customNavBar) {
        _customNavBar = [[UIView alloc] init];
        _customNavBar.backgroundColor = [UIColor yellowColor];
    }
    return _customNavBar;
}

- (UILabel *)lblNavTitle {
    if (!_lblNavTitle) {
        _lblNavTitle = [[UILabel alloc] init];
        _lblNavTitle.backgroundColor = [UIColor whiteColor];
        _lblNavTitle.textAlignment = NSTextAlignmentCenter;
        _lblNavTitle.text = @" ";
        _lblNavTitle.font = FONT_SYSTEM(18);
    }
    return _lblNavTitle;;
}

- (UIView *)vNavLeft {
    if (!_vNavLeft) {
        _vNavLeft = [[UIView alloc] init];
        _vNavLeft.backgroundColor = [UIColor whiteColor];
    }
    return _vNavLeft;
}

- (UIView *)vNavRight {
    if (!_vNavRight) {
        _vNavRight = [[UIView alloc] init];
        _vNavRight.backgroundColor = [UIColor whiteColor];
    }
    return _vNavRight;
}

- (UIButton *)btnLeft{
    if (!_btnLeft) {
        _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnLeft addTarget:self action:@selector(backOperate) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLeft;
}

- (void)backOperate {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CFFNoneDataView *)noneView {
    if (!_noneView) {
        _noneView = [[CFFNoneDataView alloc] init];
        _noneView.hidden = YES;
    }
    return _noneView;
}

@end
