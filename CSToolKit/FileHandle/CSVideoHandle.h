//
//  CSVideoHandle.h
//  CSToolKit
//
//  Created by miaoxing_ios_chengshu on 2020/6/19.
//  Copyright © 2020 cs. All rights reserved.
//

#import "CSBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSVideoHandle : CSBaseObject

@property (nonatomic,assign) NSInteger fps;

@property (nonatomic,assign) double duration;

/*
 * @description 图片转换为视频
 * @param images 图片数组
 * @param 视频输出路径
 * @param videoSize 视频尺寸
 */
-(void)imagesConvertVideo:(NSArray *)images videoOutputPath:(NSString *)videoOutputPath videoSize:(CGSize)videoSize;

@end

NS_ASSUME_NONNULL_END
