//
//  CSImageHandle.h
//  CSToolKit
//
//  Created by chengshu on 2020/6/19.
//  Copyright © 2020 cs. All rights reserved.
//

#import "CSBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSImageHandle : CSBaseObject

/*
 * @description 图片尺寸压缩
 * @param image
 */
-(UIImage *)imageSizeCompress:(UIImage *)image imageSize:(CGSize)imageSize;


@end

NS_ASSUME_NONNULL_END
