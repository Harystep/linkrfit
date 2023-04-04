//
//  ZCChatMessageCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/30.
//

#import "ZCChatMessageCell.h"

@interface ZCChatMessageCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UIView *messaageView;

@property (nonatomic,strong) UILabel *contentL;

@property (nonatomic,strong) UIImageView *picIv;

@end

@implementation ZCChatMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)chatMessageCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCChatMessageCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = rgba(246, 246, 246, 1);
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.iconIv = [[UIImageView alloc] init];
    self.iconIv.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self.contentView addSubview:self.iconIv];
    [self.iconIv setViewCornerRadiu:AUTO_MARGIN(21)];
    
    self.messaageView = [[UIView alloc] init];
    [self.contentView addSubview:self.messaageView];
    
    self.contentL = [self createSimpleLabelWithTitle:@"" font:14 bold:NO color:[ZCConfigColor txtColor]];
    self.contentL.textAlignment = NSTextAlignmentCenter;
    [self.contentL setContentLineFeedStyle];
    [self.messaageView addSubview:self.contentL];
    
    self.picIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.picIv];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSString *content = dataDic[@"message"];
    NSDictionary *dict = @{NSFontAttributeName:FONT_SYSTEM(14)};
    CGSize size = [content boundingRectWithSize:CGSizeMake(SCREEN_W-AUTO_MARGIN(137), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    NSDictionary *fromUser = dataDic[@"fromUser"];
    if ([fromUser[@"phone"] isEqualToString:kUserInfo.phone]) {
        [self setContentViewStatus:YES];
        [self.iconIv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(AUTO_MARGIN(42));
            make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(20));
            make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(20));
        }];
        if ([dataDic[@"messageType"] integerValue] == 1) {
            [self.contentL mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(self.messaageView).inset(AUTO_MARGIN(10));
                make.leading.trailing.mas_equalTo(self.messaageView).inset(AUTO_MARGIN(15));
                make.width.mas_equalTo(size.width+AUTO_MARGIN(6));
                make.height.mas_equalTo(size.height);
            }];
            [self.messaageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(self.iconIv.mas_leading).inset(AUTO_MARGIN(15));
                make.top.mas_equalTo(self.iconIv.mas_top);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(20));
            }];
            self.contentL.text = checkSafeContent(dataDic[@"message"]);
            self.picIv.hidden = YES;
            self.contentL.hidden = NO;
        } else {
            
            [self.picIv mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(AUTO_MARGIN(140));
                make.trailing.mas_equalTo(self.iconIv.mas_leading).inset(AUTO_MARGIN(15));
                make.top.mas_equalTo(self.iconIv.mas_top);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(20));
            }];
            self.contentL.hidden = YES;
            self.picIv.hidden = NO;
            [self.picIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"message"])] placeholderImage:nil];
        }
        
    } else {
        [self setContentViewStatus:NO];
        [self.iconIv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(AUTO_MARGIN(42));
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
            make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(20));
        }];
        if ([dataDic[@"messageType"] integerValue] == 1) {
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
            
        } else {
            
            [self.picIv mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(AUTO_MARGIN(140));
                make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(15));
                make.top.mas_equalTo(self.iconIv.mas_top);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(AUTO_MARGIN(20));
            }];
            self.contentL.hidden = YES;
            self.picIv.hidden = NO;
            [self.picIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"message"])] placeholderImage:nil];
        }
    }
  
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

@end
