//
//  CFFProfileSimpleView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/28.
//

#import "ZCProfileSimpleView.h"

@interface ZCProfileSimpleView ()

@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSMutableArray *viewArr;

@end

@implementation ZCProfileSimpleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.viewArr = [NSMutableArray array];
    for (int i = 0; i < self.titleArr.count; i ++) {
        NSDictionary *dic = self.titleArr[i];
        [self createSubviewsWithTitle:dic[@"title"] index:i];
    }
}

- (void)createSubviewsWithTitle:(NSString *)title index:(NSInteger)index {
    UIView *contentView = [[UIView alloc] init];
    contentView.tag = index;
    [self addSubview:contentView];
    CGFloat topMargin = index * 50;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(topMargin);
        make.height.mas_equalTo(50);
        make.leading.trailing.mas_equalTo(self);
    }];
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.textColor = [ZCConfigColor txtColor];
    titleL.font = FONT_BOLD(AUTO_MARGIN(14));
    titleL.numberOfLines = 0;
    titleL.lineBreakMode = NSLineBreakByCharWrapping;
    [contentView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(contentView);
        make.leading.mas_equalTo(contentView.mas_leading).offset(15);
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(AUTO_MARGIN(60));
    }];
    titleL.text = title;
    
    UIImageView *arrowIv = [[UIImageView alloc] init];
    arrowIv.image = kIMAGE(@"profile_simple_arrow");
    [contentView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(contentView.mas_trailing).inset(12);
        make.centerY.mas_equalTo(titleL.mas_centerY);
    }];
    
    UILabel *contentL = [[UILabel alloc] init];
    [self.viewArr addObject:contentL];
    contentL.textColor = [ZCConfigColor subTxtColor];
    contentL.font = FONT_BOLD(15);
    [contentView addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleL.mas_centerY);
        make.trailing.mas_equalTo(arrowIv.mas_leading).inset(AUTO_MARGIN(8));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [contentView addGestureRecognizer:tap];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSString *birtday = checkSafeContent(dataDic[@"age"]);
    birtday = [birtday integerValue] == 0 ? @"":birtday;
    NSString *sex = dataDic[@"sex"];
    if ([ZCDataTool judgeContentValue:sex]) {
        sex = [sex integerValue] == 0?NSLocalizedString(@"男", nil):NSLocalizedString(@"女", nil);
    } else {
        sex = @"";
    }
    NSString *nickname = checkSafeContent(dataDic[@"nickName"]);
    NSArray *contentArr = @[nickname, sex, [NSString stringWithFormat:@"%@%@", birtday, NSLocalizedString(@"age_岁", nil)], [NSString stringWithFormat:@"%@cm", [ZCDataTool reviseString:checkSafeContent(dataDic[@"height"])]], [NSString stringWithFormat:@"%@kg", [ZCDataTool reviseString:checkSafeContent(dataDic[@"weight"])]]];
    for (int i = 0; i < self.titleArr.count; i ++) {
        UILabel *lb = self.viewArr[i];
        lb.text = contentArr[i];
    }
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    NSString *content = @"";
    if (index == 2) {
//        content = self.userInfoData.userInfo.birthday;
    } else {
        UILabel *lb = self.viewArr[index];
        content = lb.text;
    }
    [self routerWithEventName:[NSString stringWithFormat:@"%tu", index] userInfo:@{@"content":checkSafeContent(content)} block:^(id  _Nonnull result) {
        
    }];
    
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@{@"title":NSLocalizedString(@"昵称", nil), @"content":@""},
                      @{@"title":NSLocalizedString(@"性别", nil), @"content":@""},
                      @{@"title":NSLocalizedString(@"年龄", nil), @"content":@""},
        ];
    }
    return _titleArr;
}

@end
