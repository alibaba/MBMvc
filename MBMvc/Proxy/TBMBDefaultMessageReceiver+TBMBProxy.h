//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-15 上午8:38.
//


#import <Foundation/Foundation.h>
#import "TBMBDefaultMessageReceiver.h"

@interface TBMBDefaultMessageReceiver (TBMBProxy)
//创建它的代理对象,使调用直接消息化
@property(nonatomic, readonly) id proxyObject;
@end