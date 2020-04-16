//
//  FileModel.h
//  CSKit
//
//  Created by fengzhong-ios-chengshu on 2020/4/16.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileModel : CSBaseModel

///选用 文件数据
@property (nonatomic,strong) NSData *fileData;

///选用 文件路径
@property (nonatomic,copy) NSString *filePath;

///文件类型
@property (nonatomic,copy) NSString *fileType;

@end

NS_ASSUME_NONNULL_END
