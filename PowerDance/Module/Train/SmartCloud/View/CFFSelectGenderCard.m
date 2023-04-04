//
//  CFFSelectGenderCard.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import "CFFSelectGenderCard.h"
#import "CFFGenderCard.h"

@interface CFFSelectGenderCard ()

@property (nonatomic,strong) UIView *container;
@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UILabel *lblTitleEng;

@property (nonatomic,strong) CFFGenderCard *selectMaleButton;
@property (nonatomic,strong) CFFGenderCard *selectFemaleButton;

@property (nonatomic,strong) NSArray *selectButtons;

@end

@implementation CFFSelectGenderCard

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = kCFF_COLOR_GRAY_COMMON;
        [self addSubview:self.container];
        [self.container addSubview:self.lblTitle];
        [self.container addSubview:self.lblTitleEng];
        
        [self addSubview:self.selectMaleButton];
        [self addSubview:self.selectFemaleButton];
        
        self.selectMaleButton.radioDelegate = self;
        self.selectFemaleButton.radioDelegate = self;
        
        self.selectMaleButton.gender = CFFGender_Male;
        self.selectFemaleButton.gender = CFFGender_Female;
        self.selectMaleButton.selected = YES;
        
        self.selectButtons = @[self.selectMaleButton,self.selectFemaleButton];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
        make.right.equalTo(self);
    }];
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.container);
            
    }];
    [self.lblTitleEng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self.container);
        make.top.equalTo(self.lblTitle.mas_bottom).offset(2);
    }];
    
    [self.selectMaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.selectFemaleButton.mas_left).offset(-44);
        make.height.equalTo(@125);
        make.width.equalTo(@70);
    }];
    
    [self.selectFemaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-22);
        make.height.equalTo(@125);
        make.width.equalTo(@70);
    }];
}

#pragma mark - CFFSelectedCardRadioDelegate

- (void)selectedCardClicked:(id _Nullable)obj {
    if ([obj isKindOfClass:[CFFGenderCard class]]) {
        for (CFFGenderCard *card in self.selectButtons) {
            if (card != obj) {
                [card reset];
            }else{
                
            }
        }
    }
}

#pragma mark : lazy load

- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
    }
    return _container;
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.text = NSLocalizedString(@"性别", nil);
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.font = FONT_SYSTEM(14);
    }
    return _lblTitle;
}

- (UILabel *)lblTitleEng {
    if (!_lblTitleEng) {
        _lblTitleEng = [[UILabel alloc] init];
        _lblTitleEng.text = NSLocalizedString(@"gender", nil);
        _lblTitleEng.textColor = [UIColor grayColor];
        _lblTitleEng.font = FONT_SYSTEM(14);
    }
    return _lblTitleEng;
}

- (CFFGenderCard *)selectMaleButton {
    if (!_selectMaleButton) {
        _selectMaleButton = [[CFFGenderCard alloc] init];
    }
    return _selectMaleButton;;
}

- (CFFGenderCard *)selectFemaleButton {
    if (!_selectFemaleButton) {
        _selectFemaleButton = [[CFFGenderCard alloc] init];
    }
    return _selectFemaleButton;;
}



@end
