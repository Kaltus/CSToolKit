//
//  CSSingleCase.h
//  CSKit
//
//  Created by fengzhong-ios-chengshu on 2020/4/1.
//  Copyright © 2020 程戍. All rights reserved.
//

#import "CSBaseObject.h"
#import "CookieModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSSingleCase : CSBaseObject

/*
 * @description 外部共享方法
 * @return 外部共享对象
 */
+(CSSingleCase *)shareSingleCase;

///Cookie 模型
@property (nonatomic,strong) CookieModel *cookieModel;

///是否使用Cookie
@property (nonatomic,assign) BOOL usingCookie;

///是否显示框架中的日志打印
@property (nonatomic,assign) BOOL CSUsualKitShowLog;

@end

NS_ASSUME_NONNULL_END
