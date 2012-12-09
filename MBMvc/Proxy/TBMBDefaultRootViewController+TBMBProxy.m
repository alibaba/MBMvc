//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-9 下午9:38.
//


#import "TBMBDefaultRootViewController+TBMBProxy.h"
#import "TBMBMessageProxy.h"


@implementation TBMBDefaultRootViewController (TBMBProxy)
- (id)proxyObject {
    return [[TBMBMessageProxy alloc] initWithClass:[self class] andKey:self.notificationKey];
}

@end