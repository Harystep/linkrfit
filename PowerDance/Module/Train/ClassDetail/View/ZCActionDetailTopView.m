//
//  ZCActionDetailTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/14.
//

#import "ZCActionDetailTopView.h"
#import "ZCSizingCollectCell.h"
#import "ZCBasePlayVideoView.h"
#import "ZCTrainInstrumentView.h"

@interface ZCActionDetailTopView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *equipmentView;

@property (nonatomic,strong) ZCBasePlayVideoView *videoView;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,strong) ZCTrainInstrumentView *instrumentView;

@property (nonatomic,strong) UILabel *instrumentL;

@property (nonatomic,strong) UIImageView *bgIcon;

@end

@implementation ZCActionDetailTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.bgIcon = [[UIImageView alloc] init];
    [self addSubview:self.bgIcon];
    [self.bgIcon setViewContentMode:UIViewContentModeScaleToFill];
    [self.bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(490));
    }];
    
    ZCBasePlayVideoView *videoView = [[ZCBasePlayVideoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(490))];
//    videoView.backgroundColor = [ZCConfigColor bgColor];
    self.videoView = videoView;
    self.videoView.player.smallControlView.hidden = YES;
    videoView.hidden = YES;
    [self addSubview:videoView];
    
    self.titleL = [self createSimpleLabelWithTitle:@"KK燃脂速成" font:20 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.videoView.mas_bottom).offset(AUTO_MARGIN(20));
    }];

    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AUTO_MARGIN(32));
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(AUTO_MARGIN(30));
    }];
        
    self.dataArr = @[@"优选", @"健身锻炼", @"运动", @"生活", @"养生", @"运动", @"生活", @"养生"];
    
    UIView *equipmentView = [[UIView alloc] init];
    self.equipmentView = equipmentView;
    [equipmentView setViewCornerRadiu:AUTO_MARGIN(10)];
    equipmentView.backgroundColor = rgba(246, 246, 246, 1);
    [self addSubview:equipmentView];
    [equipmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(AUTO_MARGIN(30));
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(90));
    }];
    [equipmentView setViewCornerRadiu:AUTO_MARGIN(10)];
    [self createEquipmentViewSubviews:equipmentView];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"动作步骤", nil) font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(equipmentView.mas_bottom).offset(AUTO_MARGIN(30));
        make.height.mas_equalTo(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(15));
    }];
}

- (void)createEquipmentViewSubviews:(UIView *)equipView {
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"需使用器械:", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [equipView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(equipView.mas_centerY);
        make.leading.mas_equalTo(equipView.mas_leading).offset(AUTO_MARGIN(20));
    }];
        
    self.instrumentL = [self createSimpleLabelWithTitle:NSLocalizedString(@"徒手训练", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    self.instrumentL.hidden = YES;
    [equipView addSubview:self.instrumentL];
    [self.instrumentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(equipView.mas_trailing).inset(AUTO_MARGIN(15));
        make.centerY.mas_equalTo(equipView.mas_centerY);
    }];
    
    
    self.instrumentView = [[ZCTrainInstrumentView alloc] init];
    [equipView addSubview:self.instrumentView];
    [self.instrumentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(equipView.mas_centerY);
        make.trailing.mas_equalTo(equipView.mas_trailing).inset(AUTO_MARGIN(5));
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
}

- (void)continuePlay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSDictionary *actionDic = self.dataDic[@"action"];
//        NSString *vedio = checkSafeContent(actionDic[@"vedio"]);
        [self.videoView play];
    });
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSDictionary *actionDic = dataDic[@"action"];
    NSString *vedio = checkSafeContent(actionDic[@"vedio"]);
    [self.bgIcon sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(actionDic[@"cover"])] placeholderImage:nil];
    if (vedio.length > 0) {
        self.videoView.hidden = NO;
        self.videoView.mp4_url = vedio;
    } else {
        self.videoView.hidden = YES;
    }
    NSArray *apparatusList = [ZCDataTool convertEffectiveData:dataDic[@"apparatusList"]];
    if (apparatusList.count > 0) {
        NSInteger count = apparatusList.count >=2?2:apparatusList.count;
        [self.instrumentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(AUTO_MARGIN(50)*count + (count+1)*AUTO_MARGIN(15));
        }];
        self.instrumentView.dataArr = apparatusList;
        self.instrumentL.hidden = YES;
    } else {
        self.instrumentL.hidden = NO;
    }
    self.titleL.text = checkSafeContent(actionDic[@"name"]);
    NSMutableArray *temArr = [NSMutableArray array];
    NSArray *tagsList = [ZCDataTool convertEffectiveData:dataDic[@"tagsList"]];
    for (NSDictionary *dic in tagsList) {
        [temArr addObject:checkSafeContent(dic[@"name"])];
    }
    self.dataArr = temArr;
    [self.collectionView reloadData];
}

#pragma MARK --- UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataArr count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ZCSizingCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCSizingCollectCell" forIndexPath:indexPath];
    [cell.textLabel setTitle:self.dataArr[indexPath.row] forState:UIControlStateNormal];
    cell.textLabel.backgroundColor = UIColor.whiteColor;
    [cell.textLabel setViewCornerRadiu:AUTO_MARGIN(16)];
    [cell.textLabel setViewBorderWithColor:1 color:rgba(43, 42, 51, 0.1)];
    return cell;
}

- (void)pausePlayVideo {
    [self.videoView.player pause];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置具体属性
//        // 1.设置 最小行间距
//        layout.minimumLineSpacing = 0;
//        // 2.设置 最小列间距
//        layout. minimumInteritemSpacing  = 20;
        // 3.设置item块的大小 (可以用于自适应)
        layout.estimatedItemSize = CGSizeMake(20, 32);
        // 设置滑动的方向 (默认是竖着滑动的)
        layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        // 设置item的内边距
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZCSizingCollectCell class] forCellWithReuseIdentifier:@"ZCSizingCollectCell"];
    }
    return _collectionView;
}

@end
