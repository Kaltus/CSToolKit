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

@end
