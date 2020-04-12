//
//  CSPch.h
//  CSKit
//
//  Created by chengshu on 2020/3/19.
//  Copyright © 2020 程戍. All rights reserved.
//

#ifndef CSPch_h
#define CSPch_h

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

/*****************************************功能区域*********************************************/
/*
 * 打印宏
 * @param 是否打印
 * @param 打印语句
 */
#define CSLog(whetherShow,fmt, ...) if(whetherShow == YES) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

///NULL 和 nil 转换为空字符串
#define CS_EmptyTransformNilwithNull(value) ({id tmp; if ([value isKindOfClass:[NSNull class]]||value==nil) tmp =@""; else tmp = value; tmp;})

///获取系统版本号
#define CS_SystemVersion [[UIDevice currentDevice] systemVersion].floatValue

///屏幕宽度
#define CS_SCREN_WIDTH   [UIScreen mainScreen].bounds.size.width

///屏幕高度
#define CS_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

///获取一个视图的X坐标
#define CS_Origin_X(view) view.frame.origin.x

///获取一个视图的Y坐标
#define CS_Origin_Y(view) view.frame.origin.y

///获取视图宽
#define CS_Size_Width(view) view.frame.size.width

///获取视图的高
#define CS_Size_Height(view) view.frame.size.height

///计算视图X+width
#define CS_Frame_SIZE_SCREEN_END_X(view) view.frame.origin.x+view.frame.size.width

///计算视图Y+height
#define CS_Frame_SIZE_SCREEN_END_Y(view) view.frame.origin.y+view.frame.size.height

///获取Cache目录
#define GetCacheDir NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

/*****************************************属性区域*********************************************/

///读取属性名
#define PropertyName @"PropertyName"

///读取类别
#define PropertyType @"PeopertyType"

///读取属性值
#define PropertyValue @"PropertyValue"

///图片缓存文件夹
#define CacheImageFolder @"CacheImageFolder"

///音频文件缓存文件夹
#define CacheAudioFolder @"CacheAudioFolder"

///视频文件缓存文件夹
#define CacheVedioFolder @"CacheVedioFolder"

///Plist文件夹
#define CachePlistFolder @"CachePlistFolder"

///数据库文件夹
#define CacheDataBaseFolder @"CacheDataBaseFolder"

///POSTForm表单请求标识
#define Post_Form_Identifer @"CSKITFormRequest"

///POSTForm表单中的隔离线
#define Post_Form_Line @"\r\n"

#endif /* CSPch_h */
