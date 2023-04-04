//
//  ZCCourseEquipmentFilterView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/11/1.
//

#import "ZCCourseEquipmentFilterView.h"
#import "Masonry.h"
#import "ZCSportGroupModel.h"

#pragma mark - 小格子
@interface ZCContentLabel : UILabel

@property (nonatomic) UIEdgeInsets insets;

@end

@implementation ZCContentLabel
- (instancetype)init {
    self = [super init];
    if (self) {
        _insets = UIEdgeInsetsMake(6, 18, 6, 18);
        self.font = FONT_SYSTEM(12);
        self.textColor = [ZCConfigColor txtColor];
        self.backgroundColor = [ZCConfigColor bgColor];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _insets)];
}
- (CGSize)intrinsicContentSize {
    CGSize superContentSize = [super intrinsicContentSize];
    CGFloat width = superContentSize.width + _insets.left + _insets.right;
    CGFloat heigth = superContentSize.height + _insets.top + _insets.bottom;
    return CGSizeMake(width, heigth);
}
@end


#pragma mark - 视图
@interface ZCCourseEquipmentFilterView ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic,strong) ZCContentLabel *selectL;

@property (nonatomic,strong) NSMutableArray *viewArr;

@end

@implementation ZCCourseEquipmentFilterView

- (instancetype)init {
    self = [super init];
    if (self) {
        _spacingRow = 20;
        _spacingColumn = 20;
        _containerView = [[UIView alloc] init];
        [self addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setTagsArr:(NSArray *)tagsArr {
    _tagsArr = tagsArr;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSpacingRow:(CGFloat)spacingRow {
    _spacingRow = spacingRow;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSpacingColumn:(CGFloat)spacingColumn {
    _spacingColumn = spacingColumn;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

///开始布局格子
- (void)layoutChildItems {
    self.viewArr = [NSMutableArray array];
    //先把原来的数据移除掉
    for (UIView *v in self.containerView.subviews) {
        [v removeFromSuperview];
    }
    
//    self.containerView.backgroundColor = [UIColor brownColor];
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@(_contentInset));
    }];
    
    //宽度
    CGFloat containerWidth = self.containerView.frame.size.width;
    //如果宽度小于等于0,表示这个视图还没有完成约束,拿不到宽度,也就无法继续做下一步的小格子宽度排布计算
    if (containerWidth <= 0) {
        NSLog(@"❗️❗️❗️❗️ YXTagsView 视图没有宽度,暂不能进行排布!");
        return;
    }
    //累计宽度
    CGFloat maxX = 0;
    //记录上一个格子
    ZCContentLabel *beforeLabel;
    //记录上一个底部约束
    __block MASConstraint *bottomCons = nil;
    
    //添加新的数据
    for (NSInteger i = 0; i < self.tagsArr.count; i ++) {
        NSDictionary *dict = self.tagsArr[i];
        ZCContentLabel *label = [[ZCContentLabel alloc] init];
        label.tag = i;
        label.text = checkSafeContent(dict[@"name"]);
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLabel:)];
        [label addGestureRecognizer:tap];
        
        [_containerView addSubview:label];
        //先做一下约束,然后拿到宽度
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(_containerView);
        }];
        [label setNeedsLayout];
        [label layoutIfNeeded];
        
        [self.viewArr addObject:label];
        
        CGFloat labelWidth = label.frame.size.width;
        CGFloat labelHeight = label.frame.size.height;
        [label setViewCornerRadiu:labelHeight / 2.0];
        if ((maxX + labelWidth + _spacingRow) > containerWidth) { //换到下一行的第一个
            [bottomCons uninstall];
            [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_containerView);
                make.top.equalTo(beforeLabel.mas_bottom).offset(_spacingColumn);
                bottomCons = make.bottom.equalTo(_containerView);
            }];
            maxX = labelWidth;
        } else { //继续在这一行
            if (beforeLabel) { //同一行 第2,3,4...个
                [bottomCons uninstall];
                [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(beforeLabel.mas_right).offset(_spacingRow);
                    make.top.equalTo(beforeLabel);
                    bottomCons = make.bottom.equalTo(_containerView);
                }];
                maxX += labelWidth + _spacingRow;
            } else { //第一行第一个
                [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_containerView);
                    make.top.equalTo(_containerView);
                    bottomCons = make.bottom.equalTo(_containerView);
                }];
                maxX = labelWidth;
            }
        }
        
        beforeLabel = label;
    }
}

- (void)clickLabel:(UITapGestureRecognizer *)tap {
    if (self.selectL == tap.view) return;
    if (self.clickLabelResule) {
        ZCContentLabel *lb = (ZCContentLabel *)tap.view;
        self.clickLabelResule(lb);
        [self configureNormalView:lb];
    }
}

- (void)configureNormalView:(ZCContentLabel *)lb {
    [self setContentView:lb status:YES];
    [self setContentView:self.selectL status:NO];
    self.selectL = lb;
}

- (void)setContentView:(UILabel *)lb status:(BOOL)status {
    if (status) {
        lb.backgroundColor = [ZCConfigColor whiteColor];
        lb.textColor = [ZCConfigColor cyanColor];
        [lb setViewBorderWithColor:1 color:[ZCConfigColor cyanColor]];
    } else {
        lb.backgroundColor = [ZCConfigColor bgColor];
        lb.textColor = [ZCConfigColor txtColor];
        [lb setViewBorderWithColor:1 color:[ZCConfigColor bgColor]];
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    ZCContentLabel *lb = self.viewArr[selectIndex];
    if (self.selectL != nil) {
        if (self.selectL.tag == selectIndex) return;
        [self configureNormalView:lb];
    } else {
        [self setContentView:lb status:YES];        
        self.selectL = lb;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutChildItems];
}


@end
