//
//  ZCSportActionCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/25.
//

#import "ZCSportActionCell.h"

@interface ZCSportActionCell ()

@property (nonatomic,strong) UIView *colorView;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UILabel *timeL;

@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end

@implementation ZCSportActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)sportActionCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCSportActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCSportActionCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
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
    [self.contentView setViewColorAlpha:0.1 color:rgba(173, 173, 173, 1)];
    
    self.colorView = [[UIView alloc] init];
    [self.contentView addSubview:self.colorView];
    self.colorView.backgroundColor = rgba(250, 201, 3, 1);
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(10));
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(20));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.colorView setViewCornerRadiu:5];
    
    self.nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.colorView.mas_centerY);
        make.leading.mas_equalTo(self.colorView.mas_trailing).offset(AUTO_MARGIN(10));
    }];
    
    self.timeL = [self createSimpleLabelWithTitle:@"00:00:00" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:self.timeL];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.colorView.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(45));
    }];
    
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setImage:kIMAGE(@"custom_rest_del") forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(15));
        make.height.width.mas_equalTo(AUTO_MARGIN(20));
    }];
    [self.deleteBtn addTarget:self action:@selector(delegateOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)delegateOperate {
    [self routerWithEventName:@"delete" userInfo:@{@"index":self.indexPath}];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    self.nameL.text = dataDic[@"name"];
    self.timeL.text = dataDic[@"duration"];
}

@end
