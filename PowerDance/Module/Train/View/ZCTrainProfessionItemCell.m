//
//  ZCTrainProfessionItemCell.m
//  PowerDance
//
//  Created by PC-N121 on 2022/7/26.
//

#import "ZCTrainProfessionItemCell.h"

@interface ZCTrainProfessionItemCell ()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UILabel *moreL;

@property (nonatomic,strong) UIView *recordView;

@end

@implementation ZCTrainProfessionItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
    self.bgView.backgroundColor = [ZCConfigColor whiteColor];
    [self.bgView setViewCornerRadiu:AUTO_MARGIN(10)];
    
    self.iconIv = [[UIImageView alloc] init];
    [self.bgView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(AUTO_MARGIN(70));
        make.top.leading.mas_equalTo(self.bgView).offset(AUTO_MARGIN(15));
    }];
    [self.iconIv setViewCornerRadiu:AUTO_MARGIN(35)];
    
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:kIMAGE(@"train_simple_arrow")];
    [self.contentView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconIv.mas_centerY);
        make.trailing.mas_equalTo(self.bgView.mas_trailing).inset(AUTO_MARGIN(15));
    }];
    
    self.titleL = [self createSimpleLabelWithTitle:@"" font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    [self.bgView addSubview:self.titleL];
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_leading);
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(AUTO_MARGIN(15));
    }];
      
    self.moreL = [self createSimpleLabelWithTitle:NSLocalizedString(@"无训练历史", nil) font:AUTO_MARGIN(13) bold:NO color:[ZCConfigColor subTxtColor]];
    [self.bgView addSubview:self.moreL];
    [self.moreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView.mas_leading).offset(AUTO_MARGIN(15));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).inset(AUTO_MARGIN(15));
        make.height.mas_equalTo(AUTO_MARGIN(30));
    }];
    self.moreL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreTrainClick)];
    [self.moreL addGestureRecognizer:tap];
    
    self.recordView = [[UIView alloc] init];
    [self.bgView addSubview:self.recordView];
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.bgView);
        make.bottom.mas_equalTo(self.moreL.mas_top);
        make.height.mas_equalTo(AUTO_MARGIN(60));
    }];
    
}

- (void)setTitleDic:(NSDictionary *)titleDic {
    _titleDic = titleDic;
    self.iconIv.image = kIMAGE(titleDic[@"image"]);
    self.titleL.text = titleDic[@"title"];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    if (dataArr.count > 1) {
        self.moreL.text = NSLocalizedString(@"更多历史", nil);
        self.moreL.hidden = NO;
        [self createTrainRecordSubviews];
    } else if (dataArr.count == 1) {
        self.moreL.hidden = YES;
        [self createTrainRecordSubviews];
    } else {
        self.moreL.hidden = NO;
        self.moreL.text = NSLocalizedString(@"无训练历史", nil);
    }
}

- (void)createTrainRecordSubviews {
    NSInteger count = self.dataArr.count > 1 ? 2 : 1;
    NSLog(@"count-->%tu", count);
    for (UIView *lb in self.recordView.subviews) {
        [lb removeFromSuperview];
    }
    for (NSInteger i = count-1; i >= 0; i --) {
        NSDictionary *contentDic = self.dataArr[i];
        NSString *content = contentDic[@"trainTime"];
        content = [NSString convertYMDStringWithContent:content];
        content = [NSString stringWithFormat:@"%@%@", content, NSLocalizedString(@"的训练", nil)];
        UILabel *lb = [self createSimpleLabelWithTitle:content font:AUTO_MARGIN(12) bold:NO color:[ZCConfigColor txtColor]];
        [self.recordView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.recordView).inset(AUTO_MARGIN(15));
            make.height.mas_equalTo(AUTO_MARGIN(24));
            make.bottom.mas_equalTo(self.recordView.mas_bottom).inset(AUTO_MARGIN(24)*i);
        }];
        lb.userInteractionEnabled = YES;
        lb.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTrainClick:)];
        [lb addGestureRecognizer:tap];
    }    
}

- (void)setIndex:(NSInteger)index {
    _index = index;
}

#pragma -- mark 查看单条记录
- (void)selectTrainClick:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag;
    NSDictionary *baseDic = self.dataArr[tag];
    if (self.index == 0) {
        NSDictionary *dic = @{@"id":checkSafeContent(baseDic[@"trainId"])};
        [HCRouter router:@"TrainDetail" params:dic viewController:self.superViewController animated:YES];
    } else {
        NSDictionary *dic;
        if ([baseDic[@"custom"] integerValue] == 1) {
            dic = @{@"customCourseId":checkSafeContent(baseDic[@"courseId"])};
            [HCRouter router:@"CustomActionDetail" params:dic viewController:self.superViewController animated:YES];
        } else {
            dic = @{@"courseId":checkSafeContent(baseDic[@"courseId"])};
            [HCRouter router:@"ClassDetail" params:dic viewController:self.superViewController animated:YES];
        }
    }
}
#pragma -- mark 更多历史
- (void)moreTrainClick {
    if (self.index == 1) {//自定义课程记录
        [HCRouter router:@"TrainClassHistory" params:@{} viewController:self.superViewController animated:YES];
    } else {
        [HCRouter router:@"TrainTimerHistory" params:@{} viewController:self.superViewController animated:YES];
    }
}

@end
