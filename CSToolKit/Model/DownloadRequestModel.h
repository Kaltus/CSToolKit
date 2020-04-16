//
//  DownloadRequestModel.h
//  CSKit
//
//  Created by chengshu on 2020/4/16.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "RequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadRequestModel : RequestModel

///保存的文件夹路径
@property (nonatomic,copy) NSString *folderPath;

///保存的文件名称
@property (nonatomic,copy) NSString *fileName;

///保存的文件路径
@property (nonatomic,copy) NSString *filePath;

@end

NS_ASSUME_NONNULL_END
