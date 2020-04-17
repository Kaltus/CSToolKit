//
//  UIImageView+CSImageView.h
//  CSKit
//
//  Created by chengshu on 2020/4/17.
//  Copyright © 2020 程戍. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (CSImageView)

/*
 * @description 设置图片 (类似sd)
 * @param imagePath 图片地址
 * @param placeholderImage 占位图
 * @param isCover 是否覆盖本地
 */
-(void)cs_setImage:(NSString *)imagePath placeholderImage:(NSString *)placeholderImage isCover:(BOOL)isCover;

@end

NS_ASSUME_NONNULL_END
