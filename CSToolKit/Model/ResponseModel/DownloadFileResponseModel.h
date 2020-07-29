//
//  DownloadFileResponseModel.h
//  CSToolKit
//
//  Created by shuying_ios_chengshu on 2020/7/28.
//  Copyright © 2020 com.cs. All rights reserved.
//

#import "CSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadFileResponseModel : CSBaseModel

/// 委托对象
@property (nonatomic,weak) id target;

/// 代理方法
@property (nonatomic,assign) SEL action;

/// 请求地址
@property (nonatomic,copy) NSString *downloadUrl;

/// 请求ID
@property (nonatomic,copy) NSString *downloadId;

/// 是否覆盖
@property (nonatomic,assign) BOOL isCover;

/// 下载进度
@property (nonatomic,assign) CGFloat progress;

/// 文件夹路径
@property (nonatomic,copy) NSString *folderPath;

/// 文件名称
@property (nonatomic,copy) NSString *fileName;

/// 文件下载沙盒地址
@property (nonatomic,copy) NSString *filePath;

/// 响应消息
@property (nonatomic,copy) NSString *message;

@end

NS_ASSUME_NONNULL_END
