//
//  ZCHomeBindDeviceView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/12/2.
//

#import "ZCHomeBindDeviceView.h"
#import "ZCHomeBindDeviceItemCell.h"

#define kViewHeight AUTO_MARGIN(650)

@interface ZCHomeBindDeviceView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIScrollView *scView;

@property (nonatomic,strong) UIView *detailView;

@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *subL;
@property (nonatomic,strong) UILabel *descL;
@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ZCHomeBindDeviceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
                    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.dn_height, SCREEN_W, self.dn_height)];
    self.contentView.backgroundColor = [ZCConfigColor whiteColor];
    [self addSubview:self.contentView];
    
    UIButton *bindBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"添加新设备", nil) font:AUTO_MARGIN(14) color:[ZCConfigColor whiteColor]];
    [self.contentView addSubview:bindBtn];
    [bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView).inset(AUTO_MARGIN(95));
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).inset(40);
    }];
    [bindBtn addTarget:self action:@selector(bindBtnOperate) forControlEvents:UIControlEventTouchUpInside];
    
    [self configureLeftToRightViewColorGradient:bindBtn width:SCREEN_W - AUTO_MARGIN(95)*2 height:40 one:rgba(158, 168, 194, 1) two:rgba(138, 205, 215, 1) cornerRadius:20];
        
    
    [self createDetailViewSubviews];
    
}

- (void)createDetailViewSubviews {
    
    UILabel *nameL = [self createSimpleLabelWithTitle:NSLocalizedString(@"家庭智能健身套装", nil) font:AUTO_MARGIN(20) bold:YES color:[ZCConfigColor txtColor]];
    [self.contentView addSubview:nameL];
    self.nameL = nameL;
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self.contentView).offset(20);
    }];
    
    UILabel *subL = [self createSimpleLabelWithTitle:NSLocalizedString(@"快速测量腰围", nil) font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor subTxtColor]];
    [self.contentView addSubview:subL];
    self.subL = subL;
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameL.mas_bottom).offset(6);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(20);
    }];
    
    UIButton *delBtn = [[UIButton alloc] init];
    [self.contentView addSubview:delBtn];
    [delBtn setImage:kIMAGE(@"home+bind_device_del") forState:UIControlStateNormal];
    [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameL.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(AUTO_MARGIN(15));
        make.height.width.mas_equalTo(AUTO_MARGIN(30));
    }];
    [delBtn addTarget:self action:@selector(delBtnOperate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)delBtnOperate {
    [self maskBtnClick];
    if (self.hideDeviceOperate) {
        self.hideDeviceOperate();
    }
}

#pragma -- mark 绑定设备
- (void)bindBtnOperate {
    NSString *code = checkSafeContent(self.dataDic[@"code"]);
    if ([code containsString:@"suit"]) {
    } else {
        [self maskBtnClick];
    }
    if (self.bindDeviceOperate) {
        self.bindDeviceOperate();
    }
}

- (void)hideContentView {
    [self maskBtnClick];
}

- (void)showContentView {
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = CGRectMake(0, 0, SCREEN_W, self.dn_height);
    }];
}

- (void)maskBtnClick {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = CGRectMake(0, self.dn_height, SCREEN_W, self.dn_height);
    } completion:^(BOOL finished) {
        self.contentView.hidden = YES;
        [self.contentView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:dataDic[@"imgUrl"]] placeholderImage:nil];
    self.subL.text = checkSafeContent(dataDic[@"subTitle"]);
    self.nameL.text = checkSafeContent(dataDic[@"name"]);
    self.descL.text = checkSafeContent(dataDic[@"briefDesc"]);
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    if (dataArr.count > 0) {
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView.mas_top).offset(AUTO_MARGIN(70));
            make.height.mas_equalTo(AUTO_MARGIN(100));
        }];        
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCHomeBindDeviceItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCHomeBindDeviceItemCell" forIndexPath:indexPath]; cell.dataDic = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.row];
    [self hideContentView];
    if (self.connectDeviceOperate) {
        self.connectDeviceOperate(dic);
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(AUTO_MARGIN(100), AUTO_MARGIN(100));
        layout.sectionInset = UIEdgeInsetsMake(0, AUTO_MARGIN(15), 0, AUTO_MARGIN(15));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZCHomeBindDeviceItemCell class] forCellWithReuseIdentifier:@"ZCHomeBindDeviceItemCell"];
    }
    return _collectionView;
}

@end
