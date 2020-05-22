//
//  NSString+CSString.h
//  CSKit
//
//  Created by chengshu on 2020/4/14.
//  Copyright © 2020 程戍. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,SHAEncodingType) {
    
    SHA1Encoding,
    
    SHA224Encoding,
    
    SHA256Encoding,
    
    SHA384Encoding,
    
    SHA512Encoding
    
};

@interface NSString (CSString)

/*
 * @description json 字符串转换为对象
 * @return 转换后的对象
 */
-(id)jsonConvertObject:(NSStringEncoding)encoding;

/*
 * @description base64编码加密
 * @param string 待编码加密的字符串
 * @param option 加密选项 默认为 NSDataBase64Encoding64CharacterLineLength（0）
 * @return 加密后的编码字符串
 */
-(NSString *)base64Encoding:(NSDataBase64EncodingOptions)option;

/*
 * @description base64解码
 * @param string 待解码的字符串
 * @param option 解码选项
 * @return 解码后的字符串
 */
-(NSString *)base64Decoding:(NSDataBase64DecodingOptions)option;

/*
 * @description md5的编码
 * @param string 待编码的字符串
 * @return md5编码后的字符串
 */
-(NSString *)md5Encoding;

/*
 * @description sha编码
 * @description shaEncodingType sha编码类型
 * @return sha编码
 */
-(NSString *)SHAEncoding:(SHAEncodingType)shaEncodingType;

/*
 * @description 提取Url
 * @return 提取后的url
 */
-(NSArray *)extractUrl;

@end

NS_ASSUME_NONNULL_END
