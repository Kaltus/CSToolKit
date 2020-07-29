//
//  CSFileManager.h
//  CSToolKit
//
//  Created by chengshu on 2020/5/13.
//  Copyright © 2020 cs. All rights reserved.
//

#import "CSBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CSFileManagerDelegate <NSObject>

@optional
-(void)saveFileComplete:(SaveFileStatus)saveFileStatus filePath:(NSString *)filePath fileName:(NSString *)fileName message:(NSString *)message;

@end

@interface CSFileManager : CSBaseObject

/*
 * @description 单例外部共享方法
 * @return 单例对象
 */
+(CSFileManager *)shareSingleCase;

///委托对象
@property (nonatomic,assign) id<CSFileManagerDelegate> delegate;

/*
 * @description 获取沙盒目录路径
 * @param sandBoxFolderType 文件夹所在的沙盒对应类型
 * @return 沙盒目录路径
 */
-(NSString *)getSandboxFolder:(SandBoxFolderType)sandBoxFolderType;

/*
 * @description 获取文件夹的路径
 * @param sandBoxFolderType 文件夹所在的沙盒对应类型
 * @param folderRelativePath 文件夹的相对路径（相对于沙盒对应目录）
 * @param folderName 文件夹的名称
 * @return 文件夹的路径
 */
-(NSString *)getFolderPath:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath folderName:(NSString *)folderName;

/*
 * @description 获取文件的路径
 * @param sandBoxFolderType 文件夹所在的沙盒对应类型
 * @param folderRelativePath 文件夹的相对路径（相对于沙盒对应目录）
 * @param fileName 文件的名称
 * @return 文件的路径
 */
-(NSString *)getFilePath:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName;

/*
 * @description 检查文件是否存在
 * @param folderPath 文件夹路径
 * @return 是否存在 Yes 存在  NO 不存在
 */
-(BOOL)checkFolderExist:(NSString *)folderPath;

/*
* @description 检查文件是否存在
* @param filePath 文件路径
* @return 是否存在 Yes 存在  NO 不存在
*/
-(BOOL)checkFileExist:(NSString *)filePath;

/*
 * @description 创建文件夹
 * @param sandBoxFolderType 文件夹所在的沙盒对应类型
 * @param folderRelativePath 文件夹的相对路径（相对于沙盒对应目录）
 * @param folderName 文件名称
 * @return 
 */
-(BOOL)createFolder:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath folderName:(NSString *)folderName;

/*
 * @description 创建文件夹
 * @param folderPath 文件夹路径
 * @return 创建文件夹是否成功
 */
-(BOOL)createFolder:(NSString *)folderPath;

/*
 * @description 移除文件夹
 * @param sandBoxFolderType 文件夹所在的沙盒对应类型
 * @param folderRelativePath 文件夹的相对路径（相对于沙盒对应目录）
 * @param folderName 文件夹名称
 * @return 删除文件夹是否成功
 */
-(BOOL)removeFolder:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath folderName:(NSString *)folderName;

/*
 * @description 移除文件夹
 * @param folderPath 文件夹路径
 * @return 删除文件夹是否成功
 */
-(BOOL)removeFolder:(NSString *)folderPath;

/*
* @description 移除文件
* @param sandBoxFolderType 文件夹所在的沙盒对应类型
* @param folderRelativePath 文件夹的相对路径（相对于沙盒对应目录）
* @param fileName 文件夹名称
* @return 移除文件是否成功
*/
-(BOOL)removeFile:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName;

/*
* @description 移除文件夹
* @param filePath 文件路径
* @return 删除文件是否成功
*/
-(BOOL)removeFile:(NSString *)filePath;

/*
 * @description 保存文件到沙盒中
 * @param fileData 文件数据
 * @param sandBoxFolderType 沙盒目录类型
 * @param folderRelativePath 文件夹相对路径
 * @param fileName 文件名称
 * @param isCover 是否覆盖
 */
-(void)saveFileToSandbox:(NSData *)fileData sandBoxFolderType:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName isCover:(BOOL)isCover;

/*
 * @description 移动文件到指定的文件目录
 * @param scrFilePath 源文件
 * @param sandboxFolderType 指定的文件目录沙盒类型
 * @param folderRelativePath 相对路径
 * @param fileName copy到指定目录下的文件名
 * @param isCover 如果有覆盖是否覆盖
 * @return 移动文件到指定的文件目录是否成功
 */
-(BOOL)moveSrcFilePath:(NSString *)srcFilePath toSandBoxFolderType:(SandBoxFolderType)sandboxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName isCover:(BOOL)isCover;


/*
 * @description 移动文件到指定的文件目录
 * @param scrFilePath 源文件
 * @param dstFilePath 目标文件路径
 * @param isCover 是否覆盖
 * @return 移动文件到指定的文件目录是否成功
 */
-(BOOL)moveSrcFilePath:(NSString *)srcFilePath dstFilePath:(NSString *)dstFilePath isCover:(BOOL)isCover;

/*
* @description 移动文件到指定的文件目录
* @param srcFilePathUrl 源文件路径url
* @param dstFilePathUrl 目标文件路径url
* @param isCover 是否覆盖
* @return 移动文件到指定的文件目录是否成功
*/
-(BOOL)moveSrcFilePathUrl:(NSURL *)srcFilePathUrl dstFilePathUrl:(NSURL *)dstFilePathUrl isCover:(BOOL)isCover;

/*
 * @description copy文件到指定的目录下
 * @param scrFilePath 源文件
 * @param sandboxFolderType 指定的文件目录沙盒类型
 * @param folderRelativePath 相对路径
 * @param fileName copy到指定目录下的文件名
 * @param isCover 如果有覆盖是否覆盖
 * @return 复制文件到指定目录是否成功
 */
-(BOOL)copySrcFilePath:(NSString *)srcFilePath toSandBoxFolderType:(SandBoxFolderType)sandboxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName isCover:(BOOL)isCover;

/*
 * @description copy文件到指定的目录下
 * @param scrFilePath 源文件
 * @param dstFilePath 目标文件路径
 * @param isCover 是否覆盖
 * @return 复制文件到指定的目录是否成功
 */
-(BOOL)copySrcFilePath:(NSString *)srcFilePath toDstFilePath:(NSString *)dstFilePath isCover:(BOOL)isCover;

/*
* @description copy文件到指定的目录下
* @param srcFileUrl 源文件
* @param dstFileUrl 目标文件路径
* @param isCover 是否覆盖
* @return 复制文件到指定的目录是否成功
*/
-(BOOL)copySrcFileUrl:(NSURL *)srcFileUrl toDstFileUrl:(NSURL *)dstFileUrl isCover:(BOOL)isCover;

/*
 * @description 路径检查 将会去除file:///
 * @param path 需检查的本地路径
 8 @return 返回合适的path
 */
-(NSString *)pathNormExamine:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
