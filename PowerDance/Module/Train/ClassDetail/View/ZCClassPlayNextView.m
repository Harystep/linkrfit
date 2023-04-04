//
//  ZCClassPlayNextView.m
//  PowerDance
//
//  Created by PC-N121 on 2022/4/1.
//

#import "ZCClassPlayNextView.h"
#import <AVFoundation/AVFoundation.h>

@interface ZCClassPlayNextView ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *nameL;

@property (nonatomic,strong) UILabel *signL;

@end

@implementation ZCClassPlayNextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    [self setViewColorAlpha:0.82 color:[ZCConfigColor whiteColor]];
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self).inset(AUTO_MARGIN(20));
        make.bottom.mas_equalTo(self.mas_bottom).inset(AUTO_MARGIN(60));
        make.height.mas_equalTo(AUTO_MARGIN(122));
    }];
    [contentView setViewCornerRadiu:10];
    contentView.backgroundColor = rgba(246, 246, 246, 1);
    
    self.iconIv = [[UIImageView alloc] init];
    [self.iconIv setViewContentMode:UIViewContentModeScaleAspectFit];
    [self.iconIv setViewCornerRadiu:10];
    [contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(contentView).inset(AUTO_MARGIN(12));
        make.width.mas_equalTo(AUTO_MARGIN(75));
        make.leading.mas_equalTo(contentView.mas_leading).offset(AUTO_MARGIN(60));
    }];
    
    UILabel *lb = [self createSimpleLabelWithTitle:NSLocalizedString(@"下一个动作", nil) font:AUTO_MARGIN(14) bold:YES color:[ZCConfigColor txtColor]];
    self.signL = lb;
    [contentView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView.mas_top).offset(AUTO_MARGIN(35));
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(12));
    }];
    
    self.nameL = [self createSimpleLabelWithTitle:@"" font:14 bold:NO color:[ZCConfigColor txtColor]];
//    [self.nameL setContentLineFeedStyle];
    self.nameL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:self.nameL];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(AUTO_MARGIN(12));
        make.top.mas_equalTo(lb.mas_bottom).offset(AUTO_MARGIN(22));
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    if ([dataDic[@"rest"] integerValue] == 1) {
        self.iconIv.image = kIMAGE(@"rest");
    } else {
        self.iconIv.image = [self getVideoPreViewImage:[NSURL fileURLWithPath:checkSafeContent(dataDic[@"url"])]];
    }
    self.nameL.text = checkSafeContent(dataDic[@"name"]);
}

// 获取网络视频第一帧
- (UIImage *) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

- (void)setSignFirstFlag:(NSInteger)signFirstFlag {
    _signFirstFlag = signFirstFlag;
    if (signFirstFlag) {
        self.signL.text = NSLocalizedString(@"第一个动作", nil);
    } else {
        self.signL.text = NSLocalizedString(@"下一个动作", nil);;
    }
}

@end
