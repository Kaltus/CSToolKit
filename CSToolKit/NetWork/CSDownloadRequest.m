//
//  CSDownloadRequest.m
//  CSToolKit
//
//  Created by chengshu on 2020/7/28.
//  Copyright © 2020 com.cs. All rights reserved.
//

#import "CSDownloadRequest.h"
#import "DownloadFileResponseModel.h"

@interface CSDownloadRequest ()<NSURLSessionDelegate>

/// 请求响应数组
@property (nonatomic,strong) NSMutableArray *downloadResponseArray;

/// 请求ID
@property (nonatomic,copy) NSString *downloadId;

/// 请求Idx
@property (nonatomic,assign) NSInteger downloadIdx;

/// session 会话任务
@property (nonatomic,strong) NSURLSession *session;

@end

@implementation CSDownloadRequest

/// 下载请求
-(BOOL)downloadRequest:(id)target action:(SEL)action downloadUrl:(NSString *)downloadUrl downloadRequestModel:(DownloadFileModel *)downloadFileModel {
    
    /// 参数检查
    if (![self parameterExamine:target action:action downloadUrl:downloadUrl downloadRequeestModel:downloadFileModel]) {
        return NO;
    }
    
    DownloadFileResponseModel *downloadFileResponseModel = [self.downloadResponseArray lastObject];
    
    if (!downloadFileModel.isCover) {
        
        /// 不覆盖文件，检查文件是否存在。如果存在直接进入回调
        if ([[CSFileManager shareSingleCase] checkFileExist:downloadFileResponseModel.filePath]) {
            
            if ([self.delegate respondsToSelector:@selector(downloadFileComplete:responseModel:)]) {
                [self.delegate downloadFileComplete:DownloadSucess responseModel:downloadFileResponseModel];
            }
          
            if ([downloadFileResponseModel.target respondsToSelector:downloadFileResponseModel.action]) {
                
                ((void(*)(id,SEL,DownloadFileCompleteCode,DownloadFileResponseModel*))objc_msgSend)(downloadFileResponseModel.target,downloadFileResponseModel.action,DownloadSucess,downloadFileResponseModel);
                
            }
            
        }
    }
          
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:downloadUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeOut==0?60.0f:self.timeOut];
            
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:request];
    downloadTask.taskDescription = self.downloadId;
    [downloadTask resume];
       
    self.downloadIdx ++;
    
    return YES;
}

/// 参数检查
-(BOOL)parameterExamine:(id)target action:(SEL)action downloadUrl:(NSString *)downloadUrl downloadRequeestModel:(DownloadFileModel *)downloadFileModel {
    
    if (target == nil) {
        return NO;
    }
    
    if (action == nil) {
        return NO;
    }
    
    if (downloadUrl == nil || [downloadUrl isEqualToString:@""]) {
        return NO;
    }
    
    if (downloadFileModel == nil) {
        return NO;
    }
    
    DownloadFileResponseModel *downloadFileResponseModel = [DownloadFileResponseModel CSInit];
    
    downloadFileResponseModel.target = target;
    downloadFileResponseModel.action = action;
    downloadFileResponseModel.downloadUrl = downloadUrl;
    downloadFileResponseModel.progress = 0;
    downloadFileResponseModel.downloadId = self.downloadId;
    downloadFileResponseModel.isCover = downloadFileModel.isCover;
    if (downloadFileModel.fileName == nil || [downloadFileModel.fileName isEqualToString:@""]) {
        
        downloadFileModel.fileName = [[downloadUrl componentsSeparatedByString:@"/"] lastObject];
        
    }
    
    downloadFileResponseModel.folderPath = [[CSFileManager shareSingleCase] getFolderPath:downloadFileModel.folderType folderRelativePath:downloadFileModel.relativePath folderName:@""];
    
    downloadFileResponseModel.filePath = [[CSFileManager shareSingleCase] getFilePath:downloadFileModel.folderType folderRelativePath:downloadFileModel.relativePath fileName:downloadFileModel.fileName];
    
    downloadFileResponseModel.fileName = downloadFileModel.fileName;
    
    /// 创建文件夹
    if (![[CSFileManager shareSingleCase] checkFolderExist:downloadFileResponseModel.folderPath]) {
        [[CSFileManager shareSingleCase] createFolder:downloadFileResponseModel.folderPath];
    }
   
    
    [self.downloadResponseArray addObject:downloadFileResponseModel];
    
    return YES;
}

#pragma mark - NSURLSessionDelegate
#pragma mark - NSURLSessionDownloadDelegate 代理
/// 下载过程中调用
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    __block DownloadFileResponseModel *responseModel = nil;
    
    [self.downloadResponseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        DownloadFileResponseModel *model = obj;
        
        if ([model.downloadId isEqualToString:downloadTask.taskDescription]) {
            responseModel = model;
        }
        
    }];
    
    responseModel.progress = (CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite;
    
    if ([self.delegate respondsToSelector:@selector(downloading:)]) {
        [self.delegate downloading:responseModel];
    }
    
}

/// 下载完成
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
     __block DownloadFileResponseModel *responseModel = nil;
       
       [self.downloadResponseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          
           DownloadFileResponseModel *model = obj;
           
           if ([model.downloadId isEqualToString:downloadTask.taskDescription]) {
               responseModel = model;
           }
           
       }];
    
    BOOL moveStatus = [[CSFileManager shareSingleCase] moveSrcFilePath:location.absoluteString dstFilePath:responseModel.filePath isCover:responseModel.isCover];
    
    if (moveStatus) {
        
         responseModel.message = @"文件下载成功";
        
        if ([self.delegate respondsToSelector:@selector(downloadFileComplete:responseModel:)]) {
            [self.delegate downloadFileComplete:DownloadSucess responseModel:responseModel];
        }
        
        if ([responseModel.target respondsToSelector:responseModel.action]) {
            
           ((void(*)(id,SEL,DownloadFileCompleteCode,DownloadFileResponseModel*))objc_msgSend)(responseModel.target,responseModel.action,DownloadSucess,responseModel);
            
        }
        
    }else {
        
        responseModel.message = @"文件下载失败";
        
        if ([self.delegate respondsToSelector:@selector(downloadFileComplete:responseModel:)]) {
            [self.delegate downloadFileComplete:DownloadFailed responseModel:responseModel];
        }
        
        if ([responseModel.target respondsToSelector:responseModel.action]) {
            
           ((void(*)(id,SEL,DownloadFileCompleteCode,DownloadFileResponseModel*))objc_msgSend)(responseModel.target,responseModel.action,DownloadFailed,responseModel);
            
        }
        
    }
}

#pragma mark - getter or setter

-(NSMutableArray *)downloadResponseArray {
    
    if (!_downloadResponseArray) {
        _downloadResponseArray = [[NSMutableArray alloc]init];
    }
    return _downloadResponseArray;
}

-(NSString *)downloadId {
    
    return [NSString stringWithFormat:@"download%ld",(long)self.downloadIdx];
    
}

-(NSURLSession *)session {
    
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}

@end
