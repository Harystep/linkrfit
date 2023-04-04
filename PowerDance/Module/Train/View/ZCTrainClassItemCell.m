//
//  ZCTrainEquipmenClassCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/20.
//

#import "ZCTrainClassItemCell.h"
#import "ZCEquipmentAssociateClassCell.h"

@interface ZCTrainClassItemCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ZCTrainClassItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)trainClassItemCellWithTableView:(UITableView *)tableView idnexPath:(NSIndexPath *)indexPath {
    ZCTrainClassItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZCTrainClassItemCell" forIndexPath:indexPath];
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
//    self.topView = [[UIView alloc] initWithFrame:CGRectMake(AUTO_MARGIN(20), 0, SCREEN_W - AUTO_MARGIN(40), AUTO_MARGIN(201))];
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(160))];
    [self.contentView addSubview:self.topView];
    [self.topView setViewCornerRadiu:AUTO_MARGIN(10)];
//    [self setupViewColors:self.topView frame:CGRectMake(0, 0, SCREEN_W - AUTO_MARGIN(40), AUTO_MARGIN(201))];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"发现课程", nil) font:AUTO_MARGIN(15) bold:YES color:[ZCConfigColor txtColor]];
    [self.topView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.topView.mas_leading).offset(AUTO_MARGIN(15));
        make.top.mas_equalTo(self.topView.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    UIButton *moreBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"更多", nil) font:AUTO_MARGIN(13) color:[ZCConfigColor txtColor]];
    [self.topView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lb.mas_centerY);
        make.trailing.mas_equalTo(self.topView.mas_trailing).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(22));
        make.width.mas_equalTo(AUTO_MARGIN(58));
    }];
    [moreBtn setViewCornerRadiu:AUTO_MARGIN(11)];
    moreBtn.backgroundColor = rgba(238, 238, 238, 1);
    [moreBtn addTarget:self action:@selector(moreOperate) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *sepView = [[UIView alloc] init];
    [self.contentView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(3));
        make.height.mas_equalTo(AUTO_MARGIN(135));
    }];
    
}

- (void)moreOperate {
    [HCRouter router:@"TrainClassAllIn" params:@{} viewController:self.superViewController animated:YES];
}   

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCEquipmentAssociateClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCEquipmentAssociateClassCell" forIndexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    [HCRouter router:@"ClassDetail" params:dic viewController:self.superViewController animated:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(AUTO_MARGIN(120), AUTO_MARGIN(105));
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = AUTO_MARGIN(15);
        layout.sectionInset = UIEdgeInsetsMake(AUTO_MARGIN(15), AUTO_MARGIN(15), AUTO_MARGIN(15), AUTO_MARGIN(15));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCEquipmentAssociateClassCell class] forCellWithReuseIdentifier:@"ZCEquipmentAssociateClassCell"];
    }
    return _collectionView;
}

- (void)setupViewColors:(UIView *)view frame:(CGRect)rect {
    UIColor *colorOne = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    gradient.colors = colors;
    gradient.frame = rect;
    [view.layer insertSublayer:gradient atIndex:0];
}


@end
