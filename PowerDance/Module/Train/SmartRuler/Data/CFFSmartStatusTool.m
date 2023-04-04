//
//  CFFSmartStatusTool.m
//  CofoFit
//
//  Created by PC-N121 on 2021/9/9.
//

#import "CFFSmartStatusTool.h"

@implementation CFFSmartStatusTool

+ (void)saveSmartStatus:(NSInteger)status {
    [[NSUserDefaults standardUserDefaults] setInteger:status forKey:@"kSaveSmartStatusKey"];
}

+ (NSInteger)getSmartStatus {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"kSaveSmartStatusKey"];
}

@end
