//
//  ZCTrainController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/27.
//

#import "ZCShopController.h"
#import "ZCShopCategoryView.h"
#import "ZCTrainEquipmentListView.h"

#define kTopHeight (STATUS_BAR_HEIGHT+10)

@interface ZCShopController ()<JXCategoryViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView        *scrollView;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation ZCShopController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 0;
    self.view.backgroundColor = [ZCConfigColor whiteColor];
    self.navBgIcon.hidden = NO;
    [self configureShopCategoryList];
}

- (void)setupSubviews {
        
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.categoryView.titles];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            ZCShopCategoryView *shopView = [[ZCShopCategoryView alloc] init];
            shopView.frame = CGRectMake(SCREEN_W * idx, 44, SCREEN_W, CGRectGetHeight(self.scrollView.frame)-STATUS_BAR_HEIGHT);
            shopView.index = idx;
            [self.scrollView addSubview:shopView];
        } else {
            ZCTrainEquipmentListView *listView = [[ZCTrainEquipmentListView alloc] init];
            listView.frame = CGRectMake(SCREEN_W * idx, 44, SCREEN_W, CGRectGetHeight(self.scrollView.frame)-STATUS_BAR_HEIGHT);
            [self.scrollView addSubview:listView];
        }
    }];
    self.pageIndex = 0;
    self.categoryView.defaultSelectedIndex = 0;
}

- (void)setupCategoryView {
    if (self.categoryView) {
        [self.categoryView removeFromSuperview];
    }
    
    self.categoryView = [[JXCategoryTitleView alloc]
                         initWithFrame:CGRectMake(0, kTopHeight, SCREEN_W, 44)];
    self.categoryView.titleColor = [ZCConfigColor point6TxtColor];
    self.categoryView.titleSelectedColor = [ZCConfigColor txtColor];
    self.categoryView.titleSelectedFont = FONT_BOLD(16);
    self.categoryView.titleFont = FONT_BOLD(14);
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.delegate = self;
    self.categoryView.defaultSelectedIndex = 0;
    self.categoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
    self.categoryView.titles = @[NSLocalizedString(@"发现", nil), NSLocalizedString(@"分类", nil)];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [ZCConfigColor cyanColor];
    lineView.indicatorWidth = AUTO_MARGIN(18);
    self.categoryView.indicators = @[lineView];
    [self.view addSubview:self.categoryView];
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
        make.bottom.mas_equalTo(self.view.mas_bottom).inset(TAB_BAR_HEIGHT);
    }];
    
    [self.scrollView layoutIfNeeded];
}


- (void)configureShopCategoryList {
    
    [self setupCategoryView];
    [self setupScrollView];
    [self setupSubviews];
    
}

@end
