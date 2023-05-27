//
//  ZCMoreSetSimpleCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/9.
//

#import "ZCMoreSetSimpleCell.h"

@interface ZCMoreSetSimpleCell ()

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *contentL;

@property (nonatomic,strong) UIView *updateView;
@property (nonatomic,strong) UILabel *versionL;

@end

@implementation ZCMoreSetSimpleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)moreSetSimpleCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCMoreSetSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCMoreSetSimpleCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = rgba(246, 246, 246, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [ZCConfigColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:@"" font:14 bold:NO color:[ZCConfigColor txtColor]];
    [bgView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.leading.mas_equalTo(bgView.mas_leading).offset(AUTO_MARGIN(15));
    }];
    
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:kIMAGE(@"profile_simple_arrow")];
    [bgView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(bgView.mas_trailing).inset(AUTO_MARGIN(15));
        make.centerY.mas_equalTo(bgView.mas_centerY);
    }];
    
    self.contentL = [self createSimpleLabelWithTitle:@"" font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    [bgView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(arrowIv.mas_centerY);
        make.trailing.mas_equalTo(arrowIv.mas_leading).inset(AUTO_MARGIN(10));
    }];
    
    self.updateView = [[UIView alloc] init];
    [bgView addSubview:self.updateView];
    self.updateView.userInteractionEnabled = NO;
    [self.updateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(bgView.mas_trailing).inset(25);
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(30);
    }];
    
    [self setupAlertUpdateView];
    self.updateView.hidden = YES;
    
}

- (void)setupAlertUpdateView {
    
    self.versionL = [self createSimpleLabelWithTitle:@" " font:12 bold:YES color:[ZCConfigColor subTxtColor]];
    [self.updateView addSubview:self.versionL];
    [self.versionL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.updateView.mas_centerY);
        make.trailing.mas_equalTo(self.updateView.mas_trailing).inset(5);
    }];
    
    UIView *alertView = [[UIView alloc] init];
    [self.updateView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.updateView.mas_centerY);
        make.trailing.mas_equalTo(self.versionL.mas_leading).inset(3);
        make.height.width.mas_equalTo(4);
    }];
    alertView.backgroundColor = UIColor.redColor;
    [alertView setViewCornerRadiu:2];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleL.text = dataDic[@"title"];
    self.contentL.text = dataDic[@"content"];
}

- (void)setLastVersion:(NSString *)lastVersion {
    _lastVersion = lastVersion;
    self.updateView.hidden = NO;
    
    self.versionL.text = [NSString stringWithFormat:@"V%@ %@", lastVersion, NSLocalizedString(@"可更新", nil)];
}

@end
