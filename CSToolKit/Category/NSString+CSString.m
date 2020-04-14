//
//  NSString+CSString.m
//  CSKit
//
//  Created by chengshu on 2020/4/14.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "NSString+CSString.h"

@implementation NSString (CSString)

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

@end
