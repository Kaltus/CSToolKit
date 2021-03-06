//
//  CSPch.h
//  CSKit
//
//  Created by chengshu on 2020/3/19.
//  Copyright © 2020 程戍. All rights reserved.
//

#ifndef CSPch_h
#define CSPch_h
#import <Foundation/Foundation.h>

/*****************************************枚举********************************************************/

///请求状态码
typedef NS_ENUM(NSInteger,RequestStatusCode){
    
    ///请求
    RequestSuccessful = 0,
    
    ///请求链接Url异常
    RequestLinkUrlUnusual = 1,
    
    ///参数异常
    RequestParameterUnusual = 2,
    
    ///请求连接中断
    RequestLinkStop = 3,
    
    ///数据解析异常
    RequestDataAnalysisUnusal = 4,
    
    ///请求异常
    RequestUnsual = 5
};

///请求完成状态吗
typedef NS_ENUM(NSInteger,RequestCompleteCode) {
    
    ///请求通过
    RequestSucessComplete,
    
    ///请求失败
    RequestFailedComplete
    
};

///刷新类型
typedef NS_ENUM(NSInteger,RefreshType) {
    
    ///没有刷新
    NoRefreshType ,
    
    ///加载更多
    LoadMoreRefreshType,
    
    ///下拉刷新
    ReloadRefreshType
    
};

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

typedef NS_ENUM(NSInteger,SaveFileStatus) {
    
    ///保存文件成功
    SaveFileSucess ,
    
    ///文件已经存在
    SaveFileExist ,
    
    ///保存文件失败
    SaveFileFailed
    
    
    
};

///文件类型
typedef NS_ENUM(NSInteger,FileType) {
    
    ///公共文件夹类型
    FilePublicType ,
    
    ///图片文件类型
    FileImageType ,
    
    ///音频文件类型
    FileVoiceType ,
    
    ///视频文件类型
    FileVideotype
    
};

///文件读取状态
typedef NS_ENUM(NSInteger,ReadFileStatus) {
    
    ///读取数据成功
    ReadFileSucess ,
    
    ///读取数据失败
    ReadFileFailed
};

///下载请求状态
typedef NS_ENUM(NSInteger,DownloadFileCompleteCode) {
    
    DownloadSucess ,
    
    DownloadFailed
    
};

/// 上传文件状态
typedef NS_ENUM(NSInteger,UploadFileCompleteCode) {
    
    /// 上传文件成功
    UploadSucess ,
    /// 上传文件失败
    UploadFailed
    
};

/*****************************************功能区域*********************************************/
/*
 * 打印宏
 * @param 是否打印
 * @param 打印语句
 */
#define CSLog(whetherShow,fmt, ...) if(whetherShow == YES) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

///获取系统版本号
#define SystemVersion [[UIDevice currentDevice] systemVersion].floatValue

///屏幕宽度
#define SCREN_WIDTH   [UIScreen mainScreen].bounds.size.width

///屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

///获取一个视图的X坐标
#define Origin_X(view) view.frame.origin.x

///获取一个视图的Y坐标
#define Origin_Y(view) view.frame.origin.y

///获取视图宽
#define Size_Width(view) view.frame.size.width

///获取视图的高
#define Size_Height(view) view.frame.size.height

///计算视图X+width
#define Frame_SIZE_SCREEN_END_X(view) view.frame.origin.x+view.frame.size.width

///计算视图Y+height
#define Frame_SIZE_SCREEN_END_Y(view) view.frame.origin.y+view.frame.size.height

///获取Cache目录
#define GetCacheDir NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

///NULL 和 nil 转换为空字符串
#define NullOrNilConvertEmptyString(value) ({id tmp; if ([value isKindOfClass:[NSNull class]]||value==nil) tmp = @""; else tmp = value; tmp;})
/*****************************************属性区域*********************************************/

///读取属性名
#define PropertyName @"PropertyName"

///读取类别
#define PropertyType @"PeopertyType"

///读取属性值
#define PropertyValue @"PropertyValue"

///CSToolKIt 用于缓存的文件夹
#define CSToolKitFolder @"CSToolKitFolder"

///附件缓存文件夹
#define FileFolder @"FileFolder"

#define PublicFolder @"CSToolKitFolder/FileFolder/PublicFolder"

///图片缓存文件夹
#define ImageFolder @"CSToolKitFolder/FileFolder/ImageFolder"

///音频缓存文件夹
#define VoiceFolder @"CSToolKitFolder/FileFolder/VoiceFolder"

///视频缓存文件夹
#define VideoFolder @"CSToolKitFolder/FileFolder/VideoFolder"

///模型序列化文件夹
#define ModelArchiveFolder @"CSToolKitFolder/ModelArchiveFolder"

///数据库文件夹
#define DataBaseFolder @"CSToolKitFolder/FileFolder/DataBaseFolder"

///POSTForm表单请求标识
#define Post_Form_Identifer @"CSToolKitFormRequest"

///POSTForm表单中的隔离线
#define Post_Form_Line @"\r\n"

#endif /* CSPch_h */

