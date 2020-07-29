//
//  RequestModel.m
//  CSKit
//
//  Created by chengshu on 2020/4/16.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "RequestModel.h"

@implementation RequestModel

-(NSMutableData *)reciveData {
    
    if (!_reciveData) {
        _reciveData = [[NSMutableData alloc]init];
    }
    return _reciveData;
}

@end
