//
//  CSUploadRequest.m
//  CSKit
//
//  Created by fengzhong-ios-chengshu on 2020/4/16.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSUploadRequest.h"

@interface CSUploadRequest ()


@end

@implementation CSUploadRequest

- (BOOL)uploadFile:(id)target action:(SEL)action uploadPath:(NSString *)uploadPath fileModel:(FileModel *)fileModel parameter:(id)parameter {
    
    if (target == nil) {
        return NO;
    }
    
    if (action == nil) {
        return NO;
    }
    

    
    
    
    
    return YES;
}

@end
