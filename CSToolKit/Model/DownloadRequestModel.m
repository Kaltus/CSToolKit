//
//  DownloadRequestModel.m
//  CSKit
//
//  Created by chengshu on 2020/4/16.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "DownloadRequestModel.h"

@implementation DownloadRequestModel

-(NSString *)filePath {
    
    return [self.folderPath stringByAppendingPathComponent:self.fileName];
    
}

@end
