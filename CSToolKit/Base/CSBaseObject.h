//
//  CSBaseObject.h
//  CSKit
//
//  Created by chengshu on 2020/3/19.
//  Copyright © 2020 程戍. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSArray+CSArray.h"
#import "NSDictionary+CSDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSBaseObject : NSObject

/*
 * 快速初始化
 */
+(id)CSInit;

/*
* @description 静态方法，回溯继承上层中的所有属性
* @return 属性数组，数组中的元素为包含属性名称和属性类型的字典
*/
+(NSArray *)getPropertys;

/*
 * @description 回溯获取继承上层中的所有属性
 * @return 属性数组，数组中的元素为包含属性名称和属性类型的字典
 */
-(NSArray *)getPropertys;

/*
 * @description 字典自动封装为模型
 * @param dataDict 数据字典
 * @return 封装后的模型
 */
+(id)dictEncapsulationAsModel:(NSDictionary *)dataDict;

/*
* @description 字典自动封装为模型
* @param dataDict 数据字典
* @return void
*/
-(void)dictEncapsulationAsModel:(NSDictionary *)dataDict;

/*
 * @description 模型转换成Get Url参数
 * @return Get Url 参数字符串
 */
-(NSString *)modelConvertGetUrlString;

/*
 * @description 字典数组自动封装为模型数组
 * @param 字典数组数据
 * @return 模型数组
 */
+(NSArray *)dictsEncapsulationAsModels:(NSArray *)dataDicts;

/*
 * @description 模型转换为字典
 * @return 返回转换后的字典
 */
-(NSDictionary *)modelEncapsulationAsDict;

/*
 * @description 模型转换为JSON 字符串
 * @return Json字符串
 */
-(NSString *)modelConvertJsonString;

/*
 * @description json字符串转换为字典
 * @param jsonString 待转换的json字符串
 * @return 转换后的字典
 * @remark 无论解析是否成功，都将会返回一个空的数组。并不是nil。因此判空处理 应该为 dict.allKeys > 0 判定里面的元素是否大于0
 */
-(NSDictionary *)jsonConvertDict:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
