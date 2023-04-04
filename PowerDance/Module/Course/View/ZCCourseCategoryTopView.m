//
//  ZCCourseCategoryTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/10/31.
//

#import "ZCCourseCategoryTopView.h"
#import "ZCCourseFilterPartView.h"

@interface ZCCourseCategoryTopView ()

@property (nonatomic,strong) UIView *selectView;

@property (nonatomic,strong) UIView *targetView;

@property (nonatomic,strong) NSMutableArray *partArr;

@end

@implementation ZCCourseCategoryTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [ZCConfigColor whiteColor];
    
    self.targetView = [[UIView alloc] init];
    [self addSubview:self.targetView];
    [self.targetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(45));
        make.top.mas_equalTo(self);
    }];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"课程训练", nil) font:AUTO_MARGIN(13) bold:YES color:[ZCConfigColor txtColor]];
    [self.targetView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.targetView.mas_centerY);
        make.leading.mas_equalTo(self.targetView.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
    UIButton *opBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"清除", nil) font:AUTO_MARGIN(12) color:[ZCConfigColor subTxtColor]];
    [self.targetView addSubview:opBtn];
    [opBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.targetView.mas_trailing).inset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.targetView.mas_centerY);
    }];
    [opBtn setImage:kIMAGE(@"home_class_broom") forState:UIControlStateNormal];
    kweakself(self);
    [opBtn dn_layoutButtonEdgeInset:DNEdgeInsetStyleLeft space:2];
    [[opBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //x返回的就是被监听的button对象
        [weakself cleanBtnClick];
    }];
    
    self.partArr = [NSMutableArray array];
}
#pragma -- mark 清除标记
- (void)cleanBtnClick {
    if (self.cleanFilterDataOp) {
        self.cleanFilterDataOp();
    }
    for (ZCCourseFilterPartView *view in self.partArr) {
        [view resetViewStatus];
    }
}

- (void)createTrainViewSubViews:(UIView *)categoryView {
    for (int i = 0; i < self.categoryArr.count; i ++) {
        CGFloat topMargin = AUTO_MARGIN(10);
        ZCCourseFilterPartView *view = [[ZCCourseFilterPartView alloc] init];
        [categoryView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(categoryView);
            make.top.mas_equalTo(categoryView.mas_top).offset((AUTO_MARGIN(32)+topMargin)*i);
            make.height.mas_equalTo(AUTO_MARGIN(32));
        }];
        view.tag = i;
        NSDictionary *dic = self.categoryArr[i];
        view.dataDic = dic;
        
        [self.partArr addObject:view];
    }
}

- (void)setCategoryArr:(NSArray *)categoryArr {
    _categoryArr = categoryArr;
    UIView *categoryView = [[UIView alloc] init];
    categoryView.backgroundColor = UIColor.whiteColor;
    [self addSubview:categoryView];
    CGFloat height = (AUTO_MARGIN(32)+AUTO_MARGIN(10))*categoryArr.count + AUTO_MARGIN(15);
    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self.targetView.mas_bottom);
        make.height.mas_equalTo(height);
    }];
    
    [self createTrainViewSubViews:categoryView];
}

@end
