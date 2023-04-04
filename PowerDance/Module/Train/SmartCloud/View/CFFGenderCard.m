//
//  CFFGenderCard.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import "CFFGenderCard.h"


@interface CFFGenderCard ()

@property (nonatomic,strong) UIImageView *pic;
@property (nonatomic,strong) UIView *picBg;
@property (nonatomic,strong) UIButton *btnRadio;


@end

@implementation CFFGenderCard

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.picBg];
        [self addSubview:self.pic];
        [self addSubview:self.btnRadio];
        
        @weakify(self);
        [self addTapGestureWithAction:^{
            @strongify(self);
           [self setSelected:YES];
        }];
        [kUserStore.saveData setValue:@(0) forKey:@"sex"];//初始化数据
        [self makeConstraints];
    }
    return self;
}

#pragma mark - funcs

- (void)makeConstraints {
    [self.picBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.btnRadio.mas_top).offset(-10);
    }];
    
    [self.pic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.picBg);
    }];
    
    [self.btnRadio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
}


#pragma mark - getter setter

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [_btnRadio setSelected:selected];
    if (self.gender == CFFGender_Male) {
        [kUserStore.saveData setValue:@(0) forKey:@"sex"];
    } else {
        [kUserStore.saveData setValue:@(1) forKey:@"sex"];
    }
}

- (void)reset {
    [super reset];
    [_btnRadio setSelected:NO];
}

- (void)setGender:(CFFGender)gender{
    _gender = gender;
    switch (gender) {
        case CFFGender_Male:{
            _pic.image = [UIImage imageNamed:@"gender_male_pic"];
            
        }break;
        case CFFGender_Female:{
            _pic.image = [UIImage imageNamed:@"gender_female_pic"];
        }break;
        default:
            break;
    }
}

#pragma mark - lazy load

- (UIImageView *)pic {
    if (!_pic) {
        _pic = [[UIImageView alloc] init];
        _pic.userInteractionEnabled = NO;
    }
    return _pic;
}

- (UIView *) picBg {
    if (!_picBg) {
        _picBg = [[UIView alloc] init];;
//        _picBg.backgroundColor = RGB_COLOR(229, 229, 229);
        _picBg.layer.cornerRadius = 10;
        _pic.userInteractionEnabled = NO;
    }
    return _picBg;;
}

- (UIButton *)btnRadio {
    if (!_btnRadio) {
        _btnRadio.userInteractionEnabled = NO;
        _btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRadio.layer.cornerRadius = 7.5;
        _btnRadio.clipsToBounds = YES;
        _btnRadio.userInteractionEnabled = NO;
        _btnRadio.layer.borderWidth = 1;
        _btnRadio.layer.borderColor = [UIColor clearColor].CGColor;
        
        [_btnRadio setBackgroundImage:[UIImage cff_imageWithColor:RGB_COLOR(239, 239, 239) size:CGSizeMake(15, 15)] forState:UIControlStateNormal];
        [_btnRadio setImage:[UIImage cff_imageWithColor:RGB_COLOR(239, 239, 239) size:CGSizeMake(8, 8) cornerRadius:4] forState:UIControlStateNormal];
        [_btnRadio setImage:[UIImage cff_imageWithColor:rgba(43, 42, 51, 1) size:CGSizeMake(8, 8) cornerRadius:4] forState:UIControlStateSelected];
    }
    return _btnRadio;;
}

@end
