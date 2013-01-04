//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-9 下午9:38.
//


#import <Foundation/Foundation.h>
#import "TBMBDefaultRootViewController.h"

@interface TBMBDefaultRootViewController (TBMBProxy)
//创建它的代理对象,使调用直接消息化
@property(nonatomic, readonly) id proxyObject;
@end