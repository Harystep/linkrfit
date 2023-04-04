//
//  ZCEquipmentGuideCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/5/11.
//

#import "ZCEquipmentGuideCell.h"
#import "ZCEquipmentGuideItemCell.h"

@interface ZCEquipmentGuideCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ZCEquipmentGuideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)equipmentGuideCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCEquipmentGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCEquipmentGuideCell" forIndexPath:indexPath];
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
        make.height.mas_equalTo(AUTO_MARGIN(490));
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

    UILabel *targetL = [self createSimpleLabelWithTitle:NSLocalizedString(@"是否使用器械？", nil) font:AUTO_MARGIN(14) bold:NO color:rgba(160, 99, 57, 1)];
    [targetView addSubview:targetL];
    [targetL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(targetView).offset(AUTO_MARGIN(15));
    }];
    
    ZCSimpleButton *btn = [self createShadowButtonWithTitle:NSLocalizedString(@"不使用器械", nil) font:AUTO_MARGIN(14) color:rgba(160, 99, 57, 1)];
    [targetView addSubview:btn];
    btn.backgroundColor = [ZCConfigColor whiteColor];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(targetView).inset(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.top.mas_equalTo(targetL.mas_bottom).offset(AUTO_MARGIN(15));
        
    }];
    [btn setViewCornerRadiu:AUTO_MARGIN(25)];
    [btn addTarget:self action:@selector(btnOperate) forControlEvents:UIControlEventTouchUpInside];
    
    [targetView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(targetView);
        make.top.mas_equalTo(btn.mas_bottom);
    }];
    
}

- (void)btnOperate {
    [self routerWithEventName:@"equipment"];
}

- (void)moreOperate {
    [HCRouter router:@"TrainAction" params:@{} viewController:self.superViewController animated:YES];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCEquipmentGuideItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCEquipmentGuideItemCell" forIndexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    [self routerWithEventName:@"equipment"];
    [ZCProfileManage updateUserInfoOperate:@{@"apparatusId":checkSafeContent(dic[@"id"])} completeHandler:^(id  _Nonnull responseObj) {
    }];
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_W - AUTO_MARGIN(125))/2.0, AUTO_MARGIN(40));
        layout.minimumInteritemSpacing = AUTO_MARGIN(15);
        layout.minimumLineSpacing = AUTO_MARGIN(15);
        layout.sectionInset = UIEdgeInsetsMake(AUTO_MARGIN(15), AUTO_MARGIN(15), AUTO_MARGIN(15), AUTO_MARGIN(15));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCEquipmentGuideItemCell class] forCellWithReuseIdentifier:@"ZCEquipmentGuideItemCell"];
    }
    return _collectionView;
}

@end
