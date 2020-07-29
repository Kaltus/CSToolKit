//
//  UploadFileRequestModel.h
//  CSToolKit
//
//  Created by shuying_ios_chengshu on 2020/7/29.
//  Copyright © 2020 com.cs. All rights reserved.
//

#import "CSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadFileModel : CSBaseModel

/// 上传文件contenttype
@property (nonatomic,copy) NSString *contentType;

/// 文件名称
@property (nonatomic,copy) NSString *fileName;

/// 文件Data数据
@property (nonatomic,strong) NSData *fileData;

/// 文件参数名 name
@property (nonatomic,copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
