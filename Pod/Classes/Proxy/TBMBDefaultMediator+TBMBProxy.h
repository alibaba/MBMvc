//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-4-23 上午11:32.
//


#import <Foundation/Foundation.h>
#import "TBMBDefaultMediator.h"

@interface TBMBDefaultMediator (TBMBProxy)
//创建它的代理对象,使调用直接消息化
@property(nonatomic, readonly) id proxyObject;
@end