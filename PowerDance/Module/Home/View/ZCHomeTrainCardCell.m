//
//  ZCHomeTrainCardCell.m
//  PowerDance
//
//  Created by PC-N121 on 2021/10/28.
//

#import "ZCHomeTrainCardCell.h"

@interface ZCHomeTrainCardCell ()

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIImageView *iconIv;
@property (nonatomic,strong) UIImageView *bgIv;
@property (nonatomic,strong) UIImageView *addIv;
@property (nonatomic,strong) UIImageView *coverIv;
@property (nonatomic,strong) UIView *deleteView;

@end

@implementation ZCHomeTrainCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
        
    [self.contentView setViewCornerRadiu:AUTO_MARGIN(10)];
    self.bgIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_item_bg")];
    self.bgIv.contentMode = UIViewContentModeScaleAspectFill;
    self.bgIv.clipsToBounds = YES;
    self.bgIv.hidden = YES;
    [self.contentView addSubview:self.bgIv];
    [self.bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.mas_equalTo(self.contentView);
    }];
    
    self.addIv = [[UIImageView alloc] initWithImage:kIMAGE(@"home_add_train")];
    self.addIv.hidden = YES;
    [self.contentView addSubview:self.addIv];
    [self.addIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(30));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    self.coverIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.coverIv];
    self.coverIv.contentMode = UIViewContentModeScaleAspectFill;
    self.coverIv.clipsToBounds = YES;
    [self.coverIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.coverIv setViewColorAlpha:1 color:rgba(43, 42, 51, 0.3)];
    
    self.iconIv = [[UIImageView alloc] init];
    self.iconIv.hidden = YES;
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.width.mas_equalTo(AUTO_MARGIN(30));
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(18));
    }];
        
    self.titleL = [self createSimpleLabelWithTitle:@"" font:16 bold:YES color:UIColor.whiteColor];
    [self.contentView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(AUTO_MARGIN(15));
        make.leading.mas_equalTo(self.contentView).offset(AUTO_MARGIN(15));
        make.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(10));
    }];
    [self.titleL setContentLineFeedStyle];
     
    [self.contentView addSubview:self.deleteView];
    [self.deleteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesOperate)];
    longGes.minimumPressDuration = 1.0;
    [self.contentView addGestureRecognizer:longGes];
}

- (void)longGesOperate {
    if ([self.dataDic[@"type"] integerValue] == TrainTypeCustom) {
        [self routerWithEventName:@"edit" userInfo:@{@"data":self.dataDic, @"index":@(self.index)}];
        self.deleteView.hidden = NO;
    }
}

- (void)setIndex:(NSInteger)index {
    _index = index;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleL.text = dataDic[@"name"];
    if ([dataDic[@"flag"] integerValue] == 100) {
        self.contentView.backgroundColor = rgba(0, 0, 0, 0.41);
        [self autoCreateTrainSportStatus:YES];
        self.coverIv.hidden = YES;
    } else {
        self.coverIv.hidden = NO;
        [self autoCreateTrainSportStatus:NO];
        if ([dataDic[@"type"] integerValue] == TrainTypeGeneral) {
            [self.coverIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"cover"])] placeholderImage:nil];
            self.coverIv.backgroundColor = [UIColor clearColor];
        } else if ([dataDic[@"type"] integerValue] == TrainTypeCustom) {
            self.bgIv.hidden = NO;
            self.coverIv.backgroundColor = kColorHex(dataDic[@"colour"]);
            [self.coverIv sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil];
        } else if ([dataDic[@"type"] integerValue] == TrainTypeSystem) {
            self.coverIv.backgroundColor = [UIColor clearColor];
            [self.coverIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"cover"])] placeholderImage:nil];            
        }
    }
    if ([dataDic[@"delete"] integerValue] == 1) {
        self.deleteView.hidden = NO;
    } else {
        self.deleteView.hidden = YES;
    }
}

- (void)deleteOperate {
    NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
    [temDic setValue:@"1" forKey:@"delete"];
    [self routerWithEventName:@"delete" userInfo:temDic];
    self.deleteView.hidden = YES;
}

- (void)autoCreateTrainSportStatus:(BOOL)status {
    self.addIv.hidden = !status;
    self.bgIv.hidden = !status;
}

- (UIView *)deleteView {
    if (!_deleteView) {
        _deleteView = [[UIView alloc] init];
        _deleteView.hidden = YES;
        _deleteView.backgroundColor = rgba(0, 0, 0, 0.7);
        UIButton *btn = [self createSimpleButtonWithTitle:NSLocalizedString(@"删除此训练", nil) font:12 color:[ZCConfigColor whiteColor]];
        btn.backgroundColor = rgba(255, 255, 255, 0.32);
        [_deleteView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_deleteView.mas_centerX);
            make.centerY.mas_equalTo(_deleteView.mas_centerY);
            make.width.mas_equalTo(AUTO_MARGIN(104));
            make.height.mas_equalTo(AUTO_MARGIN(34));
        }];
        [btn setViewCornerRadiu:AUTO_MARGIN(17)];
        [btn addTarget:self action:@selector(deleteOperate) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteView;
}

@end
