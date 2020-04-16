//
//  CSDownloadRequest.m
//  CSKit
//
//  Created by fengzhong-ios-chengshu on 2020/4/16.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSDownloadRequest.h"
#import <objc/message.h>
#import "DownloadRequestModel.h"

@interface  CSDownloadRequest() <NSURLSessionDownloadDelegate>

///Session会话
@property (nonatomic,strong)NSURLSession *session;

///Task任务
@property (nonatomic,strong)NSURLSessionDownloadTask *downloadTask;

///请求模型数组
@property (nonatomic,strong) NSMutableArray *requestArray;

///请求标识
@property (nonatomic,assign) NSInteger requestIdentifer;

@end

@implementation CSDownloadRequest

///下载文件并保存到沙盒
-(BOOL)downloadFile:(id)target action:(SEL)action downloadUrl:(NSString *)downloadUrl toRootFolderPath:(SandBoxFolderType)sandboxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName {
    
    DownloadRequestModel *requestModel = [DownloadRequestModel CSInit];
    
    if (target == nil) {
        return NO;
    }
    requestModel.target = target;
    
    requestModel.action = action;
    
    if (downloadUrl == nil||[downloadUrl isEqualToString:@""]) {
        
        if ([requestModel.target respondsToSelector:@selector(downloadFileComplete:fileUrl:filePath:fileName:message:)]) {
                  [requestModel.target downloadFileComplete:DownloadFailed fileUrl:requestModel.requestUrl filePath:requestModel.filePath fileName:requestModel.fileName message:@"下载文件的URL为空"];
              }
              
            if ([requestModel.target respondsToSelector:requestModel.action]) {
                  ((void (*)(id,SEL,DownloadRequestStatus,NSString *,NSString *,NSString *,NSString *)) objc_msgSend)(requestModel.target,requestModel.action,DownloadFailed,requestModel.requestUrl,requestModel.filePath,requestModel.fileName,@"下载文件的URL为空");
            }
        
        return NO;
    }
    
    requestModel.requestUrl = downloadUrl;
    
    NSString *rootPath = [[CSFileHandle shareSingleCase] getSandboxFolder:sandboxFolderType];
    
    NSString *folderPath = [rootPath stringByAppendingPathComponent:folderRelativePath];
    
    requestModel.folderPath = folderPath;
    
    requestModel.fileName = fileName == nil ? [[downloadUrl componentsSeparatedByString:@"/"] lastObject] : fileName;
    
    [self.requestArray addObject:requestModel];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.name = [NSString stringWithFormat:@"%li",(long)self.requestIdentifer];
    requestModel.identifer = [NSString stringWithFormat:@"%li",(long)self.requestIdentifer];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];
           
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:downloadUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeOut==0?60.0f:self.timeOut];
           
    self.downloadTask = [self.session downloadTaskWithRequest:request];
           
    [self.downloadTask resume];
    
    self.requestIdentifer ++;
    
    return YES;
}

#pragma mark - NSURLSessionDownloadDelegate 代理
/// 下载过程中调用
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    __block DownloadRequestModel *requestModel = nil;
    
    [self.requestArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        DownloadRequestModel *model = obj;
        if ([model.identifer isEqualToString:session.delegateQueue.name]) {
            requestModel = model;
            *stop = YES;
        }
        
    }];
    
    if ([requestModel.target respondsToSelector:@selector(downloadFileProgress:fileUrl:filePath:fileName:)]) {
        
        [requestModel.target downloadFileProgress:totalBytesWritten/totalBytesExpectedToWrite fileUrl:requestModel.requestUrl filePath:requestModel.filePath fileName:requestModel.fileName];
        
    }
    
}

/// 下载完成了
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    __block DownloadRequestModel *requestModel = nil;
    
    [self.requestArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        DownloadRequestModel *model = obj;
        if ([model.identifer isEqualToString:session.delegateQueue.name]) {
            requestModel = model;
            *stop = YES;
        }
        
    }];
    
    NSError *error = nil;
    
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:requestModel.filePath] error:&error];
    
    if (error == nil) {
        
        if ([requestModel.target respondsToSelector:@selector(downloadFileComplete:fileUrl:filePath:fileName:message:)]) {
            [requestModel.target downloadFileComplete:DownloadSucess fileUrl:requestModel.requestUrl filePath:requestModel.filePath fileName:requestModel.fileName message:@"下载文件成功"];
        }
        
        if ([requestModel.target respondsToSelector:requestModel.action]) {
            ((void (*)(id,SEL,DownloadRequestStatus,NSString *,NSString *,NSString *,NSString *)) objc_msgSend)(requestModel.target,requestModel.action,DownloadSucess,requestModel.requestUrl,requestModel.filePath,requestModel.fileName,@"下载文件成功");
        }
        
    }else {
        if ([requestModel.target respondsToSelector:@selector(downloadFileComplete:fileUrl:filePath:fileName:message:)]) {
            [requestModel.target downloadFileComplete:DownloadFailed fileUrl:requestModel.requestUrl filePath:requestModel.filePath fileName:requestModel.fileName message:error.description];
        }
        
        if ([requestModel.target respondsToSelector:requestModel.action]) {
            ((void (*)(id,SEL,DownloadRequestStatus,NSString *,NSString *,NSString *,NSString *)) objc_msgSend)(requestModel.target,requestModel.action,DownloadFailed,requestModel.requestUrl,requestModel.filePath,requestModel.fileName,error.description);
        }
    }
    
}

#pragma mark - Getter and Setter
-(NSMutableArray *)requestArray {
    
    if (!_requestArray) {
        _requestArray = [[NSMutableArray alloc]init];
    }
    return _requestArray;
}

@end
