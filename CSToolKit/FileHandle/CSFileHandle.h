//
//  CSFileHandle.h
//  CSKit
//
//  Created by chengshu on 2020/4/7.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CSFileHandleDelegate <NSObject>

/*
 * @description 保存文件完成代理方法
 * @param fileName 文件名称
 * @param saveFileStatus 保存文件状态
 * @param message 保存文件返回消息
 */
-(void)saveFileComplete:(NSString *)fileName saveFileStatus:(SaveFileStatus)saveFileStatus message:(NSString *)message;

/*
 * @description 读取文件完成代理方法
 * @param fileName 文件名
 * @param readFileStatus 读取文件状态
 * @param message 读取文件信息
 */
-(void)readFileComplete:(NSData *)fileData fileName:(NSString *)fileName readFileStatus:(ReadFileStatus)readFileStatus message:(NSString *)message;

@end

@interface CSFileHandle : CSBaseObject

///委托对象
@property (nonatomic,weak) id<CSFileHandleDelegate> delegate;

/*
 * @description 单例外部共享方法
 * @return CSFileHandle 实例
 */
+(instancetype)shareSingleCase;

/*
 * @description 获取沙盒目录路径
 * @param folderPathType 文件类型
 * @return 沙盒目录路径
 */
-(NSString *)getSandboxFolder:(SandBoxFolderType)sandBoxFolderType;

/*
* @description 获取沙盒目录路径
* @param folderPathType 文件类型
* @return 沙盒目录路径
*/
//+(NSString *)getSandboxFolder:(SandBoxFolderType)SandBoxFolderType;

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
* @description 获取目标路径
* @param sandBoxFolderType 沙盒目录类型
* @param folderRelativePath 文件夹相对路径
* @param fileName 文件名称
* @return 获取目标路径
* @remark 传入空fileName将只获取文件夹路径
*/
//+(NSString *)getObjectPath:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName;

/*
 * @description 创建文件夹
 * @param sandboxFolderType 沙盒目录类型
 * @param folderPath 文件路径，可以传入一个通过多个/隔开的字符串。将会创建一连串的文件夹
 * @param folderName 创建的文件夹名称
 * @return 创建文件夹是否成功
 */
-(BOOL)createFolder:(SandBoxFolderType)sandboxFolderType folderRelativePath:(NSString *)folderRelativePath folderName:(NSString *)folderName;

/*
 * @description 通过路径创建文件夹
 * @param folderPath 文件夹路径
 * @return 创建文件夹是否成功
 * @remark 此方法不会通过路径检查
 * @return 创建文件夹是否成功
 */
-(BOOL)createFolder:(NSString *)folderPath;

/*
 * @description 创建一个文件并保存到指定的位置
 * @param sandboxFolderType 沙盒目录类型
 * @param folderPath 文件路径，可以传入一个通过多个/隔开的字符串。将会创建一连串的文件夹
 * @param folderName 创建的文件名称
 * @return 创建文件是否成功
 */
-(BOOL)createFile:(SandBoxFolderType)sandboxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName;

/*
 * @description 通过路径创建一个文件
 * @return 创建文件是否成功
 */
-(BOOL)createFile:(NSString *)filePath;

/*
 * @description 检查文件夹是否存在，如果不存在将会创建
 * @param folderPath 文件夹路径
 * @return 是否存在该文件夹
 */
-(BOOL)checkFolderExists:(NSString *)folderPath;

/*
 * @description 检查文件是否存在
 * @param filePath 文件路径
 * @return yes 已经存在  no 不存在
 */
-(BOOL)checkFileExists:(NSString *)filePath;
/*
 * @description 保存文件到沙盒中
 * @param fileData 文件数据
 * @param sandBoxFolderType 沙盒目录类型
 * @param folderRelativePath 文件夹相对路径
 * @param fileName 文件名称
 * @return 文件缓存是否成功
 */
-(void)saveFileToSandbox:(NSData *)fileData sandBoxFolderType:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName;

/*
 * @description 删除文件夹
 * @param sandBoxFolderType 沙盒目录类型
 * @param folderRelativePath 文件夹相对路径
 * @param folderName 文件夹名称
 * @return 删除文件夹是否成功
 */
-(BOOL)removeFolder:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath folderName:(NSString *)folderName;

/*
 * @description 移除文件夹
 * @param folderPath 文件夹路径
 * @return 移除文件夹是否成功
 */
-(BOOL)removeFolder:(NSString *)folderPath;

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
-(void)readFileDataFromSandBox:(SandBoxFolderType)sandBoxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName;

/*
 * @description 通过路径读取文件数据
 * @param filePath 文件路径
 * @return 读取到的文件数据
 */
-(void)readFileData:(NSString *)filePath;


@end

NS_ASSUME_NONNULL_END
