//
//  CFFInputBodyDataView.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import "CFFInputBodyDataView.h"

@interface CFFInputBodyDataView ()

@property (nonatomic,strong) UIView *containerWeight;
@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UILabel *lblTitleEng;
@property (nonatomic,strong) UITextField *txtData;

@property (nonatomic,assign) NSInteger dataValue;

@property (nonatomic,strong) UILabel *lblUnit;

@end

@implementation CFFInputBodyDataView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.containerWeight];
        [self.containerWeight addSubview:self.lblTitle];
        [self.containerWeight addSubview:self.lblTitleEng];
        [self addSubview:self.txtData];
        [self addSubview:self.lblUnit];
        [self makeConstraints];
        [self setDataValue:0];
        
        @weakify(self);
        [self addTapGestureWithAction:^{
            @strongify(self);
            [self.txtData becomeFirstResponder];
        }];
        
        [[self.txtData rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            UITextField *txt = (UITextField *)x;
            [self setDataValue:[txt.text intValue]];
            NSLog(@"%@",txt.text);
        }];
    }
    return self;
}

- (void)makeConstraints{
    [self.containerWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
        make.right.equalTo(self);
    }];
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.containerWeight);
            
    }];
    [self.lblTitleEng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self.containerWeight);
        make.top.equalTo(self.lblTitle.mas_bottom).offset(2);
    }];
    
    [self.txtData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(89);
        make.centerY.equalTo(self);
    }];
    
    [self.lblUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
    }];
}

- (void)setDataValue:(NSInteger)value {
    _dataValue = value;
    if (self.type == CFFBodyDataType_Weight) {
        if (value > 0) {
            [kUserStore.saveData setValue:@(value) forKey:@"weight"];
        }
    } else if(self.type == CFFBodyDataType_Height) {
        if (value > 0) {            
            [kUserStore.saveData setValue:@(value) forKey:@"height"];
        }
    }
}

#pragma mark : setter getter

- (void)setType:(CFFBodyDataType)type {
    _type = type;
    switch (_type) {
        case CFFBodyDataType_Weight:{
            _lblTitle.text = NSLocalizedString(@"体重", nil);
            _lblTitleEng.text = @"weight";
            _lblUnit.text = @"KG";
        }break;
        case CFFBodyDataType_Height:{
            _lblTitle.text = NSLocalizedString(@"身高", nil);
            _lblTitleEng.text = @"height";
            _lblUnit.text = @"CM";
        }break;
        default:
            break;
    }
}


#pragma mark : lazy load

- (UIView *)containerWeight {
    if (!_containerWeight) {
        _containerWeight = [[UIView alloc] init];
    }
    return _containerWeight;
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.font = FONT_SYSTEM(14);
    }
    return _lblTitle;
}

- (UILabel *)lblTitleEng {
    if (!_lblTitleEng) {
        _lblTitleEng = [[UILabel alloc] init];
        _lblTitleEng.textColor = [UIColor grayColor];
        _lblTitleEng.font = FONT_SYSTEM(14);
    }
    return _lblTitleEng;
}


- (UITextField *)txtData {
    if (!_txtData) {
        _txtData = [[UITextField alloc] init];
        _txtData.text = @"0";
        _txtData.textColor = [UIColor blackColor];
        _txtData.keyboardType = UIKeyboardTypeDecimalPad;
        _txtData.font = FONT_SYSTEM(14);
    }
    return _txtData;
}

- (UILabel *)lblUnit {
    if (!_lblUnit) {
        _lblUnit = [[UILabel alloc] init];
        _lblUnit.textColor = [UIColor blackColor];
        _lblUnit.font = FONT_SYSTEM(14);
    }
    return _lblUnit;
}


@end
