//
//  CSBaseModel.h
//  CSKit
//
//  Created by chengshu on 2020/3/19.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSFileManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSBaseModel :CSBaseObject  <NSSecureCoding>

+ (BOOL) supportsSecureCoding;

/*
 * @description 数据持久化 通过文件名序列化模型到沙盒中
 * @param 文件名
 * @return 是否序列化成功
 */
- (BOOL) modelSerialization:(NSString *)fileName;

/*
 * @description 数据持久化 通过文件名从沙盒中反序列化取出模型
 * @param fileName 文件名称
 * @return 取出的模型
 */
+ (id) modelDeserialization:(NSString *)fileName;

@end


NS_ASSUME_NONNULL_END
