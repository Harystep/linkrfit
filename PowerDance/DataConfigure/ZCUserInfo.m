//
//  ZCUserInfo.m
//  PowerDance
//
//  Created by PC-N121 on 2021/11/22.
//

#import "ZCUserInfo.h"

static ZCUserInfo *userInfo = nil;

@implementation ZCUserInfo

/*  通过初始化userIfo并保存在本地(单利模式)   */
+ (instancetype)getuserInfoWithDic:(NSDictionary *)dic {
    userInfo = [[ZCUserInfo alloc] initWithDictionary:dic];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"kUserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];//及时存储数据
    return userInfo;
}

- (id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        [self mj_setKeyValues:dic];
    }
    return self;
}

+ (instancetype)shareInstance {
    if (userInfo == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserInfo"];
        if (data) {
            userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            return userInfo;
        }
    }
    return userInfo;
}

/*  退出登陆 */
+ (instancetype)logout {
    userInfo = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserInfo"];
    return userInfo;
}

/*  保存当前userInfo */
+ (void)saveUser:(ZCUserInfo *)userInfo {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"kUserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];//及时存储数据
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
    }
    return self;
}

@end
