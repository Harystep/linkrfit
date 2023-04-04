//
//  CFFSmartRulerDataView.h
//  CofoFit
//
//  Created by PC-N121 on 2021/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFFSmartRulerDataView : UIView

@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *dataL;
@property (nonatomic, copy) void (^btnClickSaveBlock)(NSString *value);
@property (nonatomic, copy) NSString *rulerData;
@property (nonatomic, copy) NSString *unit;

@end

NS_ASSUME_NONNULL_END
