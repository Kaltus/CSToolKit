//
//  NSString+CSString.m
//  CSKit
//
//  Created by chengshu on 2020/4/14.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "NSString+CSString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CSString)

///json字符串转换为对象
-(id)jsonConvertObject:(NSStringEncoding)encoding {
    
    NSData *data = [self dataUsingEncoding:encoding];
    
    NSError *error;
    
    id object;
    
    @try {
        
        object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
    } @catch (NSException *exception) {
        
        object = nil;
        
    } @finally {
        
        if (error == nil) {
             return object;
        }else {
            return nil;
        }
        
    }
}

///对字符串进行base64编码处理
-(NSString *)base64Encoding:(NSDataBase64EncodingOptions)option {
    
    NSData *data =[self dataUsingEncoding:NSUTF8StringEncoding];
    
     return [data base64EncodedStringWithOptions:option];
}

///对base64字符串进行解码
-(NSString *)base64Decoding:(NSDataBase64DecodingOptions)option {
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:option];
  
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
}

///MD5编码
-(NSString *)md5Encoding {
    
    const char *fooData = [self UTF8String];

    unsigned char result[CC_MD5_DIGEST_LENGTH];

    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);

    NSMutableString *saveResult = [NSMutableString string];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {

    [saveResult appendFormat:@"%02x", result[i]];

    }

    return saveResult;
}

///SHA 编码
-(NSString *)SHAEncoding:(SHAEncodingType)shaEncodingType {
    
    const char *fooData = [self UTF8String];

    NSMutableString *saveResult = [NSMutableString string];

    switch (shaEncodingType) {
        case SHA1Encoding:{
            unsigned char result[CC_SHA1_DIGEST_LENGTH];
            CC_SHA1(fooData,(CC_LONG)strlen(fooData),result);
            
            for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {

               [saveResult appendFormat:@"%02x", result[i]];

            }
            
        }break;
        case SHA224Encoding:{
            unsigned char result[CC_SHA224_DIGEST_LENGTH];
            
            CC_SHA224(fooData,(CC_LONG)strlen(fooData),result);
                   
            for (int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++) {

                [saveResult appendFormat:@"%02x", result[i]];

            }
                   
        }break;
        case SHA256Encoding:{
            unsigned char result[CC_SHA256_DIGEST_LENGTH];
            CC_SHA256(fooData,(CC_LONG)strlen(fooData),result);
            
            for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {

               [saveResult appendFormat:@"%02x", result[i]];

            }
            
        }break;
        case SHA384Encoding:{
            unsigned char result[CC_SHA384_DIGEST_LENGTH];
            CC_SHA384(fooData,(CC_LONG)strlen(fooData),result);
            
            for (int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {

               [saveResult appendFormat:@"%02x", result[i]];

            }
            
        }break;
        case SHA512Encoding:{
            unsigned char result[CC_SHA512_DIGEST_LENGTH];
            CC_SHA512(fooData, (CC_LONG)strlen(fooData), result);
            
            for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {

               [saveResult appendFormat:@"%02x", result[i]];

            }
            
        }break;
        default:
            break;
    }
    
    return saveResult;
    
}

///字符串中提取URL 数组
-(NSArray *)extractUrl {
    
    NSError *error = nil;
    
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];

    NSArray *arrayOfAllMatches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];

    NSMutableArray *urlArray = [[NSMutableArray alloc] init];

    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSString* substringForMatch;
        substringForMatch = [self substringWithRange:match.range];
        [urlArray addObject:substringForMatch];
    }
    return urlArray.copy;
}

@end
