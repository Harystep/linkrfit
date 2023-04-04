//
//  CFFHUD.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/22.
//

#import "CFFHud.h"

#define KZCAppWindow                       [[UIApplication sharedApplication].delegate window]

//错误代码示例
typedef NS_ENUM(NSUInteger, CFFHudType) {
    CFFHudTypeDefault     = 1 << 0,
    CFFHudTypeSuccess     = 1 << 1,
    CFFHudTypeLoading     = 1 << 2,
    CFFHudTypeError       = 1 << 3
};


@interface CFFHud ()

@property (nonatomic,strong) UIView *bg;
@property (nonatomic,strong) UILabel *lblMsg;
@property (nonatomic,strong) UIImageView *imgIcon;

@property (nonatomic,assign) CFFHudType type;
@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) UIActivityIndicatorView *icon_loading;


@end

@implementation CFFHud

- (instancetype) initWithType:(CFFHudType)type title:(NSString *)title{
    self = [super init];
    if (self) {
        self.type = type;
        self.title = title;
        self.contentView.backgroundColor = [UIColor clearColor];
//        self.clickBackViewToHide = YES;
        [self.contentView addSubview:self.bg];
        if (type == CFFHudTypeLoading) {
            [self.contentView addSubview:self.icon_loading];
        }else{
            [self.contentView addSubview:self.imgIcon];
        }
        
        if ([title isAvailable]) {
            [self.contentView addSubview:self.lblMsg];
        }
        self.animationStyle = DRCPopupViewAnimationStyleFadeIn;
        
        [self makeConstraints];
        @weakify(self);
        [[RACObserve(self, title) ignore:nil] subscribeNext:^(NSString *title) {
            @strongify(self);
            self.lblMsg.text = title;
        }];
    }
    return self;
}

- (void)makeConstraints {
    if (self.type == CFFHudTypeLoading)  {
        [self.icon_loading mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.height.equalTo(@50);
            if ([self.title isAvailable]){
                make.top.equalTo(self.contentView).offset(36);
            }else {
                make.centerY.equalTo(self.contentView);
            }
            make.centerX.equalTo(self.contentView);
        }];
    }else{
        [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@32);
            make.height.equalTo(@32);
            if ([self.title isAvailable]) {
                make.top.equalTo(self.contentView).offset(36);
            }else{
                make.centerY.equalTo(self.contentView);
            }
            make.centerX.equalTo(self.contentView);
        }];
    }
    
    if ([self.title isAvailable]) {
        [self.lblMsg mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat width = 130;
            CGFloat height = 24;
            make.left.equalTo(@((self.contentSize.width - width) / 2));
            make.top.equalTo(self.contentView).offset(84);
            make.width.equalTo([NSNumber numberWithFloat:width]);
            make.height.equalTo([NSNumber numberWithFloat:height]);
        }];
    }
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
}

+ (void)showSuccessWithTitle:(NSString *)title {
    [self showWithType:CFFHudTypeSuccess title:title];
    
}

+ (void)showErrorWithTitle:(NSString *)title {
    [self showWithType:CFFHudTypeError title:title];
    
}

+ (void)showLoadingWithTitle:(NSString *)title{
    [self showWithType:CFFHudTypeLoading title:title];
}

+ (void)stopLoading {
    CFFHud *currentHud = [self getCurrentHudOnWindow];
    [currentHud.icon_loading stopAnimating];
    [currentHud dismissViewFinished:NULL];
}

+ (CFFHud *)getCurrentHudOnWindow {
    __block CFFHud *hud ;
    [KZCAppWindow.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CFFHud class]]) {
            hud = (CFFHud *)obj;
            *stop = YES;
        }
    }];
    return hud;
}

+ (void)showWithType:(CFFHudType)type title:(NSString *)title {
    CFFHud *exsitedHud = [self getCurrentHudOnWindow];
    if (exsitedHud) {
        [exsitedHud dismissImmediately];
    }
    
    CFFHud *hud = [[CFFHud alloc] initWithType:type title:title];
    [hud showInView:KZCAppWindow];
    
    if (type == CFFHudTypeLoading) {
        [hud.icon_loading startAnimating];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud dismissViewFinished:NULL];
        });
    }
}

- (CGSize)contentSize{
    return CGSizeMake(140, 140);
}

- (CGFloat)animationDuration{
    return 0.2;
}

- (CGFloat)backViewAlpha{
    //这里透明度必须大于0.1，不然backView会不能点击
    return 0.1;
}

- (void)setType:(CFFHudType)type {
    _type = type;
    switch (type) {
        case CFFHudTypeSuccess:{
            
        }break;
        case CFFHudTypeError:{
            
        }break;
        default:
            break;
    }
}

- (UILabel *)lblMsg {
    if (!_lblMsg) {
        _lblMsg = [[UILabel alloc] init];
        _lblMsg.backgroundColor = [UIColor clearColor];
        _lblMsg.textColor = [UIColor whiteColor];
        _lblMsg.textAlignment = NSTextAlignmentCenter;
    }
    return _lblMsg;;
}

- (UIView *)bg {
    if (!_bg) {
        _bg = [[UIView alloc] init];
        _bg.backgroundColor = [UIColor blackColor];
        _bg.alpha = 0.6;
        _bg.layer.cornerRadius = 10;
    }
    return _bg;
}

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
//        _imgIcon.backgroundColor = [UIColor yellowColor];
        if (self.type == CFFHudTypeSuccess ) {
            _imgIcon.image = [UIImage imageNamed:@"hud_success"];
        } else if(self.type == CFFHudTypeError) {
            _imgIcon.image = [UIImage imageNamed:@"hud_error"];
        }
        _imgIcon.contentMode =  UIViewContentModeCenter;
    }
    return _imgIcon;
}

- (UIActivityIndicatorView *)icon_loading {
    if (!_icon_loading) {
        if (@available(iOS 13.0, *)) {
            _icon_loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        } else {
            // Fallback on earlier versions
            _icon_loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }
        _icon_loading.color = [UIColor whiteColor];
    }
    return _icon_loading;
}

@end
