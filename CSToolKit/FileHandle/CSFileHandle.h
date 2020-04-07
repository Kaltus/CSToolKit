//
//  CSFileHandle.h
//  CSKit
//
//  Created by chengshu on 2020/4/7.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

///文件路径类型
typedef NS_ENUM(NSInteger,SandBoxFolderType) {
    
    ///Document 目录
    FolderDocumentType = 0,
    
    ///Library 目录
    FolderLibraryTye ,
    
    ///Library 目录中的Caches 目录
    FolderCachesType,
    
    ///Temp 目录
    FolderTempType
    
};

@interface CSFileHandle : CSBaseObject

/*
 * @description 获取沙盒目录路径
 * @param folderPathType 文件类型
 * @return 沙盒目录路径
 */
-(NSString *)getSandboxFolder:(SandBoxFolderType)sandBoxFolderType;

/*
 * @description 获取目标路径
 * @param sandBoxFolderType 沙盒目录类型
 * @param folderRelativePath 文件夹相对路径
 * @param fileName 文件名称
 * @return 获取目标路径
 * @remark 传入空fileName将只获取文件夹路径
 */
-(NSString *)getObjectPath:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName;

/*
 * @description 创建文件夹
 * @param sandboxFolderType 沙盒目录类型
 * @param folderPath 文件路径，可以传入一个通过多个/隔开的字符串。将会创建一连串的文件夹
 * @param folderName 创建的文件夹名称
 * @return 创建文件夹是否成功
 */
-(BOOL)createFolder:(SandBoxFolderType)sandboxFolderType folderRelativePath:(NSString *)folderRelativePath folderName:(NSString *)folderName;

/*
 * @description 检查文件夹是否存在，如果不存在将会创建
 * @param folderPath 文件夹路径
 * @return 是否存在该文件夹
 */
-(BOOL)checkFolderExists:(NSString *)folderPath;

/*
 * @description 通过路径创建文件夹
 * @param folderPath 文件夹路径
 * @return 创建文件夹是否成功
 * @remark 此方法不会通过路径检查
 * @return 创建文件夹是否成功
 */
-(BOOL)createFolderByPath:(NSString *)folderPath;

/*
 * @description 保存文件到沙盒中
 * @param fileData 文件数据
 * @param sandBoxFolderType 沙盒目录类型
 * @param folderRelativePath 文件夹相对路径
 * @param fileName 文件名称
 * @return 文件缓存是否成功
 */
-(BOOL)saveFileToSandbox:(NSData *)fileData sandBoxFolderType:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName;

/*
* @description 通过路径删除文件
* @param sandBoxFolderType 沙盒目录类型
* @param folderRelativePath 文件夹相对路径
* @param fileName 文件名称
* @return 删除文件是否成功
*/
-(BOOL)removeFile:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName;

/*
 * @description 通过路径删除文件
 * @param filePath 文件路径
 * @return 删除文件是否成功
 */
-(BOOL)removeFile:(NSString *)filePath;

/*
 * @description 从沙盒中读取文件数据
 * @param sandBoxFolderType 沙盒文件目录
 * @param folderRelativePath 文件所在的文件夹的相对路径
 * @param fileName 文件名称
 * @return 读取到的文件数据
 */
-(NSData *)readFileDataFromSandBox:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName;

/*
 * @description 通过路径读取文件数据
 * @param filePath 文件路径
 * @return 读取到的文件数据
 */
-(NSData *)readFileData:(NSString *)filePath;


@end

NS_ASSUME_NONNULL_END
