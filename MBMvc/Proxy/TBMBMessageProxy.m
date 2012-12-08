//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-8 下午12:30.
//


#import "TBMBMessageProxy.h"
#import "TBMBDefaultNotification.h"
#import "TBMBGlobalFacade.h"
#import "TBMBUtil.h"


@implementation TBMBMessageProxy {
@private
    Class _proxyClass;
    NSUInteger _key;
}

- (id)initWithClass:(Class)proxyClass andKey:(NSUInteger)key; {
    _proxyClass = proxyClass;
    _key = key;
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *sig = [_proxyClass instanceMethodSignatureForSelector:sel];
    return sig ? : [super methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    TBMBDefaultNotification *notification = [[TBMBDefaultNotification alloc]
                                                                      initWithName:TBMBProxyHandlerName(_key, _proxyClass)
                                                                               key:_key
                                                                              body:invocation];
    TBMBGlobalSendTBMBNotification(notification);
}


@end