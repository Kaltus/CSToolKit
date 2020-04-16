//
//  CSUploadRequest.h
//  CSKit
//
//  Created by chengshu on 2020/4/16.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSBaseObject.h"
#import "FileModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface CSUploadRequest : CSBaseObject

///超时时间
@property (nonatomic,assign) NSInteger timeOut;

-(BOOL)uploadFile:(id)target action:(SEL)action uploadPath:(NSString *)uploadPath fileModel:(FileModel *)fileModel parameter:(id)parameter;

@end

NS_ASSUME_NONNULL_END
