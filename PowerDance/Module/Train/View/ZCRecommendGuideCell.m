//
//  ZCRecommendGuideCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/5/11.
//

#import "ZCRecommendGuideCell.h"

@interface ZCRecommendGuideCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) NSMutableArray *viewsArr;

@end

@implementation ZCRecommendGuideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)recommendGuideCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCRecommendGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCRecommendGuideCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.viewsArr = [NSMutableArray array];
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"为你推荐动作练习", nil) font:AUTO_MARGIN(15) bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    UIButton *moreBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"更多", nil) font:AUTO_MARGIN(13) color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lb.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(22));
        make.width.mas_equalTo(AUTO_MARGIN(58));
    }];
    [moreBtn setViewCornerRadiu:AUTO_MARGIN(11)];
    moreBtn.backgroundColor = rgba(238, 238, 238, 1);
    [moreBtn addTarget:self action:@selector(moreOperate) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgView = [[UIView alloc] init];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(280));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    [bgView setViewCornerRadiu:AUTO_MARGIN(20)];
    
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_target_set_bg")];
    [bgView addSubview:iconIv];
    [iconIv setViewContentMode:UIViewContentModeScaleAspectFill];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(bgView);
    }];
    
    self.iconIv = [[UIImageView alloc] init];
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

    UILabel *subL = [self createSimpleLabelWithTitle:NSLocalizedString(@"定制个性计划", nil) font:AUTO_MARGIN(14) bold:YES color:rgba(94, 73, 62, 1)];
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
    
    [self bind];
}

- (void)bind {
    kweakself(self);
    [RACObserve(kUserStore, userData) subscribeNext:^(id  _Nullable x) {
        [weakself.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(x[@"imgUrl"])] placeholderImage:kIMAGE(@"profile_user_icon")];
        [ZCDataTool saveUserPortraint:x[@"imgUrl"]];
    }];
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
        btn.tag = i;
        [targetView addSubview:btn];
        btn.frame = CGRectMake(AUTO_MARGIN(15), AUTO_MARGIN(50) + AUTO_MARGIN(65)*i, width, AUTO_MARGIN(50));
        [btn setViewCornerRadiu:AUTO_MARGIN(25)];
        btn.backgroundColor = [ZCConfigColor whiteColor];
        [btn addTarget:self action:@selector(btnOperate:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewsArr addObject:btn];
    }
}

- (void)btnOperate:(UIButton *)sender {
    [sender routerWithEventName:@"target"];
    if (self.dataArr.count > 1) {
        NSDictionary *dic = self.dataArr[sender.tag];
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

- (void)moreOperate {
    [HCRouter router:@"" params:@{} viewController:self.superViewController animated:YES];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self setupSubviewsValue:dataArr];
}

@end
