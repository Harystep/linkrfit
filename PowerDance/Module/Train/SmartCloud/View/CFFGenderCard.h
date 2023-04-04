//
//  CFFGenderCard.h
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "CFFBasicRoundCard.h"
#import "CFFSelectedCard.h"
#import "CFFTypeDefineEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface CFFGenderCard : CFFSelectedCard

@property (nonatomic,assign) CFFGender gender;


@end

NS_ASSUME_NONNULL_END
