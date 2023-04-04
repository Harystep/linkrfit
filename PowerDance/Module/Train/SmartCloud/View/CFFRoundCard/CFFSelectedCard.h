//
//  CFFSelectedCard.h
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "CFFBasicRoundCard.h"

@class CFFRadioButtonHandle;

@protocol CFFSelectedCardRadioDelegate <NSObject>

- (void)selectedCardClicked:(id _Nullable)card;

@end


NS_ASSUME_NONNULL_BEGIN

@interface CFFSelectedCard : CFFBasicRoundCard

@property (nonatomic,assign) BOOL selected;

- (void)reset;

@property (nonatomic,weak) id <CFFSelectedCardRadioDelegate> radioDelegate;

@end



NS_ASSUME_NONNULL_END
