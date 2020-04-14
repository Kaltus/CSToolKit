//
//  NSString+CSString.h
//  CSKit
//
//  Created by chengshu on 2020/4/14.
//  Copyright © 2020 程戍. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CSString)

/*
 * @description json 字符串转换为对象
 * @return 转换后的对象
 */
-(id)jsonConvertObject:(NSStringEncoding)encoding;

@end

NS_ASSUME_NONNULL_END
