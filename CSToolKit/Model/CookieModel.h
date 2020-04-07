//
//  CookieModel.h
//  CSKit
//
//  Created by chengshu on 2020/4/1.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CookieModel : CSBaseModel

@property(nonatomic,strong)NSDate *Created;

@property(nonatomic,strong)NSNumber *Discard;

@property(nonatomic,copy)NSString *Domain;

@property(nonatomic,strong)NSNumber *HttpOnly;

@property(nonatomic,copy)NSString *Name;

@property(nonatomic,copy)NSString *Path;

@property(nonatomic,copy)NSString *Value;

@end

NS_ASSUME_NONNULL_END
