//
//  CFFBaseStore.m
//  CofoFit
//
//  Created by PC-N121 on 2021/4/23.
//

#import "CFFBaseStore.h"


@interface CFFBaseStore ()


@end

@implementation CFFBaseStore

- (void)archiveObj:(id)obj toKey:(NSString *)key {
    NSMutableData *mutableData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archive = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
      
    [archive encodeObject:obj];
    [archive finishEncoding];
    if ([mutableData writeToFile:[self archivedPath:key] atomically:YES]) {
//        NSLog(@"归档成功");
    }else {
//        NSLog(@"归档失败");
    }
}

- (id)unArchiveObj:(NSString *)key {
    NSData *resultData = [NSData dataWithContentsOfFile:[self archivedPath:key]];
    NSKeyedUnarchiver *unArchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:resultData];
    id result = [unArchive decodeObject];
    [unArchive finishDecoding];
    return result;;
}

- (void)removeObj:(NSString *)key {
    NSString *path = [self archivedPath:key];
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (exists) {
        bool result = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        if (result) {
            
        }
        
    }
}

- (NSString *)archivedPath:(NSString *)key{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:key];
    return filePath;
}

@end
