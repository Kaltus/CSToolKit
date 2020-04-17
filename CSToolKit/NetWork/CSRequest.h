//
//  CSRequest.h
//  CSKit
//
//  Created by chengshu on 2020/4/1.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSBaseObject.h"

@class CSSingleCase;

NS_ASSUME_NONNULL_BEGIN

@interface CSRequest : CSBaseObject

///超时时间
@property (nonatomic,assign) NSInteger timeOut;

///请求中的Content-Type 默认为 application/json
@property (nonatomic,copy) NSString *contentType;

/*
 * @description Post请求
 * @param target 委托对象
 * @param action 代理方法,当请求完成后的回调（备注:方法格式selector:withDic: 方法包含两个参数。 参数1:RequestTypeCode  参数2:字典）
 * @param requestUrl 请求地址
 * @param parameter 请求参数
 * @return 请求是否通过本地校验
 */
-(BOOL)postRequest:(id)target action:(SEL)action requestUrl:(NSString *)requestUrl parameter:(id)parameter;

/*
* @description Get请求
* @param target 委托对象
* @param action 代理方法,当请求完成后的回调（备注:方法格式selector:withDic: 方法包含两个参数。 参数1:RequestTypeCode  参数2:字典）
* @param requestUrl 请求地址
* @param parameter 请求参数
* @return 请求是否通过本地校验
*/
-(BOOL)getRequest:(id)target action:(SEL)action requestUrl:(NSString *)requestUrl parameter:(id)parameter;

/*
* @description Post Form 表单请求
* @param target 委托对象
* @param action 代理方法,当请求完成后的回调（备注:方法格式selector:withDic: 方法包含两个参数。 参数1:RequestTypeCode  参数2:字典）
* @param requestUrl 请求地址
* @param parameter 请求参数
* @return 请求是否通过本地校验
*/
//-(BOOL)postFormRequest:(id)target action:(SEL)action requestUrl:(NSString *)requestUrl parameter:(id)parameter;
@end

NS_ASSUME_NONNULL_END
