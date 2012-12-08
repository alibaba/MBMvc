//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-8 下午12:30.
//


#import "TBMBMessageProxy.h"
#import "TBMBSelectorParameter.h"


static inline TBMBSelectorParameter *getTBMBSelectorParameter(NSInvocation *invocation, NSUInteger parameterIdx) {
    char const *type = [invocation.methodSignature getArgumentTypeAtIndex:parameterIdx];
    NSLog(@"%s", type);
    return nil;
}

@implementation TBMBMessageProxy {
@private
    Class _proxyClass;

}

- (id)initWithClass:(Class)proxyClass {
    _proxyClass = proxyClass;
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *sig = [_proxyClass instanceMethodSignatureForSelector:sel];
    return sig ? : [super methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL aSelector = invocation.selector;
    NSUInteger argsNum = invocation.methodSignature.numberOfArguments;
    if (argsNum > 2) {
        for (NSUInteger i = 2; i < argsNum; i++) {
            getTBMBSelectorParameter(invocation, i);
        }
    }



//    [super forwardInvocation:invocation];
}


@end