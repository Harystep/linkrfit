//
//  CFFBaseStore.h
//  CofoFit
//
//  Created by PC-N121 on 2021/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFFBaseStore : NSObject

- (void)archiveObj:(id)obj toKey:(NSString *)key;

- (id)unArchiveObj:(NSString *)key;

- (void)removeObj:(NSString *)key ;

@end

NS_ASSUME_NONNULL_END
