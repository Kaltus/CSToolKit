//
//  CSNetworkRequest.m
//  CSToolKit
//
//  Created by chengshu on 2020/7/28.
//  Copyright © 2020 com.cs. All rights reserved.
//

#import "CSNetworkRequest.h"
#import "CSRequest.h"
#import "CSUploadRequest.h"
#import "CSDownloadRequest.h"

@implementation CSNetworkRequest

/// 实例化
+(instancetype)networkRequest:(RequestType)requestType {
    
    switch (requestType) {
        case OrdinaryReqeust:{
            /// 普通请求
            return [CSRequest CSInit];
        }break;
        case UploadRequest:{
            /// 上传
            return [CSUploadRequest CSInit];
        }break;
        case DownloadRequest:{
            /// 下载
            return [CSDownloadRequest CSInit];
        }break;
        default:{
          return [CSRequest CSInit];
        }break;
    }
    
}

/// post 请求
-(BOOL)postRequest:(id)target action:(SEL)action requestUrl:(NSString *)requestUrl header:(id)header parameter:(id)parameter{return YES;};

/// get 请求
-(BOOL)getRequest:(id)target action:(SEL)action requestUrl:(NSString *)requestUrl header:(id)header parameter:(id)parameter {return YES;}

/// 下载请求
-(BOOL)downloadRequest:(id)target action:(SEL)action downloadUrl:(NSString *)downloadUrl downloadRequestModel:(id)downloadFileModel {return YES;}

/// 文件上传
-(BOOL)uploadFileRequest:(id)target action:(SEL)action uploadUrl:(NSString *)uploadUrl uploadFileModel:(UploadFileModel *)uploadFileModel header:(id)header param:(id)parameter{return YES;}

@end
