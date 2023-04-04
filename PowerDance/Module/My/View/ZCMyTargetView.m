//
//  ZCMyTargetView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/5/13.
//

#import "ZCMyTargetView.h"

@interface ZCMyTargetView ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) NSMutableArray *viewsArr;

@end

@implementation ZCMyTargetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    UIView *bgView = [[UIView alloc] init];
    self.viewsArr = [NSMutableArray array];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.mas_top).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(280));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [bgView setViewCornerRadiu:AUTO_MARGIN(20)];
    
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_target_set_bg")];
    [bgView addSubview:iconIv];
    [iconIv setViewContentMode:UIViewContentModeScaleAspectFill];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(bgView);
    }];
    
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"login_icon")];
    [bgView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_top).offset(AUTO_MARGIN(15));
        make.leading.mas_equalTo(bgView.mas_leading).offset(AUTO_MARGIN(20));
        make.height.width.mas_equalTo(AUTO_MARGIN(40));
    }];
    [self.iconIv setViewCornerRadiu:AUTO_MARGIN(20)];
    self.iconIv.contentMode = UIViewContentModeScaleAspectFill;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent([ZCDataTool getUserPortraint])] placeholderImage:kIMAGE(@"login_icon")];

    self.nameL = [self createSimpleLabelWithTitle:[NSString stringWithFormat:@"%@,%@", @"Hi", checkSafeContent(kUserInfo.phone)] font:AUTO_MARGIN(12) bold:NO color:rgba(94, 73, 62, 1)];
    [bgView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconIv.mas_top).offset(AUTO_MARGIN(2));
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(10));
    }];

    UILabel *subL = [self createSimpleLabelWithTitle:NSLocalizedString(@"定制个性计划", nil) font:AUTO_MARGIN(14) bold:YES color:rgba(62, 80, 94, 1)];
    [bgView addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(10));
        make.top.mas_equalTo(self.nameL.mas_bottom).offset(AUTO_MARGIN(8));
    }];

    UIView *targetView = [[UIView alloc] init];
    [bgView addSubview:targetView];
    [targetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(bgView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    targetView.backgroundColor = rgba(255, 255, 255, 0.42);
    [targetView setViewCornerRadiu:10];

    UILabel *targetL = [self createSimpleLabelWithTitle:NSLocalizedString(@"你的健身目标是什么？", nil) font:AUTO_MARGIN(14) bold:NO color:rgba(160, 99, 57, 1)];
    [targetView addSubview:targetL];
    [targetL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(targetView).offset(AUTO_MARGIN(15));
    }];

    [self setupTargetViewSubviews:targetView];
}

- (void)setupTargetViewSubviews:(UIView *)targetView {
    CGFloat width = (SCREEN_W - AUTO_MARGIN(110));
    for (int i = 0; i < 2; i ++) {
        NSString *title;
        if (i == 0) {
            title = NSLocalizedString(@"增肌", nil);
        } else {
            title = NSLocalizedString(@"减脂", nil);
        }
        ZCSimpleButton *btn = [self createShadowButtonWithTitle:title font:AUTO_MARGIN(14) color:rgba(160, 99, 57, 1)];
        [targetView addSubview:btn];
        btn.tag = i;
        btn.frame = CGRectMake(AUTO_MARGIN(15), AUTO_MARGIN(50) + AUTO_MARGIN(65)*i, width, AUTO_MARGIN(50));
        [btn setViewCornerRadiu:AUTO_MARGIN(25)];
        btn.backgroundColor = [ZCConfigColor whiteColor];
        [btn addTarget:self action:@selector(btnOperate:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewsArr addObject:btn];
    }
    
    NSArray *dataArr = [ZCDataTool getTrainTargetInfo];
    [self setupSubviewsValue:dataArr];
}

- (void)btnOperate:(UIButton *)sender {
    NSArray *dataArr = [ZCDataTool getTrainTargetInfo];
    if (dataArr.count > 1) {
        NSDictionary *dic = dataArr[sender.tag];
        [ZCProfileManage updateUserInfoOperate:@{@"tagsId":checkSafeContent(dic[@"courseTagsId"])} completeHandler:^(id  _Nonnull responseObj) {           
            self.superViewController.callBackBlock(@"");
            [self.superViewController.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)setupSubviewsValue:(NSArray *)dataArr {
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = self.viewsArr[i];
        NSDictionary *dic = dataArr[i];
        [btn setTitle:checkSafeContent(dic[@"name"]) forState:UIControlStateNormal];
    }
}

@end
