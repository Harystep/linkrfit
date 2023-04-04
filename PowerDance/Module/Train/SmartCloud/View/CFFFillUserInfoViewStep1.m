//
//  CFFFillUserInfoViewStep1.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import "CFFFillUserInfoViewStep1.h"
#import "CFFBasicRoundCard.h"
#import "CFFSelectGenderCard.h"
#import "CFFInputBirthdayCard.h"
#import "CFFInputBodyCard.h"

@interface CFFFillUserInfoViewStep1 ()

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) CFFSelectGenderCard *card1;
@property (nonatomic,strong) CFFInputBirthdayCard *card2;
@property (nonatomic,strong) CFFInputBodyCard *card3;

@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,assign) CGFloat viewHeight;

@end


@implementation CFFFillUserInfoViewStep1

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.containerView];
        [self.containerView addSubview:self.card1];
        [self.containerView addSubview:self.card2];
        [self.containerView addSubview:self.card3];
        [self makeConstraints];
    }
    return self;
}

- (void) makeConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.bottom.equalTo(self.card3.mas_bottom).offset(20);
    }];
    CGFloat cardHeight = 160;
    [self.card1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(15);
        make.right.equalTo(self.containerView.mas_right).offset(-15);
        make.top.equalTo(self.containerView).offset(20);
        make.height.equalTo(@(cardHeight));
    }];
    [self.card2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.card1);
        make.top.equalTo(self.card1.mas_bottom).offset(20);
        make.height.equalTo(@(cardHeight));
    }];
    [self.card3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.card1);
        make.height.equalTo(@(cardHeight));
        make.top.equalTo(self.card2.mas_bottom).offset(20);
    }];
}

#pragma  mark : lazy load
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _scrollView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView  = [[UIView alloc] init];
    }
    return _containerView;
}

- (CFFSelectGenderCard *)card1 {
    if (!_card1) {
        _card1 = [[CFFSelectGenderCard alloc] init];
    }
    return _card1;
}
- (CFFInputBirthdayCard *)card2 {
    if (!_card2) {
        _card2 = [[CFFInputBirthdayCard alloc] init];
    }
    return _card2;
}
- (CFFInputBodyCard *)card3 {
    if (!_card3) {
        _card3 = [[CFFInputBodyCard alloc] init];
    }
    return _card3;
}

@end
