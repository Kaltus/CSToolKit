//
//  CSBaseObject.m
//  CSKit
//
//  Created by chengshu on 2020/3/19.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSBaseObject.h"
#import "CSPch.h"
#import "NSArray+CSArray.h"
#import <UIKit/UIKit.h>


@implementation CSBaseObject

///快速初始化
+(id)CSInit {
  
    return [[super alloc]init];
    
}

///字典自动封装返回模型
+(id)dictEncapsulationAsModel:(NSDictionary *)dataDict {
    
    id model = [[self alloc]init];
    
    NSMutableDictionary *dataMutableDict = [[NSMutableDictionary alloc]initWithDictionary:dataDict];
    
    NSArray *propertys = [self getPropertys];
    
    if (propertys.count > 0) {
        
        [propertys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
              
            if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[CSBaseObject class]]) {
                
                [dataMutableDict setValue:[NSClassFromString([obj objectForKey:PropertyType]) dictEncapsulationAsModel:[dataMutableDict objectForKey:[obj objectForKey:PropertyName]]] forKey:[obj objectForKey:PropertyName]];
            }
            
        }];
    }
    
    [model setValuesForKeysWithDictionary:dataMutableDict.copy];
    
    return model;
}

///字典自动封装，返回模型
-(void)dictEncapsulationAsModel:(NSDictionary *)dataDict {
    
    NSMutableDictionary *dataMutableDict = [[NSMutableDictionary alloc]initWithDictionary:dataDict];
    
    NSArray *propertys = [self getPropertys];
    
    if (propertys.count > 0) {
           
        [propertys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 
            if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[CSBaseObject class]]) {
                      
                [dataMutableDict setValue:[NSClassFromString([obj objectForKey:PropertyType]) dictEncapsulationAsModel:[dataMutableDict objectForKey:[obj objectForKey:PropertyName]]] forKey:[obj objectForKey:PropertyName]];
                
            }
            
        }];
    }
       
    [self setValuesForKeysWithDictionary:dataMutableDict.copy];
    
}

///模型属性拼接Get Url 链接
-(NSString *)modelConvertGetUrlString {
    
    NSMutableString *paramiterString = [[NSMutableString alloc]initWithFormat:@""];
    
    NSArray *propertys = [self getPropertys];
    
    [propertys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[CSBaseObject class]]) {
            [paramiterString appendString:[NSString stringWithFormat:@"%@=%@&",[obj objectForKey:PropertyName],[[self valueForKey:[obj objectForKey:PropertyName]] modelEncapsulationAsDict]]];
        }else {
            [paramiterString appendString:[NSString stringWithFormat:@"%@=%@&",[obj valueForKey:PropertyName],[self valueForKey:[obj valueForKey:PropertyName]]]];
        }
        
    }];
    
    [paramiterString deleteCharactersInRange:NSMakeRange(paramiterString.length-1, 1)];
    
    return paramiterString;
}

///字典数组封装为模型数组
+(NSArray *)dictsEncapsulationAsModels:(NSArray *)dataDicts {
    
    NSMutableArray *modelArray = [[NSMutableArray alloc]init];
    
    [dataDicts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [modelArray addObject:[[self class] dictEncapsulationAsModel:obj]];
        
    }];
    
    return modelArray.copy;
}

/// 模型转换为字典
-(NSDictionary *)modelEncapsulationAsDict {
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
    
    NSArray *propertys = [self getPropertys];
    
    if (propertys.count > 0) {
        
        [propertys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[CSBaseObject class]]) {
            
                 [mutableDict setObject:[[self valueForKey:[obj objectForKey:PropertyName]] modelEncapsulationAsDict] forKey:[obj objectForKey:PropertyName]];
            
            }else {
                                
                [mutableDict setValue:[self valueForKey:[obj objectForKey:PropertyName]] forKey:[obj objectForKey:PropertyName]];
                
            }
            
        }];
    }

    return mutableDict.copy;
}

///模型转换为Json字符串
-(NSString *)modelConvertJsonString {
    
    return [[self modelEncapsulationAsDict] dictConvertJson];
    
}

///静态方法，回溯获取继承上层中的所有属性
+(NSArray *)getPropertys {
    
    NSMutableArray *subPropertys = [[NSMutableArray alloc]init];
    
    if (![NSStringFromClass(self) isEqualToString:@"CSBaseModel"]) {
        [subPropertys addObjectsFromArray:[[self superclass] getPropertys]];
    }
    
    NSArray *propertys = [NSArray getPropertiesAndCategoryDicsByClass:[self class]];
    
    [subPropertys addObjectsFromArray:propertys];
    
    return subPropertys.copy;
}

/// 回溯获取继承上层中的所有属性
-(NSArray *)getPropertys {
    
    NSMutableArray *subPropertys = [[NSMutableArray alloc]init];
    
    if (![NSStringFromClass([self class]) isEqualToString:@"CSBaseModel"]) {
        [subPropertys addObjectsFromArray:[[self superclass] getPropertys]];
    }
    
    NSArray *propertys = [NSArray getPropertiesAndCategoryDicsByClass:[self class]];
    
    [subPropertys addObjectsFromArray:propertys];
    
    return subPropertys.copy;
}

///json字符串转换为字典
-(NSDictionary *)jsonConvertDict:(NSString *)jsonString {
    
    NSDictionary *jsonDict = [NSDictionary dictionary];
    
    if (jsonString != nil && [jsonString isEqualToString:@""]) {
        return jsonDict;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    @try {
        
        jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        
    } @catch (NSException *exception) {
        
        jsonDict = [NSDictionary dictionary];
        
    } @finally {
      
    }
    
    return jsonDict;
}

@end
