//
//  DownloadFileModel.h
//  CSToolKit
//
//  Created by chengshu on 2020/7/28.
//  Copyright © 2020 com.cs. All rights reserved.
//

#import "CSBaseModel.h"
#import "CSPch.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadFileModel : CSBaseModel

///保存的文件夹路径
@property (nonatomic,assign) SandBoxFolderType folderType;

///保存的文件名称  可不填写，使用下载地址中文件名称
@property (nonatomic,copy) NSString *fileName;

///相对路径
@property (nonatomic,copy) NSString *relativePath;

///是否覆盖 默认不覆盖
@property (nonatomic,assign) BOOL isCover;

@end

NS_ASSUME_NONNULL_END
