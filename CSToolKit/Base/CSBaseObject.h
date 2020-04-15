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
#import "NSString+CSString.h"
#import <UIKit/UIKit.h>
#import "CSPch.h"

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
 * @description 模型数组解析为字典数组
 * @param models 模型解析为字典数组
 * @return 字典数组
 */
-(NSArray *)modelsEncapsulationAsDicts:(NSArray *)models;

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

/*
 * @description 获取一个字典，这个字典是模型中的泛型数组的集合
 * @return 返回一个类型数组
 * @remark 当继承自 CSBaseModel 中的属性含有模型数组的时候。必须在该类中实现这个静态方法。@{@"数组的泛型字符串":@"模型中的属性名"} eg:@property (nonatomic,strong) NSArray<TestModel1 *> *testArray; 在模型类的.m中 实现getDictionaryForGenericsInModel 并 return @{@"testArray":@"TestModel1"};
 */
+(NSDictionary *)getDictionaryForGenericsInModel;

+(NSString *)getPrimaryKey;

@end

NS_ASSUME_NONNULL_END
