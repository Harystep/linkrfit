//
//  ZCCourseFilterPartView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/1.
//

#import "ZCCourseFilterPartView.h"

@interface ZCCourseFilterPartView ()

@property (nonatomic,strong) UIView *selectView;

@property (nonatomic,strong) UIView *targetView;

@end

@implementation ZCCourseFilterPartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    UIView *itemView = [[UIView alloc] init];
    [self addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(AUTO_MARGIN(24));
    }];
    [self createFunctionItems:itemView title:checkSafeContent(dataDic[@"name"]) items:[ZCDataTool convertEffectiveData:dataDic[@"children"]] type:self.tag+1];
}

- (void)createFunctionItems:(UIView *)view title:(NSString *)title items:(NSArray *)itemArr type:(NSInteger)type {
    UILabel *titleL = [self createSimpleLabelWithTitle:title font:AUTO_MARGIN(13) bold:NO color:[ZCConfigColor txtColor]];
    [view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.leading.mas_equalTo(view.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
    UIScrollView *scView = [[UIScrollView alloc] init];
    scView.showsHorizontalScrollIndicator = NO;
    [view addSubview:scView];
    [scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(titleL.mas_trailing).offset(AUTO_MARGIN(15));
        make.trailing.mas_equalTo(view.mas_trailing);
        make.top.bottom.mas_equalTo(view);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [scView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(scView);
        make.height.mas_equalTo(scView);
    }];
    
    [self createSubCategoryItems:contentView items:itemArr type:type];
}

- (void)createSubCategoryItems:(UIView *)view items:(NSArray *)itemArr type:(NSInteger)type{
    UIView *beforeView;
    for (int i = 0; i < itemArr.count; i ++) {
        UIView *titleView = [[UIView alloc] init];
        [view addSubview:titleView];
        if (i == 0) {
            if (itemArr.count == 1) {
                [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.mas_equalTo(view);
                    make.leading.mas_equalTo(view.mas_leading);
                    make.trailing.mas_equalTo(view.mas_trailing).inset(AUTO_MARGIN(10));
                }];
            } else {
                [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.mas_equalTo(view);
                    make.leading.mas_equalTo(view.mas_leading);
                }];
            }
        } else {
            [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(view);
                make.leading.mas_equalTo(beforeView.mas_trailing).offset(AUTO_MARGIN(10));
            }];
            if (i == itemArr.count - 1) {
                [titleView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.trailing.mas_equalTo(view.mas_trailing).inset(AUTO_MARGIN(10));
                }];
            }
        }
        NSDictionary *dic = itemArr[i];
        UILabel *titleL = [self createSimpleLabelWithTitle:dic[@"name"] font:12 bold:NO color:[ZCConfigColor txtColor]];
        [titleView addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(titleView).inset(AUTO_MARGIN(15));
            make.centerY.mas_equalTo(titleView.mas_centerY);
        }];
        
        titleView.backgroundColor = rgba(246, 246, 246, 1);
        [titleView setViewCornerRadiu:AUTO_MARGIN(12)];
        titleView.tag = type * 10 + i;
        beforeView = titleView;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOperate:)];
        [titleView addGestureRecognizer:tap];
    }
}

- (void)resetViewStatus {
    if (self.selectView) {
        [self setSelectViewStatus:self.selectView status:NO];
        self.selectView = nil;
    }
}

- (void)clickOperate:(UITapGestureRecognizer *)tap {
    if (self.selectView == tap.view) return;
    [self setSelectViewStatus:self.selectView status:NO];
    [self setSelectViewStatus:tap.view status:YES];
    self.selectView = tap.view;
    NSInteger tag = tap.view.tag;
    NSInteger secord = tag % 10;
    NSDictionary *itemDic = self.dataDic;
    NSArray *itemArr = itemDic[@"children"];
    NSDictionary *dic = itemArr[secord];
    NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [temDic setValue:checkSafeContent(dic[@"id"]) forKey:[NSString stringWithFormat:@"tag%tu", self.tag]];
    [temDic setValue:@(self.tag) forKey:@"index"];
    [tap.view routerWithEventName:@"tag" userInfo:temDic];
}

- (void)setSelectViewStatus:(UIView *)view status:(BOOL)flag {
    if (flag) {
        view.backgroundColor = [ZCConfigColor whiteColor];
        UILabel *lb = view.subviews[0];
        lb.textColor = [ZCConfigColor cyanColor];
        [view setViewBorderWithColor:1 color:[ZCConfigColor cyanColor]];
    } else {
        view.backgroundColor = rgba(246, 246, 246, 1);
        UILabel *lb = view.subviews[0];
        lb.textColor = [ZCConfigColor txtColor];
        [view setViewBorderWithColor:1 color:rgba(246, 246, 246, 1)];
    }
}

- (CGFloat)sizeContentWidth:(NSString *)content {
    CGFloat width = [content boundingRectWithSize:CGSizeMake(1000, AUTO_MARGIN(32)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    return width;
}

@end
