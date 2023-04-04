//
//  CFFSmartRulerRecordCell.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/14.
//

#import "CFFSmartRulerRecordCell.h"
#import "CFFSmartRulerRecordModel.h"

@interface CFFSmartRulerRecordCell ()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *scaleL;
@property (nonatomic,strong) UILabel *chestL;
@property (nonatomic,strong) UILabel *butL;
@property (nonatomic,strong) UILabel *waistL;
@property (nonatomic,strong) UILabel *scaleTL;
@property (nonatomic,strong) UILabel *chestTL;
@property (nonatomic,strong) UILabel *butTL;
@property (nonatomic,strong) UILabel *waistTL;
@property (nonatomic,strong) UIView *sepView;
@property (nonatomic,strong) UIImageView *arrowIv;

@end

@implementation CFFSmartRulerRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)smartRulerRecordCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    CFFSmartRulerRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFFSmartRulerRecordCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.groupTableViewBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {

    self.timeL = [[UILabel alloc] init];
    self.timeL.textColor = RGBA_COLOR(0, 0, 0, 0.2);
    self.timeL.font = FONT_SYSTEM(14);
    self.timeL.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(30));
        make.leading.trailing.mas_equalTo(self.contentView);
    }];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.bgView];
    [self.bgView setViewCornerRadius:15];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self.timeL.mas_bottom).offset(AUTO_MARGIN(15));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(150);
    }];
    
    self.sepView = [[UIView alloc] init];
    self.sepView.backgroundColor = RGBA_COLOR(0, 0, 0, 0.1);
    [self.bgView addSubview:self.sepView];
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(80);
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.leading.mas_equalTo(self.bgView.mas_leading).offset(AUTO_MARGIN(102));
        make.width.mas_equalTo(2);
    }];
    
    self.arrowIv = [[UIImageView alloc] init];
    self.arrowIv.image = kIMAGE(@"home_arrow");
    [self.bgView addSubview:self.arrowIv];
    [self.arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.bgView.mas_trailing).inset(AUTO_MARGIN(25));
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
    }];
    
    self.scaleTL = [self createSubLabelWithFont:14 color:kCFF_COLOR_SUB_TITLE bold:NO];
    self.scaleTL.text = NSLocalizedString(@"腰臀比", nil);
    self.scaleTL.textAlignment = NSTextAlignmentCenter;
    self.chestTL = [self createSubLabelWithFont:14 color:kCFF_COLOR_SUB_TITLE bold:NO];
    self.chestTL.text = NSLocalizedString(@"胸围", nil);
    self.waistTL = [self createSubLabelWithFont:14 color:kCFF_COLOR_SUB_TITLE bold:NO];
    self.waistTL.text = NSLocalizedString(@"腰围", nil);
    self.butTL = [self createSubLabelWithFont:14 color:kCFF_COLOR_SUB_TITLE bold:NO];
    self.butTL.text = NSLocalizedString(@"臀围", nil);
    
    self.scaleL = [self createSubLabelWithFont:14 color:kCFF_COLOR_CONTENT_TITLE bold:YES];
    self.scaleL.textAlignment = NSTextAlignmentCenter;
    self.chestL = [self createSubLabelWithFont:14 color:kCFF_COLOR_CONTENT_TITLE bold:YES];
    self.waistL = [self createSubLabelWithFont:14 color:kCFF_COLOR_CONTENT_TITLE bold:YES];
    self.butL = [self createSubLabelWithFont:14 color:kCFF_COLOR_CONTENT_TITLE bold:YES];
    
    [self setupContraints];
}

- (void)setupContraints {
    [self.scaleTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView.mas_leading);
        make.trailing.mas_equalTo(self.sepView.mas_leading);
        make.top.mas_equalTo(self.bgView.mas_top).offset(48);
        make.height.mas_equalTo(20);
    }];
    
    [self.scaleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scaleTL.mas_centerX);
        make.top.mas_equalTo(self.scaleTL.mas_bottom).offset(19);
        make.height.mas_equalTo(20);
    }];
    
    [self.chestTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.sepView.mas_trailing).offset(29);
        make.top.mas_equalTo(self.bgView.mas_top).offset(35);
        make.width.mas_equalTo(AUTO_MARGIN(60));
        make.height.mas_equalTo(20);
    }];
    
    [self.waistTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.chestTL.mas_leading);
        make.top.mas_equalTo(self.chestTL.mas_bottom).offset(10);
        make.width.mas_equalTo(AUTO_MARGIN(60));
        make.height.mas_equalTo(20);
    }];
    [self.butTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.waistTL.mas_leading);
        make.top.mas_equalTo(self.waistTL.mas_bottom).offset(10);
        make.width.mas_equalTo(AUTO_MARGIN(60));
        make.height.mas_equalTo(20);
    }];
    
    [self.chestL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.chestTL.mas_centerY);
        make.leading.mas_equalTo(self.chestTL.mas_trailing).offset(5);
    }];
    
    [self.waistL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.waistTL.mas_centerY);
        make.leading.mas_equalTo(self.waistTL.mas_trailing).offset(5);
    }];
    
    [self.butL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.butTL.mas_centerY);
        make.leading.mas_equalTo(self.butTL.mas_trailing).offset(5);
    }];
    
}

- (UILabel *)createSubLabelWithFont:(CGFloat)font color:(UIColor *)color bold:(BOOL)flag {
    UILabel *lb = [[UILabel alloc] init];
    [self.bgView addSubview:lb];
    if (flag) {
        lb.font = FONT_BOLD(font);
    } else {
        lb.font = FONT_SYSTEM(font);
    }
    lb.textColor = color;
    return lb;
}

- (void)setModel:(CFFSmartRulerRecordModel *)model {
    CGFloat waist = [model.waistSize doubleValue];
    CGFloat butt = [model.buttocksSize doubleValue];
    CGFloat scale = waist / butt;
    self.scaleL.text = [NSString stringWithFormat:@"%.2f", scale];
    self.chestL.text = [NSString stringWithFormat:@"%@%@", [self convertContentWithData:model.chestSize], [self convertUnitWithNum:model.unit]];
    self.waistL.text = [NSString stringWithFormat:@"%@%@", [self convertContentWithData:model.waistSize], [self convertUnitWithNum:model.unit]];
    self.butL.text = [NSString stringWithFormat:@"%@%@", [self convertContentWithData:model.buttocksSize], [self convertUnitWithNum:model.unit]];
    self.timeL.text = model.createTime;
}

- (NSString *)convertUnitWithNum:(NSString *)num {
    NSString *unit;
    if ([num integerValue] == 1) {
        unit = @"CM";
    } else {
        unit = @"IN";
    }
    return unit;
}

- (NSString *)convertContentWithData:(NSString *)data {
    NSString *content;
    data = checkSafeContent(data);
    if ([data isEqualToString:@"(null)"] || [data isEqualToString:@"(NULL)"] || [data isEqualToString:@"NULL"] ||[data isEqualToString:@"null"]) {
        content = @"--";
    } else if ([data doubleValue] == 0.0) {
        content = @"--";
    } else {
        content = [CFFDataTool reviseString:data];
        content = [NSString stringWithFormat:@"%.1f", [content doubleValue]];
    }
    return content;
}

@end
