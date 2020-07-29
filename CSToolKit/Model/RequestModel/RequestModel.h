//
//  RequestModel.h
//  CSKit
//
//  Created by chengshu on 2020/4/16.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestModel : CSBaseModel

@property (nonatomic,copy) NSString *identifer;

@property (nonatomic,copy) NSString *requestUrl;

@property (nonatomic,strong) id parameter;

@property (nonatomic,assign) id target;

@property (nonatomic,assign) SEL action;

@property (nonatomic,strong) NSMutableData *reciveData;

@end

NS_ASSUME_NONNULL_END
