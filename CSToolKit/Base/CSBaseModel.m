//
//  CSBaseModel.m
//  CSKit
//
//  Created by chengshu on 2020/3/19.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSBaseModel.h"
#import <UIKit/UIKit.h>
#import "CSPch.h"

@implementation CSBaseModel

+(BOOL)supportsSecureCoding {
    return YES;
}

/// 序列化
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSDictionary *coderDict = [self modelEncapsulationAsDict];
    
    [coderDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:0];
            
            [aCoder encodeObject:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] forKey:key];
            
        }else {
            
            [aCoder encodeObject:obj forKey:key];
        }
       
    }];
}

/// 反序列化
-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    NSMutableDictionary *decoderDict = [[NSMutableDictionary alloc]init];
    
    NSArray *parateters = [NSArray getPropertiesAndCategoryDicsByClass:[self class]];
    
    [parateters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id decodeObject = [aDecoder decodeObjectForKey:[obj valueForKey:PropertyName]];
        
        if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[CSBaseModel class]]) {
            
            [decoderDict setObject:[self jsonConvertDict:decodeObject] forKey:[obj objectForKey:PropertyName]];
            
        }else if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[NSDictionary class]] || [NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[NSMutableDictionary class]]){
            
            [decoderDict setObject:[self jsonConvertDict:decodeObject] forKey:[obj objectForKey:PropertyName]];
            
        }else {
            
            [decoderDict setObject:decodeObject forKey:[obj objectForKey:PropertyName]];
            
        }
        
    }];
    
    [self dictEncapsulationAsModel:decoderDict.copy];
    
    return self;
    
}

/// 通过文件名序列化模型到沙盒中
-(BOOL)modelSerialization:(NSString *)fileName
{
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",fileName]];
    

//    BOOL fileHave=[[NSFileManager defaultManager] fileExistsAtPath:file];
//
//    if (fileHave) {
//
//        BOOL DeleteFile= [fileManager removeItemAtPath:file error:nil];
//
//        if (DeleteFile) {
//             文件已经存在，做删除文件操作。 后续文件操作更新
//        }
//
//    }
    
    BOOL result = NO;
    
    if (CS_SystemVersion >= 12.0) {
        
        NSError *error;
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self
                              requiringSecureCoding:YES
                                              error:&error];
        if (error)
            return NO;
    
        result = [data writeToFile:file atomically:YES];
        
    }else {
        result = [NSKeyedArchiver archiveRootObject:self toFile:file];
    }
    
    if (result) {
        return YES;
    }else
    {
        return NO;
    }
}

/// 反序列化，通过文件名从沙盒中取出模型
+(id)modelDeserialization:(NSString *)fileName {
    
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",fileName]];
    
    if (CS_SystemVersion >= 12.0) {
        
        NSError *error;
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:file];
        
        id content = [NSKeyedUnarchiver unarchivedObjectOfClass:[self class] fromData:data error:&error];
        
        if (error) {
            return nil;
        }
        
        return content;
        
    }else {
        
        return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    }

}

@end
