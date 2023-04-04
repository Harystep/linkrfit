//
//  ZCClassDetailTopView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/14.
//

#import "ZCClassDetailTopView.h"
#import "ZCClassDetailTimeView.h"
#import "ZCBasePlayVideoView.h"
#import "ZCTrainInstrumentView.h"

@interface ZCClassDetailTopView ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UILabel *classTitleL;

@property (nonatomic,strong) UIImageView *equipIv;

@property (nonatomic,strong) ZCClassDetailTimeView *dataView;

@property (nonatomic,strong) ZCBasePlayVideoView *videoView;

@property (nonatomic,strong) ZCTrainInstrumentView *instrumentView;

@property (nonatomic,strong) UILabel *instrumentL;

@end

@implementation ZCClassDetailTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.iconIv = [[UIImageView alloc] init];
//    self.iconIv.image = kIMAGE(@"class_bg");
    self.iconIv.contentMode = UIViewContentModeScaleAspectFill;
    self.iconIv.layer.masksToBounds = YES;
    [self addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(210));
    }];
    [self.iconIv setViewColorAlpha:0.59 color:[ZCConfigColor txtColor]];
    
    self.titleL = [self createSimpleLabelWithTitle:@"KK燃脂速成" font:20 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(20));
    }];
    
    self.subL = [self createSimpleLabelWithTitle:@"训练" font:12 bold:NO color:[ZCConfigColor txtColor]];
    [self.subL setContentLineFeedStyle];
    [self addSubview:self.subL];
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(AUTO_MARGIN(15));
        make.trailing.leading.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(50));
    }];
    
    UIView *dataView = [[UIView alloc] init];
    [self addSubview:dataView];
    [dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(AUTO_MARGIN(93));
        make.top.mas_equalTo(self.subL.mas_bottom).offset(AUTO_MARGIN(15));
    }];
    
    [self createSportDetailDataView:dataView];
    
    self.dataView = [[ZCClassDetailTimeView alloc] init];
    [dataView addSubview:self.dataView];
    [self.dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(dataView.mas_centerY);
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.leading.trailing.mas_equalTo(dataView).inset(AUTO_MARGIN(20));
    }];
    
    UIView *equipmentView = [[UIView alloc] init];
    [equipmentView setViewCornerRadiu:AUTO_MARGIN(10)];
    equipmentView.backgroundColor = [ZCConfigColor whiteColor];
    [self addSubview:equipmentView];
    [equipmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(dataView.mas_bottom).offset(AUTO_MARGIN(15));
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.height.mas_equalTo(AUTO_MARGIN(90));
    }];
    
    [self createEquipmentViewSubviews:equipmentView];
    
    self.instrumentL = [self createSimpleLabelWithTitle:NSLocalizedString(@"徒手训练", nil) font:14 bold:NO color:[ZCConfigColor subTxtColor]];
    self.instrumentL.hidden = YES;
    [equipmentView addSubview:self.instrumentL];
    [self.instrumentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(equipmentView.mas_trailing).inset(AUTO_MARGIN(15));
        make.centerY.mas_equalTo(equipmentView.mas_centerY);
    }];
    
    
    self.classTitleL = [self createSimpleLabelWithTitle:@"课程内容(个动作)" font:14 bold:YES color:[ZCConfigColor txtColor]];
    [self addSubview:self.classTitleL];
    [self.classTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(AUTO_MARGIN(20));
        make.top.mas_equalTo(equipmentView.mas_bottom).offset(AUTO_MARGIN(30));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(7));
    }];        
    
//    ZCBasePlayVideoView *videoView = [[ZCBasePlayVideoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, AUTO_MARGIN(210))];
//    self.videoView = videoView;
//    videoView.hidden = YES;
//    [self addSubview:videoView];
}

- (void)createEquipmentViewSubviews:(UIView *)equipView {
    
    UILabel *titleL = [self createSimpleLabelWithTitle:NSLocalizedString(@"需使用器械:", nil) font:14 bold:NO color:[ZCConfigColor txtColor]];
    [equipView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(equipView.mas_centerY);
        make.leading.mas_equalTo(equipView.mas_leading).offset(AUTO_MARGIN(20));
    }];
    
    self.instrumentView = [[ZCTrainInstrumentView alloc] init];
    [equipView addSubview:self.instrumentView];
    [self.instrumentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(equipView.mas_centerY);
        make.trailing.mas_equalTo(equipView.mas_trailing).inset(AUTO_MARGIN(5));
        make.height.mas_equalTo(AUTO_MARGIN(50));
        make.width.mas_equalTo(AUTO_MARGIN(200));
    }];
    
}

- (void)createSportDetailDataView:(UIView *)dataView {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(AUTO_MARGIN(20), 0, SCREEN_W - AUTO_MARGIN(40), AUTO_MARGIN(93));
    view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = 10;
    view.layer.shadowColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:0.5].CGColor;
    view.layer.shadowOffset = CGSizeMake(0,10);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 38;
    [dataView addSubview:view];
}

- (void)setMp4_url:(NSString *)mp4_url {
    _mp4_url = mp4_url;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.videoView.mp4_url = mp4_url;
    });
}

- (void)setPlayStatus:(BOOL)playStatus {
    _playStatus = playStatus;
    if (playStatus == NO) {
        [self.videoView pause];
    }
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.titleL.text = checkSafeContent(dataDic[@"title"]);
    self.subL.text = checkSafeContent(dataDic[@"briefDesc"]);
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:checkSafeContent(dataDic[@"imgUrl"])] placeholderImage:nil];
    NSArray *actionList = [ZCDataTool convertEffectiveData:dataDic[@"actionList"]];
    NSMutableArray *temArr = [NSMutableArray array];
    for (NSDictionary *dic in actionList) {
        NSDictionary *courseAction = dic[@"courseAction"];
        if ([checkSafeContent(courseAction[@"rest"]) integerValue] == 1 || [checkSafeContent(courseAction[@"name"]) isEqualToString:NSLocalizedString(@"休息", nil)]) {
        } else {
            [temArr addObject:dic];
        }
    }
    self.classTitleL.text = [NSString stringWithFormat:@"%@（%tu%@）", NSLocalizedString(@"课程内容", nil), temArr.count, NSLocalizedString(@"个动作", nil)];
    NSArray *apparatusList = [ZCDataTool convertEffectiveData:dataDic[@"apparatusList"]];
    if (apparatusList.count > 0) {
//        NSInteger count = apparatusList.count >=2?2:apparatusList.count;
//        [self.instrumentView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(AUTO_MARGIN(50)*count + (count+1)*AUTO_MARGIN(15));
//        }];
        self.instrumentView.dataArr = apparatusList;
        self.instrumentL.hidden = YES;
    } else {
        self.instrumentL.hidden = NO;
    }
    
    NSDictionary *timeDic = @{@"count":@(temArr.count),
                              @"energy":checkSafeContent(dataDic[@"energy"]),
                              @"duration":checkSafeContent(dataDic[@"duration"])
    };
    self.dataView.dataDic = timeDic;


}

@end
