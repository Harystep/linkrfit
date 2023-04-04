//
//  ZCBaseSlideController.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/9.
//

#import "ZCBaseSlideController.h"

@interface ZCBaseSlideController ()<JXCategoryViewDelegate, UIScrollViewDelegate>

@end

@implementation ZCBaseSlideController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupCategoryView];
    [self setupScrollView];
}


- (void)setupCategoryView {
    //
    self.categoryView = [[JXCategoryTitleView alloc]
                         initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_W, 44)];
    self.categoryView.titleColor = [ZCConfigColor subTxtColor];
    self.categoryView.titleSelectedColor = [ZCConfigColor txtColor];
    self.categoryView.titleSelectedFont = FONT_BOLD(24);
    self.categoryView.titleFont = FONT_BOLD(14);
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.delegate = self;
    self.categoryView.defaultSelectedIndex = 0;
    self.categoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
    self.categoryView.titles = @[@"", @""];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [ZCConfigColor txtColor];
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
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
    } else {
        self.automaticallyAdjustsScrollViewInsets      = NO;
    }
    
    [self.view insertSubview:self.scrollView belowSubview:self.categoryView];
    self.categoryView.contentScrollView = self.scrollView;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAV_BAR_HEIGHT);
        make.leading.trailing.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }
    }];
    [self.scrollView layoutIfNeeded];
}

@end
