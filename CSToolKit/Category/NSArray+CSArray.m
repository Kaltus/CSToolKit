//
//  NSArray+CSArray.m
//  CSKit
//
//  Created by chengshu on 2020/3/18.
//  Copyright © 2020 程戍. All rights reserved.
//

#import <objc/runtime.h>

#import "CSPch.h"

#import "NSArray+CSArray.h"

@implementation NSArray (CSArray)

+(NSArray *)getPropertiesAndCategoryDicsByClass:(Class)classType {
    
    unsigned int ivarsCnt = 0;
    
    Ivar *ivars = class_copyIvarList(classType, &ivarsCnt);
      
    NSMutableArray *arrary = [[NSMutableArray alloc]init];
      
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        Ivar const ivar = *p;
          
        const char *type = ivar_getTypeEncoding(ivar);
        
        NSMutableString *propertyType = [NSMutableString stringWithUTF8String:type];
          
        if (propertyType.length >=8) {
            [propertyType deleteCharactersInRange:NSMakeRange(0, 2)];
            [propertyType deleteCharactersInRange:NSMakeRange(propertyType.length-1, 1)];
        }
        
        const char *name =  ivar_getName(ivar);
          
        NSMutableString *propertyName = [[NSMutableString alloc]initWithFormat:@"%@",[NSString stringWithCString:name encoding:NSUTF8StringEncoding]];
          
        [propertyName deleteCharactersInRange:NSMakeRange(0, 1)];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:propertyName,PropertyName,propertyType,PropertyType, nil];
        [arrary addObject:dict];
      }
      
      return arrary;
    
}

///数组转换为json字符串
-(NSString *)arrayConvertJsonString {
    
    NSError *error;
    NSData *jsonData = nil;
    
    @try {
        
        jsonData = [NSJSONSerialization dataWithJSONObject:self
        options:(NSJSONWritingOptions) (self ? NSJSONWritingPrettyPrinted : 0)
          error:&error];
        
    } @catch (NSException *exception) {
        
        return @"";
        
    } @finally {
        
        if (error == nil) {
            
             return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
        }else {
            
            return @"";
            
        }
        
    }

}

@end
