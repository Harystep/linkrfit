//
//  CFFHomeLastWeightView.h
//  CofoFit
//
//  Created by PC-N121 on 2021/10/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFFHomeLastWeightView : UIView

@property (nonatomic, assign) double value;

@property (nonatomic,strong) UILabel *weightL;

@property (nonatomic,strong) UIButton *cloudBtn;

@property (nonatomic,strong) UIButton *changeBtn;

@property (nonatomic,strong) UILabel *timeL;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,strong) UILabel *unitL;

@end

NS_ASSUME_NONNULL_END
