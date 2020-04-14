//
//  NSDictionary+CSDictionary.h
//  CSKit
//
//  Created by chengshu on 2020/3/31.
//  Copyright © 2020 程戍. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (CSDictionary)

/*
 * @description 字典转换为Json字符串
 * @return Json字符串
 */
-(NSString *)dictConvertJson;

@end

NS_ASSUME_NONNULL_END
