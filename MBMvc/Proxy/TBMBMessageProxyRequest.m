//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-8 下午3:38.
//


#import "TBMBMessageProxyRequest.h"


@implementation TBMBMessageProxyRequest {

@private
    Class _targetClass;
    NSInvocation *_invocation;
}
@synthesize targetClass = _targetClass;
@synthesize invocation = _invocation;

- (id)initWithTargetClass:(Class)targetClass invocation:(NSInvocation *)invocation {
    self = [super init];
    if (self) {
        _targetClass = targetClass;
        _invocation = invocation;
    }

    return self;
}

+ (id)objectWithTargetClass:(Class)targetClass invocation:(NSInvocation *)invocation {
    return [[TBMBMessageProxyRequest alloc] initWithTargetClass:targetClass invocation:invocation];
}


@end