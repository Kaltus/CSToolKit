//
//  CSUploadRequest.m
//  CSToolKit
//
//  Created by chengshu on 2020/7/28.
//  Copyright © 2020 com.cs. All rights reserved.
//

#import "CSUploadRequest.h"

@interface CSUploadRequest ()<NSURLSessionDelegate>

/// 文件上传 response 数组
@property (nonatomic,strong) NSMutableArray *uploadResponseArray;

/// 上传session
@property (nonatomic,strong) NSURLSession *session;

/// 文件上传idx
@property (nonatomic,assign) NSInteger uploadIdx;

/// 上传标识
@property (nonatomic,copy) NSString *uploadId;

@end

@implementation CSUploadRequest

/// 上传文件请求
-(BOOL)uploadFileRequest:(id)target action:(SEL)action uploadUrl:(NSString *)uploadUrl uploadFileModel:(UploadFileModel *)uploadFileModel header:(id)header param:(id)parameter {

    /// 基础参数检查 如果参数不合法，将直接返回No
    if (![self parameterExamine:target action:action uploadUrl:uploadUrl uploadFileModel:uploadFileModel header:header parameter:parameter]) {
        return NO;
    }

    /// 请求
    NSURL *url = [NSURL URLWithString:uploadUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];

    /// 设置分界
    //设置请求体参数的分隔符（请求体分隔符必须在此前面加上两个-）
    NSString *boundaryID = Post_Form_Identifer;
    // 分界线
    NSString *boundary = [NSString stringWithFormat:@"--%@", boundaryID];
    // 分界线结束
    NSString *boundaryEnding = [NSString stringWithFormat:@"--%@--", boundaryID];

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
       [request setValue:contentType forHTTPHeaderField:@"Content-Type"];

    if (header != nil) {

        if ([header isKindOfClass:[CSBaseModel class]]) {

            [request setAllHTTPHeaderFields:[header modelEncapsulationAsDict]];

        }else if ([header isKindOfClass:[NSDictionary class]] || [header isKindOfClass:[NSMutableDictionary class]]) {

            [request setAllHTTPHeaderFields:[NSDictionary dictionaryWithDictionary:header]];

        }else {
            NSLog(@"header为继承自CSBaseModel的对象或者NSDictionary或者NSMutableDictionary的对象");
            return NO;
        }

    }

    NSMutableString *bodyString = [NSMutableString string];

    NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];

    if (parameter != nil) {

        if ([parameter isKindOfClass:[CSBaseModel class]]) {
            parameterDict = [NSMutableDictionary dictionaryWithDictionary:[parameter modelEncapsulationAsDict]];
        }else if ([parameter isKindOfClass:[NSDictionary class]] || [parameter isKindOfClass:[NSMutableDictionary class]]) {
            parameterDict = [NSMutableDictionary dictionaryWithDictionary:parameter];
        }else {
            NSLog(@"header为继承自CSBaseModel的对象或者NSDictionary或者NSMutableDictionary的对象");
            return NO;
        }

    }

    if (parameterDict.allKeys.count > 0) {

        for (NSString *key in [parameterDict allKeys]) {

            // 添加分界线，换行
            [bodyString appendFormat:@"%@\r\n", boundary];

            // 添加参数名称，换2行
            [bodyString appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
            [bodyString appendFormat:@"%@\r\n", [parameterDict objectForKey:key]];
        }
    }

    // 添加分界线，换行
    [bodyString appendFormat:@"%@\r\n", boundary];

    // 组装文件类型参数, 换行
    NSString *fileParamName = uploadFileModel.name; // 文件参数名
        NSString *filename = uploadFileModel.fileName;
      [bodyString appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fileParamName, filename];
      // 声明上传文件的格式，换2行

    NSString *fileType = uploadFileModel.contentType;
    [bodyString appendFormat:@"Content-Type: %@\r\n\r\n", fileType];

    // 声明 http body data
    NSMutableData *bodyData = [NSMutableData data];
    // 将 body 字符串 bodyString 转化为UTF8格式的二进制数据
    NSData *bodyParamData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [bodyData appendData:bodyParamData];

    [bodyData appendData:uploadFileModel.fileData];

    [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]]; // image数据添加完后 加一个换行

    // 分界线结束符加入（以 NSData 形式）
    NSString *boundryEndingWithReturn = [NSString stringWithFormat:@"%@\r\n", boundaryEnding]; // 分界线结束符加换行
    NSData *boundryEndingData = [boundryEndingWithReturn dataUsingEncoding:NSUTF8StringEncoding];
    [bodyData appendData:boundryEndingData];
    // 设置 http body data
    request.HTTPBody = bodyData;

    NSString *content = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundaryID];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
         // 设置 Content-Length
    [request setValue:[NSString stringWithFormat:@"%@", @(bodyData.length)] forHTTPHeaderField:@"Content-Length"];
         // 设置请求方式 POST
    request.HTTPMethod = @"POST";

    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    dataTask.taskDescription = self.uploadId;
    
    [dataTask resume];

     self.uploadIdx++;

    return YES;

}

