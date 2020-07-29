//
//  CSRequest.m
//  CSToolKit
//
//  Created by chengshu on 2020/7/28.
//  Copyright © 2020 com.cs. All rights reserved.
//

#import "CSRequest.h"

#import "ResponseModel.h"

@interface CSRequest ()<NSURLSessionDelegate>

/// 请求响应数组
@property (nonatomic,strong) NSMutableArray *responseArray;

/// 请求ID
@property (nonatomic,copy) NSString *requestID;

/// 请求Idx
@property (nonatomic,assign) NSInteger requestIdx;

/// session 会话
@property (nonatomic,strong) NSURLSession *session;

@end

@implementation CSRequest

/// post请求
-(BOOL)postRequest:(id)target action:(SEL)action requestUrl:(NSString *)requestUrl header:(id)header parameter:(id)parameter {
    
    if (![self parameterExamine:target action:action requestUrl:requestUrl header:header parameter:parameter]) {
        return NO;
    }
    
    NSURL *Url = [NSURL URLWithString:requestUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:Url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeOut==0?60:self.timeOut];
       request.HTTPMethod = @"POST";
    
    [request setValue:self.contentType.length==0?@"application/json":self.contentType forHTTPHeaderField:@"Content-Type"];

    if (header != nil) {
        if ([header isKindOfClass:[CSBaseModel class]]) {
            
            [request setAllHTTPHeaderFields:[header modelEncapsulationAsDict]];
            
        }else if ([header isKindOfClass:[NSDictionary class]] || [header isKindOfClass:[NSMutableDictionary class]]) {
            
            [request setAllHTTPHeaderFields:header];
            
        }else{
            return NO;
        }
    }
    
    
    if (parameter != nil) {
        if ([parameter isKindOfClass:[CSBaseModel class]]) {
            request.HTTPBody = [[parameter modelConvertJsonString] dataUsingEncoding:NSUTF8StringEncoding];
        }else if ([parameter isKindOfClass:[NSDictionary class]] || [parameter isKindOfClass:[NSMutableDictionary class]]) {
            request.HTTPBody = [[[NSDictionary dictionaryWithDictionary:parameter] dictConvertJson] dataUsingEncoding:NSUTF8StringEncoding];
        }else {
            return NO;
        }
    }
    
    if (self.useCookie) {
     
        /// 使用cookie 验证本地 cookie状态
        if ([CSSingleCase shareSingleCase].cookieModel != nil) {
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:[[CSSingleCase shareSingleCase].cookieModel modelEncapsulationAsDict]];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
        
    }
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.name = self.requestID;
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    dataTask.taskDescription = self.requestID;
    
    [dataTask resume];
    
    self.requestIdx++;
    
    return YES;
    
}

/// get 请求
-(BOOL)getRequest:(id)target action:(SEL)action requestUrl:(NSString *)requestUrl header:(id)header parameter:(id)parameter {
    
    if (![self parameterExamine:target action:action requestUrl:requestUrl header:header parameter:parameter]) {
        return NO;
    }

    if (parameter != nil) {
        
        if (![requestUrl.lastPathComponent isEqualToString:@"?"]) {
            
            requestUrl = [NSString stringWithFormat:@"%@?",requestUrl];
        }
        
        if ([parameter isKindOfClass:[CSBaseModel class]]) {
            
            NSString *jointUrl = [parameter modelConvertGetUrlString];
        
            requestUrl = [NSString stringWithFormat:@"%@%@",requestUrl,jointUrl];
            
        }else if ([parameter isKindOfClass:[NSDictionary class]]||[parameter isKindOfClass:[NSMutableDictionary class]]){
            
            __block NSString *jointUrl = [[NSString alloc]init];
            [parameter enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                jointUrl = [NSString stringWithFormat:@"%@%@=%@&",jointUrl,key,obj];
            }];
            if (jointUrl.length>0) {
                jointUrl = [jointUrl substringWithRange:NSMakeRange(0, jointUrl.length-1)];
            }
            
            requestUrl = [NSString stringWithFormat:@"%@%@",requestUrl,jointUrl];
            
        }else {
            return NO;
        }
        
    }
    
    NSURL *URL = [NSURL URLWithString:requestUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeOut==0?60.0f:self.timeOut];
    
    if (header != nil) {
        if ([header isKindOfClass:[CSBaseModel class]]) {
            
            [request setAllHTTPHeaderFields:[header modelEncapsulationAsDict]];
            
        }else if ([header isKindOfClass:[NSDictionary class]] || [header isKindOfClass:[NSMutableDictionary class]]) {
            
            [request setAllHTTPHeaderFields:header];
            
        }else{
            return NO;
        }
    }
    
   if (self.useCookie) {
     
        /// 使用cookie 验证本地 cookie状态
        if ([CSSingleCase shareSingleCase].cookieModel != nil) {
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:[[CSSingleCase shareSingleCase].cookieModel modelEncapsulationAsDict]];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
        
    }
    
    request.HTTPMethod = @"GET";
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.name = self.requestID;
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    dataTask.taskDescription = self.requestID;
    
    [dataTask resume];
    
    self.requestIdx++;
    
    return YES;
    
}

