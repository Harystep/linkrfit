//
//  CFFSmartPersonView.h
//  CofoFit
//
//  Created by PC-N121 on 2021/9/13.
//

#import <UIKit/UIKit.h>
@class CFFSmartRulerDataView;

NS_ASSUME_NONNULL_BEGIN

@interface CFFSmartPersonView : UIView

@property (nonatomic, copy) void (^saveRulerDataBlock)(NSString *value);

@property (nonatomic, copy) void (^uploadRulerDataStatusBlock)(NSDictionary *parms);

@property (nonatomic,strong) NSMutableDictionary *parms;

@property (nonatomic, copy) NSString *rulerData;

@property (nonatomic,assign) NSInteger status;

@property (nonatomic,strong) CFFSmartRulerDataView *dataView;

@end

NS_ASSUME_NONNULL_END