/// 参数检查
-(BOOL)parameterExamine:(id)target action:(SEL)action uploadUrl:(NSString *)uploadUrl uploadFileModel:(UploadFileModel *)uploadFileModel header:(id)header parameter:(id)parameter {

    if (target == nil) {
        NSLog(@"委托对象为空，请传入一个委托对象");
        return NO;
    }

    if (action == nil) {

        NSLog(@"代理方法为空，请传入一个代理方法");
        return NO;

    }

    if (uploadUrl == nil ||[uploadUrl isEqualToString:@""]) {
        NSLog(@"上传文件的地址为空");
        return NO;
    }

    if (uploadFileModel == nil) {

        NSLog(@"文件上传模型为空");
        return NO;
    }


    UploadFileResponseModel *uploadResponseModel = [UploadFileResponseModel CSInit];
    uploadResponseModel.target = target;
    uploadResponseModel.action = action;
    uploadResponseModel.uploadUrl = uploadUrl;

    uploadResponseModel.uploadFileModel = [UploadFileModel dictEncapsulationAsModel:[uploadFileModel modelEncapsulationAsDict]];

    if (header != nil) {

        if ([header isKindOfClass:[CSBaseModel class]]) {
            uploadResponseModel.uploadReqeustHeader = [[header class] dictEncapsulationAsModel:[header modelEncapsulationAsDict]];
        }else if ([header isKindOfClass:[NSDictionary class]] || [header isKindOfClass:[NSMutableDictionary class]]) {
            uploadResponseModel.uploadReqeustHeader = header;
        }else {
            NSLog(@"传入参数异常，请传入一个字典或者继承自CSBaseModel的模型");
            return NO;
        }
    }

    if (parameter != nil) {

        if ([parameter isKindOfClass:[CSBaseModel class]]) {
            uploadResponseModel.uploadParameter = [[parameter class] dictEncapsulationAsModel:[header modelEncapsulationAsDict]];
        }else if ([parameter isKindOfClass:[NSDictionary class]] || [parameter isKindOfClass:[NSMutableDictionary class]]) {
            uploadResponseModel.uploadParameter = parameter;
        }else {
            NSLog(@"传入参数异常，请传入一个字典或者继承自CSBaseModel的模型");
            return NO;
        }
    }

    uploadResponseModel.uploadIdentifer = self.uploadId;

    [self.uploadResponseArray addObject:uploadResponseModel];



    return YES;

}

#pragma mark - NSURLSession代理

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {

        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential , card);
    }
}

/// 接收到服务器响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {

    completionHandler(NSURLSessionResponseAllow);

}

/// 接收到服务器的数据（此方法在接收数据过程会多次调用）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {

    __block UploadFileResponseModel *responseModel = nil;

       [self.uploadResponseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

           UploadFileResponseModel *model = obj;

           if ([model.uploadIdentifer isEqualToString:dataTask.taskDescription]) {
               responseModel = model;
           }

       }];

    [responseModel.responseData appendData:data];


}

/// 任务完成时调用（如果成功，error == nil）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

    
    NSHTTPURLResponse *responese = (NSHTTPURLResponse *)task.response;
    
   __block UploadFileResponseModel *responseModel = nil;

    [self.uploadResponseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {


        UploadFileResponseModel *model = obj;

        if ([model.uploadIdentifer isEqualToString:task.taskDescription]) {
            responseModel = model;
        }

    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (error == nil) {
            
            responseModel.responseHeader = responese.allHeaderFields;
            
            
            @try {
                
                responseModel.responseDataDict = [NSJSONSerialization JSONObjectWithData:responseModel.responseData options:NSJSONReadingMutableLeaves error:nil];
                
            } @catch (NSException *exception) {
                
                responseModel.responseMessage = @"数据解析异常";
                
                if ([self.delegate respondsToSelector:@selector(uploadFileComplete:responseModel:)]) {
                    [self.delegate uploadFileComplete:UploadFailed responseModel:responseModel];
                }
                
                if ([responseModel.target respondsToSelector:responseModel.action]) {
                    
                    ((void(*)(id,SEL,UploadFileCompleteCode,UploadFileResponseModel*))objc_msgSend)(responseModel.target,responseModel.action,UploadFailed,responseModel);
                    
                }
                
                
            } @finally {
                
                responseModel.responseMessage = @"上传文件成功";
                
                if ([self.delegate respondsToSelector:@selector(uploadFileComplete:responseModel:)]) {
                    [self.delegate uploadFileComplete:UploadFailed responseModel:responseModel];
                }
                
                if ([responseModel.target respondsToSelector:responseModel.action]) {
                    
                    ((void(*)(id,SEL,UploadFileCompleteCode,UploadFileResponseModel*))objc_msgSend)(responseModel.target,responseModel.action,UploadFailed,responseModel);
                    
                }
            }
            
        }else {
            
            responseModel.responseMessage = error.localizedRecoverySuggestion;
            
            if ([self.delegate respondsToSelector:@selector(uploadFileComplete:responseModel:)]) {
                [self.delegate uploadFileComplete:UploadFailed responseModel:responseModel];
            }
            
            if ([responseModel.target respondsToSelector:responseModel.action]) {
                
                ((void(*)(id,SEL,UploadFileCompleteCode,UploadFileResponseModel*))objc_msgSend)(responseModel.target,responseModel.action,UploadFailed,responseModel);
                
            }
            
        }

        
    });

}


#pragma mark - getter or setter
-(NSURLSession *)session {
    
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}

-(NSMutableArray *)uploadResponseArray {
    
    if (!_uploadResponseArray) {
        _uploadResponseArray = [[NSMutableArray alloc]init];
    }
    return _uploadResponseArray;
}

-(NSString *)uploadId {
    return [NSString stringWithFormat:@"Upload%li",(long)self.uploadIdx];
}

@end
