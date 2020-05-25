//
//  CSRequest.m
//  CSKit
//
//  Created by chengshu on 2020/4/1.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSRequest.h"
#import <objc/message.h>
#import "CSPch.h"
#import "CSSingleCase.h"
#import "CSBaseModel.h"
#import "RequestModel.h"

@interface CSRequest ()<NSURLSessionDelegate>

///会话对象
@property (nonatomic,strong) NSURLSession *session;

///请求任务
@property (nonatomic,strong) NSURLSessionDataTask *sessionTask;

///请求模型数组
@property (nonatomic,strong) NSMutableArray *requestArray;

///请求标识
@property (nonatomic,assign) NSInteger requestIdentifer;

@end


@implementation CSRequest

#pragma mark - Func
///Post 请求s
-(BOOL)postRequest:(id)target action:(SEL)action requestUrl:(NSString *)requestUrl header:(nonnull id)header parameter:(nonnull id)parameter {
    
    RequestModel *requestModel = [RequestModel CSInit];
    
    if (target == nil) {
        return NO;
    }

    requestModel.target = target;
    if (action == nil) {

        return NO;

    }
    requestModel.action = action;

    if (requestUrl == nil || [requestUrl isEqualToString:@""]) {

        if ([requestModel.target respondsToSelector:requestModel.action]) {

            ((void (*)(id,SEL,RequestStatusCode,NSDictionary *,NSString *)) objc_msgSend)(requestModel.target,requestModel.action,RequestLinkUrlUnusual,[NSDictionary dictionary],@"请求Url为空");
        }
        return NO;
    }
    
    requestModel.requestUrl = requestUrl;
    
    NSURL *Url = [NSURL URLWithString:requestUrl];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:Url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeOut==0?60:self.timeOut];
    request.HTTPMethod = @"POST";
    
    [request setValue:self.contentType.length==0?@"application/json":self.contentType forHTTPHeaderField:@"Content-Type"];

    if ([parameter isKindOfClass:[CSBaseModel class]]) {

        request.HTTPBody = [[parameter modelConvertJsonString] dataUsingEncoding:NSUTF8StringEncoding];

    }else if ([parameter isKindOfClass:[NSDictionary class]] || [parameter isKindOfClass:[NSMutableDictionary class]]) {

        request.HTTPBody = [[[NSDictionary dictionaryWithDictionary:parameter] dictConvertJson] dataUsingEncoding:NSUTF8StringEncoding];

    }else if(parameter == nil){

        CSLog([CSSingleCase shareSingleCase].CSUsualKitShowLog, @"传入参数为空");

    }else{

        if ([requestModel.target respondsToSelector:requestModel.action]) {

            ((void (*)(id,SEL,RequestStatusCode,NSDictionary *,NSString *)) objc_msgSend)(requestModel.target,requestModel.action,RequestParameterUnusual,[NSDictionary dictionary],@"请求参数错误");
            return NO;
        }

    }
    
    requestModel.parameter = parameter;
    
    if (header != nil) {
        
        if ([header isKindOfClass:[CSBaseModel class]]) {
            
            [request setAllHTTPHeaderFields:[header modelEncapsulationAsDict]];
            
        }else if ([header isKindOfClass:[NSDictionary class]] || [header isKindOfClass:[NSMutableDictionary class]]) {
            
            [request setAllHTTPHeaderFields:[NSDictionary dictionaryWithDictionary:header]];
            
        }else {
            NSLog(@"header为继承自CSBaseModel的对象或者NSDictionary或者NSMutableDictionary的对象");
        }
        
    }
    
    [self.requestArray addObject:requestModel];
    
    if ([CSSingleCase shareSingleCase].usingCookie) {

        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:[[CSSingleCase shareSingleCase].cookieModel modelEncapsulationAsDict]];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];

    }

    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.name = [NSString stringWithFormat:@"%li",(long)self.requestIdentifer];
    requestModel.identifer = [NSString stringWithFormat:@"%li",(long)self.requestIdentifer];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];

    self.sessionTask = [self.session dataTaskWithRequest:request];

    [self.sessionTask resume];
    
    self.requestIdentifer ++;
    
    return YES;
}

