//
//  ResponseModel.m
//  CSToolKit
//
//  Created by shuying_ios_chengshu on 2020/7/28.
//  Copyright © 2020 com.cs. All rights reserved.
//

#import "ResponseModel.h"

@implementation ResponseModel

-(NSMutableData *)responseData {
    
    if (!_responseData) {
        
        _responseData = [[NSMutableData alloc]init];
        
    }
    return _responseData;
}

@end
