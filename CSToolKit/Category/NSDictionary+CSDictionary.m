//
//  NSDictionary+CSDictionary.m
//  CSKit
//
//  Created by chengshu on 2020/3/31.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "NSDictionary+CSDictionary.h"

@implementation NSDictionary (CSDictionary)

-(NSString *)dictConvertJson {
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"转换失败");
        
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    return jsonString;
}

@end
