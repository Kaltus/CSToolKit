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
    __block NSDictionary *propertyNameDict = [[self class] propertyNameReplaceName];
    
    NSArray *parateters = [self getPropertys];
    
    [parateters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *propertyName = [propertyNameDict objectForKey:[obj objectForKey:PropertyName]];

        if (propertyName == nil || [propertyName isEqualToString:@""] || [propertyName isKindOfClass:[NSNull class]]) {
            propertyName = [obj objectForKey:PropertyName];
        }

        id decodeObject = [aDecoder decodeObjectForKey:propertyName];
        
        if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[CSBaseModel class]]) {
            
            [decoderDict setObject:[self jsonConvertDict:decodeObject] forKey:propertyName];
            
        }else if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[NSDictionary class]] || [NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[NSMutableDictionary class]]){
            
            [decoderDict setObject:[self jsonConvertDict:decodeObject] forKey:propertyName];
            
        }else if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[NSArray class]] || [NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[NSMutableArray class]]) {
            
            [decoderDict setObject:[decodeObject jsonConvertObject:NSASCIIStringEncoding] forKey:propertyName];
            
        }else {
            
            [decoderDict setObject:decodeObject forKey:propertyName];
            
        }
        
    }];
    
    [self dictEncapsulationAsModel:decoderDict.copy];
    
    return self;
    
}

/// 通过文件名序列化模型到沙盒中
-(BOOL)modelSerialization:(NSString *)fileName{
    
    NSString *folderPath = [[CSFileManager shareSingleCase] getFolderPath:FolderCachesType folderRelativePath:ModelArchiveFolder folderName:@""];
    
    BOOL flag = YES;
    
    if (![[CSFileManager shareSingleCase] checkFolderExist:folderPath]) {
            
      flag = [[CSFileManager shareSingleCase] createFolder:folderPath];
            
    }
    
    if (!flag) {
        return flag;
    }
   
    BOOL result = NO;
     
    NSString *filePath = [[CSFileManager shareSingleCase] getFilePath:FolderCachesType folderRelativePath:ModelArchiveFolder fileName:[NSString stringWithFormat:@"%@.data",fileName]];
     
    if (@available(iOS 11.0, *)) {
        NSError *error;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self
                                              requiringSecureCoding:YES
                                                              error:&error];
        if (error != nil) {
            return NO;
        }
        result = [data writeToFile:filePath atomically:YES];

         
    } else {

        result = [NSKeyedArchiver archiveRootObject:self toFile:filePath];
    }
     
    return result;
}

/// 反序列化，通过文件名从沙盒中取出模型
+(id)modelDeserialization:(NSString *)fileName {
    
     NSString *filePath = [[CSFileManager shareSingleCase] getFilePath:FolderCachesType folderRelativePath:ModelArchiveFolder fileName:[NSString stringWithFormat:@"%@.data",fileName]];
    
    if (@available(iOS 11.0, *)) {
        
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
