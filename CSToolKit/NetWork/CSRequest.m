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

@interface CSRequest ()<NSURLSessionDelegate>

///会话对象
@property (nonatomic,strong) NSURLSession *session;

///请求任务
@property (nonatomic,strong) NSURLSessionDataTask *sessionTask;

///返回数据
@property (nonatomic,strong) NSMutableData *reciveData;

///委托
@property (nonatomic,assign) id target;

///代理方法
@property (nonatomic,assign) SEL action;


@end

@implementation CSRequest

#pragma mark - Func

///Post 请求s
-(BOOL)postRequest:(id)target action:(SEL)action requestUrl:(NSString *)requestUrl parameter:(id)parameter {
    
    if (target == nil) {
        return NO;
    }
    
    self.target = target;
    
    if (action == nil) {
        
        return NO;
        
    }
    self.action = action;
    
    if (requestUrl == nil || [requestUrl isEqualToString:@""]) {
        
        if ([self.target respondsToSelector:self.action]) {
        
            ((void (*)(id,SEL,RequestStatusCode,NSDictionary *,NSString *)) objc_msgSend)(self.target,self.action,RequestLinkUrlUnusual,[NSDictionary dictionary],@"请求Url为空");
        }
        return NO;
    }
    
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
        
        if ([self.target respondsToSelector:self.action]) {
        
            ((void (*)(id,SEL,RequestStatusCode,NSDictionary *,NSString *)) objc_msgSend)(self.target,self.action,RequestParameterUnusual,[NSDictionary dictionary],@"请求参数错误");
            
        }
        
    }
    
    if ([CSSingleCase shareSingleCase].usingCookie) {
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:[[CSSingleCase shareSingleCase].cookieModel modelEncapsulationAsDict]];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        
    }
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    
    self.sessionTask = [self.session dataTaskWithRequest:request];
    
    [self.sessionTask resume];
    
    
    return YES;
}

/// Get 请求
-(BOOL)getRequest:(id)target action:(SEL)action requestUrl:(NSString *)requestUrl parameter:(id)parameter {
    
    if (target == nil) {
        return NO;
    }
    
    self.target = target;
    
    if (action == nil) {
        
        return NO;
        
    }
    self.action = action;
    
    if (requestUrl == nil || [requestUrl isEqualToString:@""]) {
        
        if ([self.target respondsToSelector:self.action]) {
        
            ((void (*)(id,SEL,RequestStatusCode,NSDictionary *,NSString *)) objc_msgSend)(self.target,self.action,RequestLinkUrlUnusual,[NSDictionary dictionary],@"请求Url为空");
        }
        return NO;
    }
    
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
                
                if ([self.target respondsToSelector:self.action]) {
                    ((void (*)(id, SEL,RequestStatusCode,NSDictionary *,NSString *))objc_msgSend)(self.target, self.action,RequestParameterUnusual,[NSDictionary dictionary],@"请求参数异常");
                }
            
                return NO;
            }
    
    }else {
        
        CSLog([CSSingleCase shareSingleCase].CSUsualKitShowLog, @"传入参数为空");
        
    }
    
    self.reciveData = [[NSMutableData alloc]init];
    
    NSURL *URL = [NSURL URLWithString:requestUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeOut==0?60.0f:self.timeOut];
    
    if ([CSSingleCase shareSingleCase].usingCookie) {
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:[[CSSingleCase shareSingleCase].cookieModel modelEncapsulationAsDict]];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        
    }
    
    request.HTTPMethod = @"GET";
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate:self
                                            delegateQueue:[[NSOperationQueue alloc]init]];
    
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
    
    [self.reciveData appendData:data];
    
}

/// 任务完成时调用（如果成功，error == nil）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
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
                    
                    dataDict = [NSJSONSerialization JSONObjectWithData:self.reciveData options:NSJSONReadingMutableLeaves error:nil];
                    
                } @catch (NSException *exception) {
                    
                    if ([self.target respondsToSelector:self.action]) {
                        ((void(*)(id,SEL,RequestStatusCode,NSDictionary *,NSString *))objc_msgSend)(self.target,self.action,RequestDataAnalysisUnusal,nil,@"数据解析异常");
                    }
                    
                } @finally {
                    
                    if ([self.target respondsToSelector:self.action]) {
                        
                        ((void(*)(id,SEL,RequestStatusCode,NSDictionary *,NSString *))objc_msgSend)(self.target,self.action,RequestSuccessful,dataDict,@"请求通过，获取数据成功");
                        
                    }
                }
                
            }else {
                
                if ([self.target respondsToSelector:self.action]) {
                    
                    ((void(*)(id,SEL,RequestStatusCode,NSDictionary *,NSString *))objc_msgSend)(self.target,self.action,RequestUnsual,[NSDictionary dictionary],error.userInfo.description);
                    
                }
                
            }
    });
}


#pragma mark - Getter or Setter


-(NSMutableData *)reciveData {
    
    if (!_reciveData) {
        _reciveData = [[NSMutableData alloc]init];
    }
    return _reciveData;
}

@end
