//
//  UploadFileResponseModel.h
//  CSToolKit
//
//  Created by chengshu on 2020/7/29.
//  Copyright © 2020 com.cs. All rights reserved.
//

#import "CSBaseModel.h"
#import "UploadFileModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UploadFileResponseModel : CSBaseModel

/// 上传文件委托对象
@property (nonatomic,weak) id target;

/// 上传文件代理方法
@property (nonatomic,assign) SEL action;

/// 上传文件地址
@property (nonatomic,copy) NSString *uploadUrl;

/// 文件上传header
@property (nonatomic,strong) id uploadReqeustHeader;

/// 上传文件模型
@property (nonatomic,strong) UploadFileModel *uploadFileModel;

/// 上传文件参数
@property (nonatomic,strong) id uploadParameter;

/// 上传文件标识
@property (nonatomic,copy) NSString *uploadIdentifer;

/// 上传文件进度
//@property (nonatomic,assign) CGFloat uploadProgress;

/// 响应头
@property (nonatomic,strong) NSDictionary *responseHeader;

/// 上传文件返回数据
@property (nonatomic,strong) NSMutableData *responseData;

/// 响应数据 字典
@property (nonatomic,strong) NSDictionary *responseDataDict;

/// 响应消息
@property (nonatomic,copy) NSString *responseMessage;

@end

NS_ASSUME_NONNULL_END
