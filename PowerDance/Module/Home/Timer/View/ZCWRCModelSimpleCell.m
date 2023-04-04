//
//  ZCWRCModelSimpleCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/12/13.
//

#import "ZCWRCModelSimpleCell.h"
#import "ZCAlertTimePickView.h"

@interface ZCWRCModelSimpleCell ()

@property (nonatomic,strong) UILabel *timeTitleL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UILabel *restTitleL;
@property (nonatomic,strong) UILabel *restL;

@property (nonatomic,assign) NSInteger index;

@end

@implementation ZCWRCModelSimpleCell
    
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)wrcModelCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCWRCModelSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCWRCModelSimpleCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
            
    UIView *timeView = [[UIView alloc] init];
    [self.contentView addSubview:timeView];
    timeView.tag = 0;
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(80));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(15));
        make.width.mas_equalTo(AUTO_MARGIN(120));
        make.height.mas_equalTo(44);
    }];
    [timeView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [timeView setViewCornerRadiu:6];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeViewOperate:)];
    [timeView addGestureRecognizer:tap];
    
    self.timeTitleL = [self createSimpleLabelWithTitle:[NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"时间", nil), @"F1"] font:14 bold:NO color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.timeTitleL];
    [self.timeTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(timeView.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(40));
    }];
    
    UIView *signView = [[UIView alloc] init];
    [self.contentView addSubview:signView];
    [signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeTitleL.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.height.width.mas_equalTo(AUTO_MARGIN(10));
    }];
    signView.backgroundColor = [ZCConfigColor txtColor];
    [signView setViewCornerRadiu:AUTO_MARGIN(5)];
    
    self.timeL = [self.contentView createSimpleLabelWithTitle:NSLocalizedString(@"00:00:00", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    [timeView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.mas_equalTo(timeView);
    }];
             
    [self createTimeViewSubviews:timeView];
    
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setImage:kIMAGE(@"custom_rest_del") forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(15));
        make.width.height.mas_equalTo(AUTO_MARGIN(30));
    }];
    self.deleteBtn.hidden = YES;
    [self.deleteBtn addTarget:self action:@selector(deleteOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createTimeViewSubviews:(UIView *)topView {
    UIView *timeView = [[UIView alloc] init];
    [self.contentView addSubview:timeView];
    timeView.tag = 1;
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(80));
        make.top.mas_equalTo(topView.mas_bottom).offset(AUTO_MARGIN(15));
        make.width.mas_equalTo(AUTO_MARGIN(120));
        make.height.mas_equalTo(AUTO_MARGIN(40));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    [timeView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    [timeView setViewCornerRadiu:6];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeViewOperate:)];
    [timeView addGestureRecognizer:tap];
    
    self.restTitleL = [self createSimpleLabelWithTitle:[NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"时间", nil), @"C1"] font:14 bold:NO color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.restTitleL];
    [self.restTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(timeView.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(40));
    }];
    
    UIView *signView = [[UIView alloc] init];
    [self.contentView addSubview:signView];
    [signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.restTitleL.mas_centerY);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.height.width.mas_equalTo(AUTO_MARGIN(10));
    }];
    signView.backgroundColor = rgba(233, 233, 234, 1);
    [signView setViewCornerRadiu:AUTO_MARGIN(5)];
    
    self.restL = [self.contentView createSimpleLabelWithTitle:NSLocalizedString(@"00:00:00", nil) font:20 bold:YES color:[ZCConfigColor txtColor]];
    [timeView addSubview:self.restL];
    [self.restL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.mas_equalTo(timeView);
    }];
}

- (void)deleteOperate {
    [self.deleteBtn routerWithEventName:@"delete" userInfo:@{@"index":@(self.index)}];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.timeTitleL.text = [NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"时间", nil), dataDic[@"timeTitle"]];
    self.restTitleL.text = [NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"时间", nil), dataDic[@"restTitle"]];
    self.timeL.text = checkSafeContent(dataDic[@"time"]);
    self.restL.text = checkSafeContent(dataDic[@"rest"]);
}

- (void)timeViewOperate:(UITapGestureRecognizer *)tap {
    if (tap.view.tag) { //休息时间
        [self restTimeOperate];
    } else {//训练时间
        [self timeOperate];
    }
}

#pragma -- mark 点击时间
- (void)timeOperate {
    if (self.signNoEditFlag) {
        
    } else {
        ZCAlertTimePickView *pick = [[ZCAlertTimePickView alloc] init];
        [self addSubview:pick];
        [pick showAlertView];
        pick.titleL.text = NSLocalizedString(@"设置训练时间", nil);
        kweakself(self);
        pick.sureRepeatOperate = ^(NSString * _Nonnull content) {
            weakself.timeL.text = content;
            weakself.saveConfigureTrainData(content, weakself.index);
        };
    }
}

#pragma -- mark 点击时间
- (void)restTimeOperate {
    if (self.signNoEditFlag) {        
    } else {
        ZCAlertTimePickView *pick = [[ZCAlertTimePickView alloc] init];
        [self addSubview:pick];
        [pick showAlertView];
        pick.titleL.text = NSLocalizedString(@"设置休息时间", nil);
        pick.close = YES;
        kweakself(self);
        pick.sureRepeatOperate = ^(NSString * _Nonnull content) {
            weakself.restL.text = content;
            weakself.saveRestConfigureTrainData(content, weakself.index);
        };        
    }
}

- (void)setSignNoEditFlag:(NSInteger)signNoEditFlag {
    _signNoEditFlag = signNoEditFlag;
    
    
}

- (void)setShowDeleteFlag:(NSInteger)showDeleteFlag {
    _showDeleteFlag = showDeleteFlag;
    if (self.signNoEditFlag) {
        self.deleteBtn.hidden = YES;
    } else {
        if (showDeleteFlag) {
            self.deleteBtn.hidden = NO;
        } else {
            self.deleteBtn.hidden = YES;
        }
    }
}

@end
