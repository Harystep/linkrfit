//
//  ZCFamilySuitController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/7/28.
//

#import "ZCFamilySuitController.h"
#import "ZCSuitAutoPracticeView.h"
#import "ZCSuitFollowView.h"
#import "BLESuitServer.h"

#define kTopHeight (NAV_BAR_HEIGHT + AUTO_MARGIN(10))

@interface ZCFamilySuitController ()<JXCategoryViewDelegate, UIScrollViewDelegate, BLESuitServerDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView        *scrollView;
@property (nonatomic, strong) NSArray *titleVcArr;
@property (nonatomic,strong) BLESuitServer *defaultBLEServer;
@property (nonatomic,strong) UILabel *statusL;
@property (nonatomic,strong) ZCSuitAutoPracticeView *practiceView;

@end

@implementation ZCFamilySuitController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBaseInfo];
    
    [self setupCategoryView];
    [self setupScrollView];
    [self setupSubviews];
        
    self.defaultBLEServer = [BLESuitServer defaultBLEServer];
    self.defaultBLEServer.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.defaultBLEServer startScan];
    });
    
}

- (void)didConnect:(PeriperalInfo *)info {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusL.text = NSLocalizedString(@"连接成功", nil);
        self.practiceView.state = 1;                
    });
   
}

- (void)didDisconnect {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusL.text = NSLocalizedString(@"断开连接", nil);
        self.practiceView.state = 0;
    });
}

- (void)didStopScan {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusL.text = NSLocalizedString(@"断开连接", nil);
        self.practiceView.state = 0;
    });
}

- (void)didFoundPeripheral {
    NSLog(@"发现外设");
}

- (void)setupSubviews {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.categoryView.titles];
    kweakself(self);
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        Class targetClass = NSClassFromString(self.titleVcArr[idx]);
//        UIView *extenView = [[targetClass alloc] init];
        ZCSuitAutoPracticeView *extenView = [[ZCSuitAutoPracticeView alloc] init];
        weakself.practiceView = extenView;
        extenView.frame = CGRectMake(SCREEN_W * idx, 44, SCREEN_W, CGRectGetHeight(self.scrollView.frame) - 44);
        [self.scrollView addSubview:extenView];
        
    }];
    self.categoryView.defaultSelectedIndex = 0;
}

- (void)setupCategoryView {
    CGFloat width = 0;
    if ([ZCDevice currentDevice].isUsingChinese) {
        width = AUTO_MARGIN(60);
    } else {
        width = AUTO_MARGIN(140);
    }
    self.categoryView = [[JXCategoryTitleView alloc]
                         initWithFrame:CGRectMake(0, kTopHeight, width, 44)];
    self.categoryView.titleColor = [ZCConfigColor subTxtColor];
    self.categoryView.titleSelectedColor = [ZCConfigColor txtColor];
    self.categoryView.titleSelectedFont = FONT_BOLD(20);
    self.categoryView.titleFont = FONT_BOLD(14);
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.delegate = self;
    self.categoryView.defaultSelectedIndex = 0;
    self.categoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
    self.categoryView.titles = @[NSLocalizedString(@"自由练", nil)];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [ZCConfigColor txtColor];
    lineView.hidden = YES;
    lineView.indicatorWidth = AUTO_MARGIN(25);
    self.categoryView.indicators = @[lineView];
    [self.view addSubview:self.categoryView];
      
    self.statusL = [self.view createSimpleLabelWithTitle:NSLocalizedString(@"连接中···", nil) font:14 bold:0 color:[ZCConfigColor subTxtColor]];
    [self.view addSubview:self.statusL];
    [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.categoryView.mas_centerY);
        make.trailing.mas_equalTo(self.view.mas_trailing).inset(AUTO_MARGIN(20));
    }];
}

- (void)setupScrollView {
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = CGSizeMake(SCREEN_W * self.categoryView.titles.count, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view insertSubview:self.scrollView belowSubview:self.categoryView];
    self.categoryView.contentScrollView = self.scrollView;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.leading.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.scrollView.backgroundColor = UIColor.clearColor;
    [self.scrollView layoutIfNeeded];
        
}

- (void)configureBaseInfo {
    self.showNavStatus = YES;
    self.titleStr = NSLocalizedString(@"家庭智能健身套装", nil);
    self.titlePostionStyle = UINavTitlePostionStyleRight;
    self.view.backgroundColor = [ZCConfigColor whiteColor];
}

- (void)dealloc {
    [[BLESuitServer defaultBLEServer] stopScan];
    [[BLESuitServer defaultBLEServer] disConnect];
//    [BLESuitServer defaultBLEServer].selectPeripheral = nil;
}

- (NSArray *)titleVcArr {
    if (!_titleVcArr) {
        
        _titleVcArr = @[@"ZCSuitAutoPracticeView", @"ZCSuitFollowView"];
    }
    return _titleVcArr;
}


@end
