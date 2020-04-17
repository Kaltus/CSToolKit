//
//  CSBaseObject.m
//  CSKit
//
//  Created by chengshu on 2020/3/19.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSBaseObject.h"

@interface CSBaseObject()

@property (nonatomic,strong) dispatch_queue_t queue;

@end

@implementation CSBaseObject

///快速初始化
+(id)CSInit {
  
    return [[super alloc]init];
    
}

///字典自动封装返回模型
+(id)dictEncapsulationAsModel:(NSDictionary *)dataDict {
    
    id model = [[self alloc]init];
    
    NSMutableDictionary *dataMutableDict = [[NSMutableDictionary alloc]init];
    
    NSArray *propertys = [self getPropertys];
    
    if (propertys.count > 0) {
        
        [propertys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
              
            id content = [dataDict objectForKey:[obj objectForKey:PropertyName]];
                       
            if ([content isKindOfClass:[NSNull class]] || content == nil) {
                content = [[NSClassFromString([obj objectForKey:PropertyType]) alloc] init];
            }
            
            if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[CSBaseObject class]]) {

               if ([[content class] isSubclassOfClass:[CSBaseObject class]]) {
                    
                    [dataMutableDict setObject:content forKey:[obj objectForKey:PropertyName]];
                    
                }else {
                    
                    [dataMutableDict setObject:NullOrNilConvertEmptyString([NSClassFromString([obj objectForKey:PropertyType]) dictEncapsulationAsModel:content]) forKey:[obj objectForKey:PropertyName]];
                }

            }else if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[NSArray class]] || [NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[NSMutableArray class]]) {

                NSDictionary *Generics = [[self class] getDictionaryForGenericsInModel];

                if (Generics.allKeys.count > 0) {

                    [dataMutableDict setObject:[NSClassFromString([Generics objectForKey:[obj objectForKey:PropertyName]]) dictsEncapsulationAsModels:content] forKey:[obj objectForKey:PropertyName]];

                }else {

                    NSLog(@"未重写 %@ 类中的静态方法 getDictionaryForGenericsInModel",[self class]);
                    [dataMutableDict setObject:content forKey:[obj objectForKey:PropertyName]];

                }

            }else {

                [dataMutableDict setObject:NullOrNilConvertEmptyString(content) forKey:[obj objectForKey:PropertyName]];
            }
            
        }];
    }
    
    [model setValuesForKeysWithDictionary:dataMutableDict.copy];
    
    return model;
}

///字典自动封装，返回模型
-(void)dictEncapsulationAsModel:(NSDictionary *)dataDict {
    
    __block NSMutableDictionary *dataMutableDict = [[NSMutableDictionary alloc]init];
    NSArray *propertys = [self getPropertys];
    
    if (propertys.count > 0) {
           
        [propertys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 
            id content = [dataDict objectForKey:[obj objectForKey:PropertyName]];
            
            if ([content isKindOfClass:[NSNull class]] || content == nil) {
                content = [[NSClassFromString([obj objectForKey:PropertyType]) alloc] init];
            }
            
            if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[CSBaseObject class]]) {
                
                if ([[content class] isSubclassOfClass:[CSBaseObject class]]) {
                    
                    [dataMutableDict setObject:content forKey:[obj objectForKey:PropertyName]];
                    
                }else {
                    
                    [dataMutableDict setObject:NullOrNilConvertEmptyString([NSClassFromString([obj objectForKey:PropertyType]) dictEncapsulationAsModel:content]) forKey:[obj objectForKey:PropertyName]];
                }
                
            }else if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[NSArray class]] || [NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[NSMutableArray class]]) {

                NSDictionary *Generics = [[self class] getDictionaryForGenericsInModel];

                if (Generics.allKeys.count > 0) {

                    [dataMutableDict setObject:[NSClassFromString([Generics objectForKey:[obj objectForKey:PropertyName]]) dictsEncapsulationAsModels:content] forKey:[obj objectForKey:PropertyName]];

                }else {

                    NSLog(@"未重写 %@ 类中的静态方法 getDictionaryForGenericsInModel",[self class]);
                    [dataMutableDict setObject:NullOrNilConvertEmptyString(content) forKey:[obj objectForKey:PropertyName]];

                }

            }else {

                [dataMutableDict setObject:NullOrNilConvertEmptyString(content) forKey:[obj objectForKey:PropertyName]];

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
    
    if (dataDicts.count > 0) {
        [dataDicts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [modelArray addObject:[[self class] dictEncapsulationAsModel:obj]];
            }
            
        }];
    }
    
    return modelArray.copy;
}

/// 模型转换为字典
-(NSDictionary *)modelEncapsulationAsDict {
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
    
    NSArray *propertys = [self getPropertys];
    
    if (propertys.count > 0) {
        
        [propertys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            id content = [self valueForKey:[obj objectForKey:PropertyName]];
            
            if ([content isKindOfClass:[NSNull class]] || content == nil) {
                content = [[NSClassFromString([obj objectForKey:PropertyType]) alloc] init];
            }
            
            if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[CSBaseObject class]]) {
            
                 [mutableDict setObject:[content modelEncapsulationAsDict] forKey:[obj objectForKey:PropertyName]];
            
            }else if ([NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[NSArray class]] || [NSClassFromString([obj objectForKey:PropertyType]) isSubclassOfClass:[NSMutableArray class]]) {
                
                [mutableDict setValue:[self modelsEncapsulationAsDicts:content] forKey:[obj objectForKey:PropertyName]];
                
            }
            else {
                                
                [mutableDict setValue:content forKey:[obj objectForKey:PropertyName]];
                
            }
            
        }];
    }

    return mutableDict.copy;
}

///模型数组封装为字典数组
-(NSArray *)modelsEncapsulationAsDicts:(NSArray *)models {
    
    __block NSMutableArray *mutableArray = [[NSMutableArray alloc]init];
    
    if (![models isKindOfClass:[NSNull class]] && models != nil && models.count > 0) {
        
        [models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [mutableArray addObject:[obj modelEncapsulationAsDict]];
            
        }];
    }
    
    return mutableArray.copy;
    
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

#pragma mark - Getter or Setter

-(dispatch_queue_t)queue {
    if (!_queue) {
        _queue = dispatch_queue_create("com.cstoolkit.queue", DISPATCH_QUEUE_SERIAL);
    }
    return _queue;
}

///获取字典 获取一个字典，这个字典是模型中的泛型数组的集合 此方法如果在模型中有模型数组，必须在模型中实现
+(NSDictionary *)getDictionaryForGenericsInModel {
    return [NSDictionary dictionary];
}

//+(NSString *)getPrimaryKey {
//    return @"";
//}

@end
