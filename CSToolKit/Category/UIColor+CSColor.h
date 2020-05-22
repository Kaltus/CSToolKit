//
//  UIColor+CSColor.h
//  CSToolKit
//
//  Created by chengshu on 2020/5/22.
//  Copyright © 2020 cs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CSColor)

/*
 * @description 十六进制颜色码转换成UIColor
 * @param hexColor 十六进制颜色值
 * @param alpha 透明值
 * @return UIColor
 */
+(UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)alpha;

/*
 * @description 十六进制颜色码转换成UIColor
 * @param hex 十六进制颜色值
 * @param alpha 透明值
 * @return UIColor
 */
+(UIColor *)colorWithRGB:(NSUInteger)hex alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
