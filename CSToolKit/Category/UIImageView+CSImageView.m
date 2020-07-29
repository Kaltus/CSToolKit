//
//  UIImageView+CSImageView.m
//  CSKit
//
//  Created by chengshu on 2020/4/17.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "UIImageView+CSImageView.h"
//#import "CSDownloadRequest.h"

@interface UIImageView ()

@end

@implementation UIImageView (CSImageView)

///设置image
-(void)cs_setImage:(NSString *)imagePath placeholderImage:(NSString *)placeholderImage isCover:(BOOL)isCover {
    
    [self setImage:[UIImage imageNamed:placeholderImage]];
    
//    [[CSDownloadRequest shareSingleCase] downloadFile:self action:@selector(downloadFileComplete:fileUrl:filePath:fileName:message:) downloadUrl:imagePath fileType:FileImageType isCover:isCover];
    
}

/////下载完成
//-(void)downloadFileComplete:(DownloadRequestStatus)downloadRequestStatus fileUrl:(NSString *)fileUrl filePath:(NSString *)filePath fileName:(NSString *)fileName message:(NSString *)message {
//
//    NSLog(@"filepath is %@",filePath);
//
//    if (downloadRequestStatus == DownloadSucess) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [self setImage:[UIImage imageWithContentsOfFile:filePath]];
//
//        });
//    }
//}
//
//-(void)downloadFileProgress:(CGFloat)progress fileUrl:(NSString *)fileUrl filePath:(NSString *)filePath fileName:(NSString *)fileName {
//
//
//
//}


@end
