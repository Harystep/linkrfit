//
//  CFFInputBodyDataView.h
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, CFFBodyDataType) {
    CFFBodyDataType_Weight     = 1 << 0,
    CFFBodyDataType_Height     = 1 << 1
};

NS_ASSUME_NONNULL_BEGIN

@interface CFFInputBodyDataView : UIView

@property (nonatomic,assign) CFFBodyDataType type;

@end

NS_ASSUME_NONNULL_END
