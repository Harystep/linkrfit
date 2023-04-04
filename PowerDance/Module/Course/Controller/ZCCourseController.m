//
//  ZCCourseController.m
//  PowerDance
//
//  Created by PC-N121 on 2022/10/31.
//

#import "ZCCourseController.h"
#import "ZCCourseCategoryView.h"
#import "ZCCourseEquipmentFilterContentView.h"

#define kTopHeight (STATUS_BAR_HEIGHT + 5)

@interface ZCCourseController ()<JXCategoryViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView        *scrollView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) UIButton *filterBtn;
@property (nonatomic,strong) ZCCourseEquipmentFilterContentView *filterView;

@end

@implementation ZCCourseController


- (void)viewDidLoad {
    [super viewDidLoad];        
    self.navBgIcon.hidden = NO;
    self.pageIndex = 0;
    NSArray *categoryArr = [ZCDataTool getEquipmentCategoryInfo];
    if (categoryArr.count > 0) {
        self.dataArr = categoryArr;
        [self configureSubviews];
    }
    
    [self getEquipmentCaregoryInfo];
}

#pragma -- mark 查询器械分类
- (void)getEquipmentCaregoryInfo {
    [ZCTrainManage queryCourseTagListInfoURL:@{} completeHandler:^(id  _Nonnull responseObj) {
        NSLog(@"tags:%@", responseObj);
        NSArray *tagsList = responseObj[@"data"][@"tagsList"];
        NSArray *apparatusList = responseObj[@"data"][@"apparatusList"];
        NSMutableArray *temArr = [NSMutableArray array];
        if ([ZCDevice currentDevice].isUsingChinese) {
            [temArr addObject:@{@"name":@"全部"}];
        } else {
            [temArr addObject:@{@"name":@"All"}];
        }
        [temArr addObjectsFromArray:apparatusList];
        [ZCDataTool saveEquipmentCategoryInfo:temArr];
        [ZCDataTool saveCourseCategoryInfo:tagsList];
        
        self.dataArr = temArr;
        [self configureSubviews];
    }];
}

- (void)setupSubviews {
        
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.categoryView.titles];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZCCourseCategoryView *classView = [[ZCCourseCategoryView alloc] init];
        if (@available(iOS 11.0, *)) {
            classView.frame = CGRectMake(SCREEN_W * idx, 44, SCREEN_W, CGRectGetHeight(self.scrollView.frame)-STATUS_BAR_HEIGHT);
        } else {
            classView.frame = CGRectMake(SCREEN_W * idx, 44, SCREEN_W, CGRectGetHeight(self.scrollView.frame)-STATUS_BAR_HEIGHT);
        }
        classView.index = idx;
        [self.scrollView addSubview:classView];
        if (idx == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kProductCategoryIndex0" object:@{@"id":@"0"}];
        }
    }];
    self.pageIndex = 0;
    self.categoryView.defaultSelectedIndex = 0;
}

- (void)setupCategoryView {
    if (self.categoryView) {
        [self.categoryView removeFromSuperview];
        [self.filterBtn removeFromSuperview];
    }
    
    self.categoryView = [[JXCategoryTitleView alloc]
                         initWithFrame:CGRectMake(0, kTopHeight, SCREEN_W - AUTO_MARGIN(50), 44)];
    
    self.categoryView.titleColor = [ZCConfigColor subTxtColor];
    self.categoryView.titleSelectedColor = [ZCConfigColor txtColor];
    self.categoryView.titleSelectedFont = FONT_BOLD(16);
    self.categoryView.titleFont = FONT_BOLD(13);
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.delegate = self;
    self.categoryView.defaultSelectedIndex = 0;
    self.categoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
    NSMutableArray *itemArr = [NSMutableArray array];
    for (int i = 0; i < self.dataArr.count; i ++) {
        NSDictionary *dic = self.dataArr[i];
//        if ([ZCDevice currentDevice].isUsingChinese) {
//            [itemArr addObject:dic[@"name"]];
//        } else {
//            [itemArr addObject:dic[@"enName"]];
//        }
        [itemArr addObject:dic[@"name"]];
    }
    self.categoryView.titles = itemArr;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [ZCConfigColor whiteColor];
    lineView.indicatorWidth = AUTO_MARGIN(5);
    self.categoryView.indicators = @[lineView];
    [self.view addSubview:self.categoryView];
    
    UIButton *filterBtn = [[UIButton alloc] init];
    self.filterBtn = filterBtn;
    [self.view addSubview:filterBtn];
    [filterBtn setImage:kIMAGE(@"home_shop_filter") forState:UIControlStateNormal];
    [filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.categoryView.mas_centerY);
        make.trailing.mas_equalTo(self.view.mas_trailing).inset(AUTO_MARGIN(10));
        make.width.height.mas_equalTo(AUTO_MARGIN(30));
    }];
    kweakself(self);
    [[filterBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakself showFilterContentView];
    }];
}

- (void)showFilterContentView {
    [MAINWINDOW addSubview:self.filterView];
    self.filterView.hidden = NO;
    if (self.filterView.dataArr.count == 0) {
        self.filterView.dataArr = self.dataArr;
    }
    self.filterView.selectIndex = self.pageIndex;
    kweakself(self);
    self.filterView.hideFilterViewOperate = ^{
        [weakself hideFilterView];
    };
    self.filterView.selectFilterItem = ^(id  _Nonnull value) {
        [weakself hideFilterView];
        [weakself selectFilterItem:value];
    };
}

- (void)selectFilterItem:(id)value {
    UIView *view = value;
    self.pageIndex = view.tag;
    [self.categoryView selectItemAtIndex:self.pageIndex];
}

- (void)hideFilterView {
    self.filterView.hidden = YES;
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
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }
    }];
    [self.scrollView layoutIfNeeded];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"index:%tu", index);
    self.pageIndex = index;
    NSDictionary *dic = self.dataArr[index];
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"kProductCategoryIndex%tu", index] object:@{@"id":checkSafeContent(dic[@"id"])}];
}

- (void)configureSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupCategoryView];
        [self setupScrollView];
        [self setupSubviews];
    });
}

- (ZCCourseEquipmentFilterContentView *)filterView {
    if (!_filterView) {
        _filterView = [[ZCCourseEquipmentFilterContentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    }
    return _filterView;
}

@end
