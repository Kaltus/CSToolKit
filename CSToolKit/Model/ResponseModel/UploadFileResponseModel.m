//
//  UploadFileResponseModel.m
//  CSToolKit
//
//  Created by shuying_ios_chengshu on 2020/7/29.
//  Copyright © 2020 com.cs. All rights reserved.
//

#import "UploadFileResponseModel.h"

@implementation UploadFileResponseModel

-(NSMutableData *)responseData {
    
    if (!_responseData) {
        _responseData = [[NSMutableData alloc]init];
    }
    return _responseData;
}

@end
