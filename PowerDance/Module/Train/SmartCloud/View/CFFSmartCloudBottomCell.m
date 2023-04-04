//
//  CFFSmartCloudBottomCell.m
//  CofoFit
//
//  Created by PC-N121 on 2021/10/8.
//

#import "CFFSmartCloudBottomCell.h"

@interface CFFSmartCloudBottomCell ()

@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UIImageView *iconIv;
@property (nonatomic,strong) UIImageView *arrowIv;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,assign) NSInteger index;

@end

@implementation CFFSmartCloudBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)homeDataAnalysisWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    CFFSmartCloudBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFFSmartCloudBottomCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.bgView = [[UIView alloc] init];
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    self.iconIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_dataDetail_water")];
    [self.bgView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.top.mas_equalTo(self.bgView).offset(20);
        make.leading.mas_equalTo(self.bgView).offset(AUTO_MARGIN(15));
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
    }];
    
    self.nameL = [self createSimpleLabelWithTitle:@"水分" font:15 bold:NO color:[ZCConfigColor txtColor]];
    [self.bgView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(10));
        make.centerY.mas_equalTo(self.iconIv.mas_centerY);
    }];
    
    self.precentL = [self createSimpleLabelWithTitle:@"--" font:15 bold:NO color:[ZCConfigColor txtColor]];
    [self.bgView addSubview:self.precentL];
    [self.precentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView);
        make.trailing.mas_equalTo(self.bgView.mas_trailing).inset(AUTO_MARGIN(15));
    }];
    
    self.arrowIv = [[UIImageView alloc] initWithImage:kIMAGE(@"")];
    self.arrowIv.hidden = YES;
    [self.bgView addSubview:self.arrowIv];
    [self.arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.bgView).inset(AUTO_MARGIN(15));
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
    }];
    
    self.statusIv = [[UIImageView alloc] initWithImage:kIMAGE(@"")];
    self.statusIv.hidden = YES;
    [self.bgView addSubview:self.statusIv];
    [self.statusIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.arrowIv.mas_leading);
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
    }];
    
    self.sepView = [[UIView alloc] init];
    self.sepView.backgroundColor = RGBA_COLOR(255, 255, 255, 0.29);
    [self.contentView addSubview:self.sepView];
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.bgView).inset(AUTO_MARGIN(15));
        make.bottom.mas_equalTo(self.bgView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}

- (void)setDict:(NSDictionary *)dict {
    self.iconIv.image = dict[@"icon"];
    self.nameL.text = dict[@"title"];
}

@end
