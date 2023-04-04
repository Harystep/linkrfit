//
//  ZCPhotoManage.m
//  PowerDance
//
//  Created by PC-N121 on 2022/3/25.
//

#import "ZCPhotoManage.h"

@interface ZCPhotoManage ()

@property (nonatomic,strong) NSURL *movieURL;

@end

@implementation ZCPhotoManage

#pragma mark - loadData

- (void)newLoadData:(NSURL *)pathUrl completeHandler:(void (^)(id responseObj))completerHandler{
    
    NSString *documentsDirectory = [self videoFilePath];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString  *fullPath = [NSString stringWithFormat:@"%@%@", documentsDirectory, [[NSFileManager defaultManager] displayNameAtPath:pathUrl.path]];
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
    if (isExists) {
        NSLog(@"文件已存在");
        completerHandler(@{@"code":@"200", @"path":fullPath});
    } else {        
        NSURL *url = pathUrl;
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLSessionDownloadTask *downTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //            self.progressView.hidden = NO;
                //            self.progressView.progress = downloadProgress.completedUnitCount*1.0/downloadProgress.totalUnitCount;
            });
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            return [NSURL fileURLWithPath:fullPath];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            NSLog(@"%@--%@", response, error);
            if (error != nil) {
                completerHandler(@{@"code":@"400", @"path":fullPath});
            } else {
                completerHandler(@{@"code":@"200", @"path":fullPath});
            }
        
        }];
        [downTask resume];
    }
    
}
- (NSString *)videoFilePath {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"clockin_movie_file"];
    return filePath;
}


@end
