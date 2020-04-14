//
//  CSBaseModel.m
//  CSKit
//
//  Created by chengshu on 2020/3/19.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSBaseModel.h"

@implementation CSBaseModel

+(BOOL)supportsSecureCoding {
    return YES;
}

/// 序列化
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSDictionary *coderDict = [self modelEncapsulationAsDict];
    
    [coderDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        
        
        
        if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]]) {
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:0];
            
            [aCoder encodeObject:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] forKey:key];
            
        }else if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]]){
            
            [aCoder encodeObject:[obj arrayConvertJsonString] forKey:key];
            
        }else{
            
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
            
        }else if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[NSArray class]] || [NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[NSMutableArray class]]) {
            
            [decoderDict setObject:[decodeObject jsonConvertObject:NSASCIIStringEncoding] forKey:[obj objectForKey:PropertyName]];
            
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
    
    BOOL flag = [self createFolder:FolderCachesType folderRelativePath:CSToolKitFolder folderName:ModelArchiveFolder];
    
    BOOL result = NO;
    
    if (flag) {
        
        NSString *folderPath = [self getObjectPath:FolderCachesType folderRelativePath:CSToolKitFolder fileName:ModelArchiveFolder];
        
        NSString *filePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",fileName]];
        
        if (CS_SystemVersion >= 12.0) {
            
            NSError *error;
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self
                                  requiringSecureCoding:YES
                                                  error:&error];
            if (error)
                return NO;
        
            result = [data writeToFile:filePath atomically:YES];
            
        }else {
            result = [NSKeyedArchiver archiveRootObject:self toFile:filePath];
        }
        
        if (result) {
            
            return YES;
            
        }else
        {
            return NO;
        }
        
    }else {
        return NO;
    }
}

/// 反序列化，通过文件名从沙盒中取出模型
+(id)modelDeserialization:(NSString *)fileName {

    NSString *folderPath = [self getObjectPath:FolderCachesType folderRelativePath:CSToolKitFolder fileName:ModelArchiveFolder];
    NSString *filePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",fileName]];
    
    if (CS_SystemVersion >= 12.0) {
        
        NSError *error;
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        
        id content = [NSKeyedUnarchiver unarchivedObjectOfClass:[self class] fromData:data error:&error];
        
        if (error) {
            return nil;
        }
        
        return content;
        
    }else {
        
        return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }

}

@end