/// Get 请求
-(BOOL)getRequest:(id)target action:(SEL)action requestUrl:(NSString *)requestUrl header:(nonnull id)header parameter:(nonnull id)parameter {
    
    RequestModel *requestModel = [RequestModel CSInit];
    
    if (target == nil) {
        return NO;
    }
    
    requestModel.target = target;
    
    if (action == nil) {
        
        return NO;
        
    }

    requestModel.action = action;
    
    if (requestUrl == nil || [requestUrl isEqualToString:@""]) {
        
        if ([requestModel.target respondsToSelector:requestModel.action]) {
        
            ((void (*)(id,SEL,RequestStatusCode,NSDictionary *,NSString *)) objc_msgSend)(requestModel.target,requestModel.action,RequestLinkUrlUnusual,[NSDictionary dictionary],@"请求Url为空");
        }
        return NO;
    }
    
    requestModel.requestUrl = requestUrl;
    
    if (parameter != nil) {
        
        if (![requestUrl.lastPathComponent isEqualToString:@"?"]) {
            
            requestUrl = [NSString stringWithFormat:@"%@?",requestUrl];
        }
        
        if ([parameter isKindOfClass:[CSBaseModel class]]) {
                NSString *jointUrl = [parameter modelConvertGetUrlString];
                
                requestUrl = [NSString stringWithFormat:@"%@%@",requestUrl,jointUrl];
            }else if ([parameter isKindOfClass:[NSDictionary class]]||[parameter isKindOfClass:[NSMutableDictionary class]])
            {
                __block NSString *jointUrl = [[NSString alloc]init];
                [parameter enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    jointUrl = [NSString stringWithFormat:@"%@%@=%@&",jointUrl,key,obj];
                }];
                if (jointUrl.length>0) {
                    jointUrl = [jointUrl substringWithRange:NSMakeRange(0, jointUrl.length-1)];
                }
                
                requestUrl = [NSString stringWithFormat:@"%@%@",requestUrl,jointUrl];
                
            }else
            {
                
                if ([requestModel.target respondsToSelector:requestModel.action]) {
                    ((void (*)(id, SEL,RequestStatusCode,NSDictionary *,NSString *))objc_msgSend)(requestModel.target, requestModel.action,RequestParameterUnusual,[NSDictionary dictionary],@"请求参数异常");
                }
            
                return NO;
            }
        
    }else {
        
        CSLog([CSSingleCase shareSingleCase].CSUsualKitShowLog, @"传入参数为空");
        
    }
    
    requestModel.parameter = parameter;
    
    NSURL *URL = [NSURL URLWithString:requestUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeOut==0?60.0f:self.timeOut];
    
    if ([CSSingleCase shareSingleCase].usingCookie) {
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:[[CSSingleCase shareSingleCase].cookieModel modelEncapsulationAsDict]];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        
    }
    
    request.HTTPMethod = @"GET";
    
    if (header != nil) {
        
        if ([header isKindOfClass:[CSBaseModel class]]) {
            
            [request setAllHTTPHeaderFields:[header modelEncapsulationAsDict]];
            
        }else if ([header isKindOfClass:[NSDictionary class]] || [header isKindOfClass:[NSMutableDictionary class]]) {
            
            [request setAllHTTPHeaderFields:[NSDictionary dictionaryWithDictionary:header]];
            
        }else {
            NSLog(@"header为继承自CSBaseModel的对象或者NSDictionary或者NSMutableDictionary的对象");
        }
        
    }
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.name = [NSString stringWithFormat:@"%li",(long)self.requestIdentifer];
    requestModel.identifer = [NSString stringWithFormat:@"%li",(long)self.requestIdentifer];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate:self
                                            delegateQueue:queue];
    
    self.sessionTask = [self.session dataTaskWithRequest:request];
    
    [self.sessionTask resume];
    
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

    __block RequestModel *requestModel = nil;
       
       [self.requestArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          
           RequestModel *model = obj;
           
           if ([model.identifer isEqualToString:session.delegateQueue.name]) {
               requestModel = model;
           }
           
       }];
    
    [requestModel.reciveData appendData:data];
    
    
}

/// 任务完成时调用（如果成功，error == nil）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    __block RequestModel *requestModel = nil;
    
    [self.requestArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        RequestModel *model = obj;
        
        if ([model.identifer isEqualToString:session.delegateQueue.name]) {
            requestModel = model;
        }
        
    }];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSHTTPCookieStorage * storage =[NSHTTPCookieStorage sharedHTTPCookieStorage];
            if ([CSSingleCase shareSingleCase].usingCookie) {
                
                if (storage.cookies.count > 0) {
                    
                    NSHTTPCookie *cookie = [storage.cookies lastObject];
                    [CSSingleCase shareSingleCase].cookieModel = [CookieModel dictEncapsulationAsModel:cookie.properties];
                    
                }else {
                    
                    CSLog([CSSingleCase shareSingleCase].CSUsualKitShowLog, @"无法获取到服务器返回的Cookie");
                    
                }
                
            }
            
            if (error == nil) {
                
                NSDictionary *dataDict;
                
                @try {
                    
                    dataDict = [NSJSONSerialization JSONObjectWithData:requestModel.reciveData options:NSJSONReadingMutableLeaves error:nil];
                    
                } @catch (NSException *exception) {
                    
                    if ([requestModel.target respondsToSelector:requestModel.action]) {
                        ((void(*)(id,SEL,RequestStatusCode,NSDictionary *,NSString *))objc_msgSend)(requestModel.target,requestModel.action,RequestDataAnalysisUnusal,nil,@"数据解析异常");
                    }
                    
                } @finally {
                    
                    if ([requestModel.target respondsToSelector:requestModel.action]) {
                        
                        ((void(*)(id,SEL,RequestStatusCode,NSDictionary *,NSString *))objc_msgSend)(requestModel.target,requestModel.action,RequestSuccessful,dataDict,@"请求通过，获取数据成功");
                        
                    }
                }
                
            }else {
                
                if ([requestModel.target respondsToSelector:requestModel.action]) {
                    
                    ((void(*)(id,SEL,RequestStatusCode,NSDictionary *,NSString *))objc_msgSend)(requestModel.target,requestModel.action,RequestUnsual,[NSDictionary dictionary],error.localizedDescription);
                    
                }
                
            }
    });
}


#pragma mark - Getter or Setter

-(NSMutableArray *)requestArray {
    
    if (!_requestArray) {
        _requestArray = [[NSMutableArray alloc]init];
    }
    return _requestArray;
}

#pragma mark -


@end
