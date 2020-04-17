//
//  CSDownloadRequest.h
//  CSKit
//
//  Created by chengshu on 2020/4/16.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSBaseObject.h"
#import "CSPch.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CSDownloadRequestDelegate <NSObject>

@optional
/*
 * @description 下载进度
 * @param progress 进度
 * @param fileUrl 下载文件的Url
 * @param filePath 文件下载所保存的地址
 * @param fileName 文件名称
 */
-(void)downloadFileProgress:(CGFloat)progress fileUrl:(NSString *)fileUrl filePath:(NSString *)filePath fileName:(NSString *)fileName;

/*
* @description 下载完成
* @param downloadRequestStatus 下载状态
* @param fileUrl 下载文件的Url
* @param filePath 文件下载所保存的地址
* @param fileName 文件名称
*/
-(void)downloadFileComplete:(DownloadRequestStatus)downloadRequestStatus fileUrl:(NSString *)fileUrl filePath:(NSString *)filePath fileName:(NSString *)fileName message:(NSString *)message;
@end

@interface CSDownloadRequest : CSBaseObject

/*
 * @description 外部共享方法
 * @return CSDownloadRequest 对象
 */
+(CSDownloadRequest *)shareSingleCase;

///超时时间
@property (nonatomic,assign) NSInteger timeOut;

///请求中的Content-Type 默认为 application/json
@property (nonatomic,copy) NSString *contentType;

/*
 * @description 下载文件到沙盒指定目录
 * @param target 委托对象
 * @param action 代理方法
 * @param downloadUrl 下载文件的路径
 * @param sandboxFolderType 保存文件的根路径文件夹类型
 * @param folderRelativePath 保存文件到根路径下的相对路径
 * @param fileName 文件名称
 * @param isCover 是否覆盖本地文件
 * @return 下载请求本地验证是否被通过
 * remark 当前版本未做本地校验，如果存在该文件未做处理。
 */
-(BOOL)downloadFile:(id)target action:(SEL)action downloadUrl:(NSString *)downloadUrl toRootFolderPath:(SandBoxFolderType)sandboxFolderType folderRelativePath:(NSString *)folderRelativePath fileName:(NSString *)fileName isCover:(BOOL)isCover;

/*
 * @description 下载文件，根据文件类型下载到指定的文件夹
 * @param target 委托对象
 * @param action 代理方法
 * @param downloadUrl 文件下载地址
 * @param fileType 文件类型（用于存放图片所在的文件夹）
 * @param isCover 是否覆盖本地文件
 * @return 下载请求本地验证是否通过
 */
-(BOOL)downloadFile:(id)target action:(SEL)action downloadUrl:(NSString *)downloadUrl fileType:(FileType)fileType isCover:(BOOL)isCover;

@end

NS_ASSUME_NONNULL_END
