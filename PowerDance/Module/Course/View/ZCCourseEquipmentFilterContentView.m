//
//  ZCCourseEquipmentFilterContentView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/1.
//

#import "ZCCourseEquipmentFilterContentView.h"
#import "ZCCourseEquipmentFilterView.h"

@interface ZCCourseEquipmentFilterContentView ()

@property (nonatomic,strong) ZCCourseEquipmentFilterView *filterView;

@property (nonatomic,strong) UIButton *maskBtn;

@end

@implementation ZCCourseEquipmentFilterContentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.maskBtn = [[UIButton alloc] init];
    [self addSubview:self.maskBtn];
    [self.maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    self.maskBtn.backgroundColor = [ZCConfigColor txtColor];
    self.maskBtn.alpha = 0.4;
    kweakself(self);
    [[self.maskBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakself hideMaskBtn];
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [ZCConfigColor whiteColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
    }];
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"全部器械", nil) font:AUTO_MARGIN(15) bold:YES color:[ZCConfigColor txtColor]];
    [contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(contentView.mas_top).offset(STATUS_H);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *opBtn = [[UIButton alloc] init];
    [contentView addSubview:opBtn];
    [opBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleL.mas_centerY);
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(AUTO_MARGIN(5));
        make.width.height.mas_equalTo(AUTO_MARGIN(40));
    }];
    [opBtn setImage:kIMAGE(@"home_course_del") forState:UIControlStateNormal];
    [[opBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakself hideMaskBtn];
    }];
    
    self.filterView = [[ZCCourseEquipmentFilterView alloc] init];
    [contentView addSubview:self.filterView];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(titleL.mas_bottom).offset(AUTO_MARGIN(10));
        make.bottom.mas_equalTo(contentView.mas_bottom).inset(AUTO_MARGIN(30));
    }];
    self.filterView.backgroundColor = [ZCConfigColor whiteColor];
    self.filterView.clickLabelResule = ^(id  _Nonnull value) {
        [weakself saveSelectFilterItem:value];
    };
}

- (void)saveSelectFilterItem:(id)value {
    if (self.selectFilterItem) {
        self.selectFilterItem(value);
    }
}

- (void)hideMaskBtn {
    if (self.hideFilterViewOperate) {
        self.hideFilterViewOperate();
    }
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    self.filterView.tagsArr = dataArr;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    self.filterView.selectIndex = selectIndex;
}

@end
