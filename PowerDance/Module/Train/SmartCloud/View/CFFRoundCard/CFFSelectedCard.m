//
//  CFFSelectedCard.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/25.
//

#import "CFFSelectedCard.h"


@implementation CFFSelectedCard


- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self.radioDelegate selectedCardClicked:self];
}

- (void)reset{
    _selected = NO;
}

@end
