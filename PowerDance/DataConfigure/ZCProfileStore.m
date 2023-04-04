//
//  ZCProfileStore.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/29.
//

#import "ZCProfileStore.h"


@implementation ZCProfileStore

+ (instancetype)shareInstance {
    static dispatch_once_t _once;
    static ZCProfileStore *_instance = nil;
    dispatch_once(&_once, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

@end
