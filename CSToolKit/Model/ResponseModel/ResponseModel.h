//
//  ResponseModel.h
//  CSToolKit
//
//  Created by chengshu on 2020/7/28.
//  Copyright © 2020 com.cs. All rights reserved.
//

#import "CSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResponseModel : CSBaseModel

/// 委托对象
@property (nonatomic,weak) id target;

/// 代理方法
@property (nonatomic,assign) SEL action;

/// 请求地址
@property (nonatomic,copy) NSString *requestUrl;

/// 请求header
@property (nonatomic,strong) id header;

/// 请求参数
@property (nonatomic,strong) id parameter;

/// 请求ID
@property (nonatomic,copy) NSString *requestId;

/// 响应header
@property (nonatomic,strong) NSDictionary *responseHeader;

/// 响应数据Data
@property (nonatomic,strong) NSMutableData *responseData;
 
/// 响应数据 转换字典
@property (nonatomic,strong) NSDictionary *responseDictionary;

/// 响应消息
@property (nonatomic,copy) NSString *responseMessage;

@end

NS_ASSUME_NONNULL_END
