//
//  CSImageHandle.m
//  CSToolKit
//
//  Created by chengshu on 2020/6/19.
//  Copyright © 2020 cs. All rights reserved.
//

#import "CSImageHandle.h"
#import "CSFileManager.h"

@implementation CSImageHandles

/// 图片尺寸处理
-(UIImage *)imageSizeCompress:(UIImage *)image imageSize:(CGSize)imageSize {
    
    UIGraphicsBeginImageContext(imageSize);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}


@end
