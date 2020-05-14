//
//  CSDownloadRequest.m
//  CSKit
//
//  Created by chengshu on 2020/4/16.
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

static CSDownloadRequest *downloadRequest = nil;

@implementation CSDownloadRequest

+(CSDownloadRequest *)shareSingleCase {

    if (!downloadRequest) {
        downloadRequest = [[self alloc]init];
    }
    
    return downloadRequest;
}

///下载文件并保存到沙盒
-(BOOL)downloadFile:(id)target action:(SEL)action downloadUrl:(NSString *)downloadUrl toRootFolderPath:(SandBoxFolderType)sandboxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName isCover:(BOOL)isCover {
    
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

    NSString *folderPath = [[CSFileManager shareSingleCase] getFolderPath:sandboxFolderType folderRelativePath:folderRelativePath folderName:@""];
   
    requestModel.folderPath = folderPath;
    
    requestModel.fileName = fileName == nil ? [[downloadUrl componentsSeparatedByString:@"/"] lastObject] : fileName;
    
    [self.requestArray addObject:requestModel];
    
    if (!isCover) {
        
        if ([[CSFileManager shareSingleCase] checkFileExist:requestModel.filePath]) {

               ///完成
            if ([requestModel.target respondsToSelector:@selector(downloadFileProgress:fileUrl:filePath:fileName:)]) {
                [requestModel.target downloadFileProgress:1.0 fileUrl:requestModel.requestUrl filePath:requestModel.filePath fileName:requestModel.fileName];
            }
               
            if ([requestModel.target respondsToSelector:@selector(downloadFileComplete:fileUrl:filePath:fileName:message:)]) {
                [requestModel.target downloadFileComplete:DownloadSucess fileUrl:requestModel.requestUrl filePath:requestModel.filePath fileName:requestModel.fileName message:@"下载文件成功"];
            }
               
            if ([requestModel.target respondsToSelector:requestModel.action]) {
                ((void (*)(id,SEL,DownloadRequestStatus,NSString *,NSString *,NSString *,NSString *)) objc_msgSend)(requestModel.target,requestModel.action,DownloadSucess,requestModel.requestUrl,requestModel.filePath,requestModel.fileName,@"下载文件成功");
            }
        }
        requestModel.isCover = NO;
        return YES;
        
    }else {
        requestModel.isCover = YES;
    }
    
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

-(BOOL)downloadFile:(id)target action:(SEL)action downloadUrl:(NSString *)downloadUrl fileType:(FileType)fileType isCover:(BOOL)isCover{
    
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

    switch (fileType) {
        case FilePublicType:{
            requestModel.folderPath = [[CSFileManager shareSingleCase] getFolderPath:FolderCachesType folderRelativePath:PublicFolder folderName:@""];
        }break;
        case FileImageType:{
             requestModel.folderPath = [[CSFileManager shareSingleCase] getFolderPath:FolderCachesType folderRelativePath:ImageFolder folderName:@""];
        }break;
        case FileVoiceType:{
             requestModel.folderPath = [[CSFileManager shareSingleCase] getFolderPath:FolderCachesType folderRelativePath:VoiceFolder folderName:@""];
        }break;
        case FileVideotype:{
             requestModel.folderPath =  [[CSFileManager shareSingleCase] getFolderPath:FolderCachesType folderRelativePath:VideoFolder folderName:@""];
        }break;
        default:
            break;
    }
    
    requestModel.fileName = [[downloadUrl componentsSeparatedByString:@"/"] lastObject];
    
    if (!isCover) {

        if ([[CSFileManager shareSingleCase] checkFileExist:requestModel.filePath]) {

               ///完成
            if ([requestModel.target respondsToSelector:@selector(downloadFileProgress:fileUrl:filePath:fileName:)]) {
                [requestModel.target downloadFileProgress:1.0 fileUrl:requestModel.requestUrl filePath:requestModel.filePath fileName:requestModel.fileName];
            }

            if ([requestModel.target respondsToSelector:@selector(downloadFileComplete:fileUrl:filePath:fileName:message:)]) {
                [requestModel.target downloadFileComplete:DownloadSucess fileUrl:requestModel.requestUrl filePath:requestModel.filePath fileName:requestModel.fileName message:@"下载文件成功"];
            }

            if ([requestModel.target respondsToSelector:requestModel.action]) {
                ((void (*)(id,SEL,DownloadRequestStatus,NSString *,NSString *,NSString *,NSString *)) objc_msgSend)(requestModel.target,requestModel.action,DownloadSucess,requestModel.requestUrl,requestModel.filePath,requestModel.fileName,@"下载文件成功");
            }


            return YES;
        }

        requestModel.isCover = NO;
    }else {
        requestModel.isCover = YES;
    }
    
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
    
    BOOL folderStatus = [[CSFileManager shareSingleCase] checkFolderExist:requestModel.folderPath];

    if (!folderStatus) {
        [[CSFileManager shareSingleCase] createFolder:requestModel.folderPath];
    }
    
    BOOL status = [[CSFileManager shareSingleCase] moveSrcFilePath:location.absoluteString dstFilePath:requestModel.filePath isCover:requestModel.isCover];
    
    if (status) {

        if ([requestModel.target respondsToSelector:@selector(downloadFileComplete:fileUrl:filePath:fileName:message:)]) {
            [requestModel.target downloadFileComplete:DownloadSucess fileUrl:requestModel.requestUrl filePath:requestModel.filePath fileName:requestModel.fileName message:@"下载文件成功"];
        }

        if ([requestModel.target respondsToSelector:requestModel.action]) {
            ((void (*)(id,SEL,DownloadRequestStatus,NSString *,NSString *,NSString *,NSString *)) objc_msgSend)(requestModel.target,requestModel.action,DownloadSucess,requestModel.requestUrl,requestModel.filePath,requestModel.fileName,@"下载文件成功");
        }

    }else {
        if ([requestModel.target respondsToSelector:@selector(downloadFileComplete:fileUrl:filePath:fileName:message:)]) {
            [requestModel.target downloadFileComplete:DownloadFailed fileUrl:requestModel.requestUrl filePath:requestModel.filePath fileName:requestModel.fileName message:@"文件缓存失败"];
        }

        if ([requestModel.target respondsToSelector:requestModel.action]) {
            ((void (*)(id,SEL,DownloadRequestStatus,NSString *,NSString *,NSString *,NSString *)) objc_msgSend)(requestModel.target,requestModel.action,DownloadFailed,requestModel.requestUrl,requestModel.filePath,requestModel.fileName,@"文件缓存失败");
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



-(id)copyWithZone:(NSZone *)zone{
    
    return downloadRequest;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return downloadRequest;
}


@end
