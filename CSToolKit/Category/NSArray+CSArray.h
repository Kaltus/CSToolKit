//
//  NSArray+CSArray.h
//  CSKit
//
//  Created by chengshu on 2020/3/18.
//  Copyright © 2020 程戍. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (CSArray)

/*
 * 获取一个数组，该数组由N个字典构成，字典包含类中属性名和属性类型
 * @param 需要获取数据的类
 * @return 数组
 */
+(NSArray *)getPropertiesAndCategoryDicsByClass:(Class)modelClass;

/*
 * @description 数组转json
 * @return json字符串
 */
-(NSString *)arrayConvertJsonString;

@end

NS_ASSUME_NONNULL_END
