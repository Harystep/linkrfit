//
//  ZCTextFromOtherCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/30.
//

#import "ZCTextFromOtherCell.h"

@interface ZCTextFromOtherCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UIView *messaageView;

@property (nonatomic,strong) UILabel *contentL;

@property (nonatomic,strong) UILabel *timeL;

@end

@implementation ZCTextFromOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)chatMessageCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCTextFromOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCTextFromOtherCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = rgba(246, 246, 246, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.timeL = [self createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:13 bold:NO color:[ZCConfigColor subTxtColor]];
    [self.contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(5));
    }];
    
    self.iconIv = [[UIImageView alloc] init];
    self.iconIv.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self.contentView addSubview:self.iconIv];
    [self.iconIv setViewCornerRadiu:AUTO_MARGIN(21)];
    [self.iconIv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(AUTO_MARGIN(42));
        make.leading.mas_equalTo(self.contentView.mas_leading).inset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.timeL.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    self.messaageView = [[UIView alloc] init];
    [self.contentView addSubview:self.messaageView];
    
    self.contentL = [self createSimpleLabelWithTitle:@"" font:14 bold:NO color:[ZCConfigColor txtColor]];
    self.contentL.textAlignment = NSTextAlignmentCenter;
    [self.contentL setContentLineFeedStyle];
    [self.messaageView addSubview:self.contentL];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSString *content = dataDic[@"message"];
    NSDictionary *dict = @{NSFontAttributeName:FONT_SYSTEM(14)};
    CGSize size = [content boundingRectWithSize:CGSizeMake(SCREEN_W-AUTO_MARGIN(137), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    [self setContentViewStatus:NO];
    [self.contentL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.messaageView).inset(AUTO_MARGIN(10));
        make.leading.trailing.mas_equalTo(self.messaageView).inset(AUTO_MARGIN(15));
        make.width.mas_equalTo(size.width+AUTO_MARGIN(6));
        make.height.mas_equalTo(size.height);
    }];
    [self.messaageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self.iconIv.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(20));
    }];
    self.contentL.text = checkSafeContent(dataDic[@"message"]);
    self.contentL.hidden = NO;
    self.timeL.text = [NSString convertYMDHMStringWithContent:checkSafeContent(dataDic[@"createTime"])];
}

- (void)setContentViewStatus:(BOOL)status {
    if (status) { //me
        self.messaageView.backgroundColor = [ZCConfigColor txtColor];
        self.contentL.textColor = [ZCConfigColor whiteColor];
    } else {
        self.messaageView.backgroundColor = [ZCConfigColor whiteColor];
        self.contentL.textColor = [ZCConfigColor txtColor];
    }
}

- (void)setPreDic:(NSDictionary *)preDic {
    _preDic = preDic;
    NSString *cur = checkSafeContent(self.dataDic[@"createTime"]);
    NSString *pre = checkSafeContent(preDic[@"createTime"]);
    NSString *curTime = [NSString convertYMDHMStringWithContent:cur];
    NSString *preTime = [NSString convertYMDHMStringWithContent:pre];
    if ([curTime isEqualToString:preTime]) {
        self.timeL.text = @"";
    } else {
        self.timeL.text = curTime;
    }
}

@end
