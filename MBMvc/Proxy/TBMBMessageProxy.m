//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-8 下午12:30.
//


#import "TBMBMessageProxy.h"
#import "TBMBDefaultNotification.h"
#import "TBMBGlobalFacade.h"
#import "TBMBUtil.h"
#import "TBMBStaticCommand.h"

static char kTBMBNSMethodSignatureNotFoundKey;

@interface NSMethodSignature (TBMB)


@end

@implementation NSMethodSignature (TBMB)
- (BOOL)_$isTBMBNotFound {
    NSNumber *notFound = objc_getAssociatedObject(self, &kTBMBNSMethodSignatureNotFoundKey);
    return notFound ? [notFound boolValue] : NO;
}

- (void)_$setTBMBNotFound:(BOOL)yesOrNO {
    objc_setAssociatedObject(self, &kTBMBNSMethodSignatureNotFoundKey, [NSNumber numberWithBool:yesOrNO], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end


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
    NSMethodSignature *sig;
    if (TBMBClassHasProtocol(_proxyClass, @protocol(TBMBStaticCommand))) {
        sig = [_proxyClass methodSignatureForSelector:sel];
    } else {
        sig = [_proxyClass instanceMethodSignatureForSelector:sel];
    }
    if (sig) {
        [sig _$setTBMBNotFound:NO];
        return sig;
    } else {
        NSMethodSignature *signature = [[self class] methodSignatureForSelector:@selector(__$$__NullMethod)];
        [signature _$setTBMBNotFound:YES];
        return signature;
    }
    //return sig ? : [super methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if (invocation.methodSignature._$isTBMBNotFound) {
        NSLog(@"MBMvc You Invoke a Selector [%@] which is not exist in Class[%@]",
                NSStringFromSelector(invocation.selector),
                _proxyClass
        );
        return;
    }
    if (!invocation.argumentsRetained) {
        [invocation retainArguments];
    }
    TBMBDefaultNotification *notification = [[TBMBDefaultNotification alloc]
                                                                      initWithName:TBMBProxyHandlerName(_key, _proxyClass)
                                                                               key:_key
                                                                              body:invocation];
    TBMBGlobalSendTBMBNotification(notification);
}


+ (void)__$$__NullMethod {
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (TBMBClassHasProtocol(_proxyClass, @protocol(TBMBStaticCommand))) {
        return [_proxyClass respondsToSelector:aSelector];
    } else {
        return [_proxyClass instancesRespondToSelector:aSelector];
    }
}


@end