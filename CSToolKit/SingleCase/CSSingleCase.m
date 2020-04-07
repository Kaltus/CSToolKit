//
//  CSSingleCase.m
//  CSKit
//
//  Created by fengzhong-ios-chengshu on 2020/4/1.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSSingleCase.h"

static CSSingleCase *singleCase = nil;

@implementation CSSingleCase

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        
        if (singleCase == nil) {
            singleCase = [super allocWithZone:zone];
        }
        return singleCase;
    }
    
}

+(CSSingleCase *)shareSingleCase {
    
    return [[self alloc]init];
    
}


-(id)copyWithZone:(NSZone *)zone{
    
    return singleCase;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return singleCase;
}

#pragma mark - Getter and Setter
-(CookieModel *)cookieModel {
    
    if (!_cookieModel) {
        _cookieModel = [CookieModel CSInit];
    }
    return _cookieModel;
    
}

@end
