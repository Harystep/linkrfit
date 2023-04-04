//
//  ZCSelectShopTypeView.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/24.
//

#import "ZCSelectShopTypeView.h"
#import "ZCSelectShopTypeItem.h"
#import "ZCGoodsNumView.h"
#import "ZCShopGoodsTypeCell.h"
#import "ZCShopGoodsModel.h"
#import "ZCGoodsTypeModel.h"

@interface ZCSelectShopTypeView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) ZCGoodsNumView *numView;

@property (nonatomic,strong) UIView *selectIv;

@property (nonatomic,strong) UILabel *priceL;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,assign) NSInteger selectIndex;

@property (nonatomic,strong) ZCGoodsTypeModel *typeModel;

@end

@implementation ZCSelectShopTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selectIndex = -1;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *iconIv = [[UIImageView alloc] init];
    iconIv.contentMode = UIViewContentModeScaleAspectFill;
    iconIv.clipsToBounds = YES;
    self.iconIv = iconIv;
    [self addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self).offset(AUTO_MARGIN(20));
        make.height.width.mas_equalTo(AUTO_MARGIN(90));
    }];
    
    UIButton *exitBtn = [[UIButton alloc] init];
    [self addSubview:exitBtn];
    [exitBtn setImage:kIMAGE(@"shop_exit") forState:UIControlStateNormal];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconIv.mas_top);
        make.trailing.mas_equalTo(self.mas_trailing).inset(AUTO_MARGIN(15));
        make.width.height.mas_equalTo(AUTO_MARGIN(30));
    }];
    [exitBtn addTarget:self action:@selector(exitBtnOperate) forControlEvents:UIControlEventTouchUpInside];
    
    self.priceL = [self createSimpleLabelWithTitle:NSLocalizedString(@"", nil) font:30 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.priceL];
    [self.priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.iconIv.mas_top).offset(AUTO_MARGIN(20));
    }];
    
    UILabel *subTL = [self createSimpleLabelWithTitle:NSLocalizedString(@"选择规格", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:subTL];
    [subTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.priceL);
        make.bottom.mas_equalTo(self.iconIv.mas_bottom);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = rgba(43, 42, 51, 0.1);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(iconIv.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    UIButton *sureBtn = [self createSimpleButtonWithTitle:NSLocalizedString(@"立即购买", nil) font:14 color:[ZCConfigColor whiteColor]];
    sureBtn.backgroundColor = [ZCConfigColor txtColor];
    [self addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(32));
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    [sureBtn setViewCornerRadiu:AUTO_MARGIN(25)];
    [sureBtn addTarget:self action:@selector(sureOperate) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(lineView.mas_bottom).offset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(sureBtn.mas_top).inset(AUTO_MARGIN(20));
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCShopGoodsTypeCell *cell = [ZCShopGoodsTypeCell shopGoodsTypeCellWithTableView:tableView idnexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectIndex == indexPath.row) return;
    [self setSelectDataRefresh:indexPath.row status:@"1"];
    if (self.selectIndex >= 0) {
        [self setSelectDataRefresh:self.selectIndex status:@"0"];
    }
    self.selectIndex = indexPath.row;
    self.typeModel = self.dataArr[indexPath.row];
    NSString *content = [NSString stringWithFormat:@"¥%@", self.typeModel.sellPriceDou];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.priceL.attributedText = [content dn_changeFont:FONT_SYSTEM(14) andRange:NSMakeRange(0, 1)];
        [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(self.typeModel.imgUrl)] placeholderImage:nil];
    });
    [self.tableView reloadData];
}

- (void)setSelectDataRefresh:(NSInteger)index status:(NSString *)stauts {
    ZCGoodsTypeModel *model = self.dataArr[index];
    [self.dataArr removeObjectAtIndex:index];
    model.status = stauts;
    [self.dataArr insertObject:model atIndex:index];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(65))];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = rgba(43, 42, 51, 0.1);
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(view);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(view.mas_top).offset(AUTO_MARGIN(10));
    }];
    
    UILabel *selectL = [self createSimpleLabelWithTitle:NSLocalizedString(@"选择数量", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [view addSubview:selectL];
    [selectL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(view.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(lineView.mas_bottom).offset(AUTO_MARGIN(25));
    }];
    
    self.numView = [[ZCGoodsNumView alloc] init];
    [view addSubview:self.numView];
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(selectL.mas_centerY);
        make.trailing.mas_equalTo(view.mas_trailing).inset(AUTO_MARGIN(20));
        make.width.mas_equalTo(134);
        make.height.mas_equalTo(34);
    }];
    kweakself(self);
    self.numView.selectGoodsNumBlock = ^(NSString * _Nonnull value) {
        if (weakself.selectGoodsNumOperate) {
            weakself.selectGoodsNumOperate(value);
        }
    };
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return AUTO_MARGIN(65);
}

- (void)setGoodsModel:(ZCShopGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(goodsModel.imgUrl)] placeholderImage:nil];
     NSString *content = [NSString stringWithFormat:@"¥%@", goodsModel.priceDou];
     self.priceL.attributedText = [content dn_changeFont:FONT_SYSTEM(14) andRange:NSMakeRange(0, 1)];
}

- (void)setTypeArr:(NSMutableArray *)typeArr {
    _typeArr = typeArr;
    self.dataArr = typeArr;
    if (typeArr.count == 1) {
        self.selectIndex = 0;
        [self setSelectDataRefresh:self.selectIndex status:@"1"];
        self.typeModel = self.dataArr[0];
    }
    [self.tableView reloadData];
}

- (void)sureOperate {
    if (self.typeModel != nil) {
        if (self.payGoodsOpereate) {
            self.payGoodsOpereate(self.typeModel);
        }
    } else {
        [self makeToast:NSLocalizedString(@"请选择一种规格", nil) duration:2.0 position:CSToastPositionCenter];
    }
}

- (void)exitBtnOperate {
    if (self.exitSelectOperate) {
        self.exitSelectOperate();
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        [_tableView registerClass:[ZCShopGoodsTypeCell class] forCellReuseIdentifier:@"ZCShopGoodsTypeCell"];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];       
    }
    return _dataArr;
}

@end
