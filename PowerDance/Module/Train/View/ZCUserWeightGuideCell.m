//
//  ZCUserWeightGuideCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/5/11.
//

#import "ZCUserWeightGuideCell.h"
#import "TTScrollRulerView.h"

@interface ZCUserWeightGuideCell ()<rulerDelegate>

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UIView *rulerContainer;
@property (nonatomic,strong) TTScrollRulerView *ruler;

@end

@implementation ZCUserWeightGuideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)userWeightGuideCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCUserWeightGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCUserWeightGuideCell" forIndexPath:indexPath];
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
        make.height.mas_equalTo(AUTO_MARGIN(365));
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

    UILabel *targetL = [self createSimpleLabelWithTitle:NSLocalizedString(@"你的当前体重是", nil) font:AUTO_MARGIN(14) bold:NO color:rgba(160, 99, 57, 1)];
    [targetView addSubview:targetL];
    [targetL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(targetView).offset(AUTO_MARGIN(15));
    }];
    
    ZCSimpleButton *btn = [self createShadowButtonWithTitle:NSLocalizedString(@"确定", nil) font:AUTO_MARGIN(14) color:rgba(160, 99, 57, 1)];
    [targetView addSubview:btn];
    btn.backgroundColor = [ZCConfigColor whiteColor];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(targetView).inset(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.bottom.mas_equalTo(targetView.mas_bottom).inset(AUTO_MARGIN(20));
        
    }];
    [btn setViewCornerRadiu:AUTO_MARGIN(25)];
    [btn addTarget:self action:@selector(btnOperate) forControlEvents:UIControlEventTouchUpInside];
    
    [targetView addSubview:self.rulerContainer];
    [self.rulerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(targetL.mas_bottom).offset(AUTO_MARGIN(77));
        make.leading.trailing.mas_equalTo(targetView);
        make.height.mas_equalTo(AUTO_MARGIN(100));
    }];
    [self.rulerContainer addSubview:self.ruler];
    
    self.numL = [self createSimpleLabelWithTitle:NSLocalizedString(@"50KG", nil) font:30 bold:YES color:rgba(94, 73, 62, 1)];
    [targetView addSubview:self.numL];
    [self.numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView.mas_centerX);
        make.top.mas_equalTo(targetView.mas_top).offset(AUTO_MARGIN(55));
        make.height.mas_equalTo(AUTO_MARGIN(35));
    }];
    
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_arrow_down")];
    [targetView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(targetView.mas_centerX);
        make.top.mas_equalTo(self.numL.mas_bottom).inset(AUTO_MARGIN(5));
    }];
    
}

- (void)rulerWith:(NSInteger)value {
    if (value >= 0 && value <= 300){
        self.numL.text = [NSString stringWithFormat:@"%tuKG", value];
    }
}

- (void)btnOperate {
    [self routerWithEventName:@"weight"];
    NSString *content = [self.numL.text substringWithRange:NSMakeRange(0, self.numL.text.length - 2)];
    [self saveUserInfoWithData:@{@"weight":checkSafeContent(content)}];
}

- (void)saveUserInfoWithData:(NSDictionary *)parm {
    
    [ZCProfileManage updateUserInfoOperate:parm completeHandler:^(id  _Nonnull responseObj) {
    }];
}

- (void)moreOperate {
    [HCRouter router:@"" params:@{} viewController:self.superViewController animated:YES];
}

- (UIView *)rulerContainer {
    if (!_rulerContainer) {
        _rulerContainer = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_W-AUTO_MARGIN(110), 100)];
        _rulerContainer.clipsToBounds = YES;
    }
    return _rulerContainer;
}

- (TTScrollRulerView *)ruler {
    if (!_ruler) {
        _ruler = [[TTScrollRulerView alloc] initWithFrame:CGRectMake(0, -60, SCREEN_W - AUTO_MARGIN(80), 120)];
        _ruler.rulerDelegate = self;
        _ruler.rulerDirection = RulerDirectionHorizontal;//设置滚动方向，默认横向滚动
        _ruler.rulerFace = RulerFace_down_right;//设置刻度位置，下方
        _ruler.lockMin = 0;//最小值
        _ruler.lockMax = 300;//最大值
        _ruler.unitValue = 1; //一个刻度代表的数值
        double weight = 50;
        _ruler.lockDefault = weight;//默认值
        _ruler.rulerBackgroundColor = rgba(255, 255, 255, 0.42);
        _ruler.pointerImage = nil;
        _ruler.pointerBackgroundColor = rgba(142, 207, 254, 1);
        [_ruler classicRuler];
    }
    return _ruler;
}


@end
