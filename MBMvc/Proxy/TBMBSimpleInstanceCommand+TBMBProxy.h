//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-9 下午9:41.
//


#import <Foundation/Foundation.h>
#import "TBMBSimpleInstanceCommand.h"

@interface TBMBSimpleInstanceCommand (TBMBProxy)
//创建它的代理对象,使调用直接消息化
+ (id)proxyObject;
@end