/// 参数检查
-(BOOL)parameterExamine:(id)target action:(SEL)action requestUrl:(NSString *)requestUrl header:(id)header parameter:(id)parameter {
    
    if (target == nil) {
        return NO;
    }
    
    if (action == nil) {
        return NO;
    }
    
    if (requestUrl == nil || [requestUrl isEqualToString:@""]) {
        return NO;
    }
    
    ResponseModel *responseModel = [ResponseModel CSInit];
    
    responseModel.target = target;
    responseModel.action = action;
    responseModel.requestUrl = requestUrl;
   
    if (header != nil) {
        
        if ([header isKindOfClass:[CSBaseModel class]]) {
            responseModel.header = [[header class] dictEncapsulationAsModel:[header modelEncapsulationAsDict]];
        }else if ([header isKindOfClass:[NSDictionary class]] || [header isKindOfClass:[NSMutableDictionary class]]) {
            responseModel.header = [NSDictionary dictionaryWithDictionary:header];
        }else {
            return NO;
        }
        
    }
    
    if (parameter != nil) {
        if ([parameter isKindOfClass:[CSBaseModel class]]) {
            responseModel.parameter = [[parameter class] dictEncapsulationAsModel:[parameter modelEncapsulationAsDict]];
        }else if ([parameter isKindOfClass:[NSDictionary class]] || [parameter isKindOfClass:[NSMutableDictionary class]]) {
            responseModel.parameter = [NSDictionary dictionaryWithDictionary:parameter];
        }else {
            return NO;
        }
    }
    
    responseModel.requestId = self.requestID;
    
    [self.responseArray addObject:responseModel];
    
    
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

    __block ResponseModel *responseModel = [ResponseModel CSInit];
    
    [self.responseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        ResponseModel *model = obj;
        
        if ([dataTask.taskDescription isEqualToString:model.requestId]) {
            responseModel = model;
            *stop = YES;
        }
        
    }];
    
     [responseModel.responseData appendData:data];
}

/// 任务完成时调用（如果成功，error == nil）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

    NSHTTPURLResponse *responese = (NSHTTPURLResponse *)task.response;
    
    __block ResponseModel *responseModel = nil;
    
    [self.responseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        ResponseModel *model = obj;
        
       if ([task.taskDescription isEqualToString:model.requestId]) {
            responseModel = model;
            *stop = YES;
        }
        
    }];
    
    responseModel.responseHeader = responese.allHeaderFields;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (self.useCookie) {
            
            NSHTTPCookieStorage * storage =[NSHTTPCookieStorage sharedHTTPCookieStorage];
            
            if (storage.cookies.count > 0) {
                
                NSHTTPCookie *cookie = [storage.cookies lastObject];
                [CSSingleCase shareSingleCase].cookieModel = [CookieModel dictEncapsulationAsModel:cookie.properties];
                
            }else {
                
                NSLog(@"无法获取服务器返回的cookie");
                
            }
        }
        
        if (error == nil) {
            
            NSDictionary *dataDict = [NSDictionary dictionary];
            
            @try {
                
                dataDict = [NSJSONSerialization JSONObjectWithData:responseModel.responseData options:NSJSONReadingMutableLeaves error:nil];
                
            } @catch (NSException *exception) {
                
                responseModel.responseMessage = @"数据解析异常";
                
                if ([self.delegate respondsToSelector:@selector(postRequestComplete:responseModel:)]) {
                    [self.delegate postRequestComplete:RequestDataAnalysisUnusal responseModel:responseModel];
                }
                
                if ([responseModel.target respondsToSelector:responseModel.action]) {
                    
                   
                    ((void(*)(id,SEL,RequestStatusCode,ResponseModel*))objc_msgSend)(responseModel.target,responseModel.action,RequestDataAnalysisUnusal,responseModel);
                    
                }
                
            } @finally {
                
                responseModel.responseDictionary = [NSDictionary dictionaryWithDictionary:dataDict];
                
                responseModel.responseMessage = @"请求成功，响应成功";
                
                if ([self.delegate respondsToSelector:@selector(postRequestComplete:responseModel:)]) {
                    [self.delegate postRequestComplete:RequestSuccessful responseModel:responseModel];
                }
                
                if ([responseModel.target respondsToSelector:responseModel.action]) {
                    
                   
                    ((void(*)(id,SEL,RequestStatusCode,ResponseModel*))objc_msgSend)(responseModel.target,responseModel.action,RequestSuccessful,responseModel);
                    
                }
            }
        }else {
            
            responseModel.responseMessage = error.localizedRecoverySuggestion;
            
            if ([self.delegate respondsToSelector:@selector(postRequestComplete:responseModel:)]) {
                [self.delegate postRequestComplete:RequestUnsual responseModel:responseModel];
            }
            
            if ([responseModel.target respondsToSelector:responseModel.action]) {
                
               
                ((void(*)(id,SEL,RequestStatusCode,ResponseModel*))objc_msgSend)(responseModel.target,responseModel.action,RequestUnsual,responseModel);
                
            }
            
        }
        
        
    });
}


#pragma mark - getter or setter
///请求响应数组 getter
-(NSMutableArray *)responseArray {
    
    if (!_responseArray) {
        
        _responseArray = [[NSMutableArray alloc]init];
    }
    return _responseArray;
}

/// 请求ID
-(NSString *)requestID {
    
    return [NSString stringWithFormat:@"Request%li",(long)self.requestIdx];
    
}

-(NSURLSession *)session {
    
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}

@end
