//
//  CSNetworkRequest.h
//  CSToolKit
//
//  Created by shuying_ios_chengshu on 2020/7/28.
//  Copyright © 2020 com.cs. All rights reserved.
//

#import "CSBaseObject.h"

#import "CSSingleCase.h"

#import "ResponseModel.h"

#import "DownloadFileModel.h"
#import "DownloadFileResponseModel.h"

#import "UploadFileModel.h"
#import "UploadFileResponseModel.h"

#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,RequestType) {
    
    /// 普通的请求，用于Get，Post ，form表单请求
    OrdinaryReqeust,
    
    /// 文件上传
    UploadRequest,
    
    /// 文件下载
    DownloadRequest
};

@protocol CSNetworkRequestDelegate <NSObject>

@optional
/*
 * @description post请求完成回调
 * @param status 请求状态
 * @param responseModel 响应模型
 */
-(void)postRequestComplete:(RequestStatusCode)status responseModel:(ResponseModel *)responseModel;

/*
 * @description get请求回调
 * @param status 请求状态
 * @param responseModel 响应模型
 * @return void
 */
-(void)getResponseComplete:(RequestStatusCode)status responseModel:(ResponseModel *)responseModel;

/*
 * @description 下载中回调
 * @param responseModel 响应模型
 * @return void
 */
-(void)downloading:(DownloadFileResponseModel *)responseModel;

/*
 * @description 下载请求完成回调
 * @param code
 */
-(void)downloadFileComplete:(DownloadFileCompleteCode)code responseModel:(DownloadFileResponseModel *)responseModel;

/*
 * @description 上传文件完成回调
 * @param code 上传文件完成状态
 * @param responseModel 响应模型
 * @return void
 */
-(void)uploadFileComplete:(UploadFileCompleteCode)code responseModel:(UploadFileResponseModel *)responseModel;

@end

@interface CSNetworkRequest : CSBaseObject

/// 超时时长，默认60S（上传，下载除外）
@property (nonatomic,assign) NSInteger timeOut;

/// 是否使用Cookie 默认不使用cookie
@property (nonatomic,assign) BOOL useCookie;

/// 请求contentType 。普通请求默认为 application/json 。上传请求默认为multipart/form-data (标识) 。下载请求默认为无
@property (nonatomic,copy) NSString *contentType;

/// 委托对象
@property (nonatomic,assign) id <CSNetworkRequestDelegate> delegate;

/*
 * @description 实例化
 * @param 请求类型
 * @return request对象
 */
+(instancetype)networkRequest:(RequestType)requestType;

/*
 * @description post请求
 * @param target 委托对象
 * @param action 代理方法
 * @param requestUrl 请求地址
 * @param header 请求头
 * @param parameter 请求参数
 * @return bool 请求是否在本地验证通过
 */
-(BOOL)postRequest:(id)target action:(SEL)action requestUrl:(NSString *)requestUrl header:(id)header parameter:(id)parameter;

/*
 * @description get 请求
 * @param target 委托对象
 * @param action 代理方法
 * @param requestUrl 请求地址
 * @param header 请求头
 * @param parameter 请求参数
 * @return bool 请求是否在本地验证通过
 */
-(BOOL)getRequest:(id)target action:(SEL)action requestUrl:(NSString *)requestUrl header:(id)header parameter:(id)parameter;

/*
 * @description 下载文件请求
 * @param target 委托对象
 * @param action 代理方法
 * @param downloadUrl 下载地址
 * @param downloadFileModel 下载模型（提供文件路径和是否覆盖等）
 * @return bool 下载请求本地验证是否通过
 */
-(BOOL)downloadRequest:(id)target action:(SEL)action downloadUrl:(NSString *)downloadUrl downloadRequestModel:(DownloadFileModel *)downloadFileModel;

/*
 * @description 上传单个文件到服务器
 * @param target 委托对象
 * @param action 代理方法
 * @param uploadUrl 上传地址
 * @param uploadFileModel 上传的文件模型 (继承自CSBaseModel 的子类对象，或者使用字典)
 * @param header header (继承自CSBaseModel 的子类对象，或者使用字典)
 * @param parameter 参数(继承自CSBaseModel 的子类对象，或者使用字典)
 * @return BOOL 是否通过本地校验
 */
-(BOOL)uploadFileRequest:(id)target action:(SEL)action uploadUrl:(NSString *)uploadUrl uploadFileModel:(UploadFileModel *)uploadFileModel header:(id)header param:(id)parameter;

@end

NS_ASSUME_NONNULL_END
