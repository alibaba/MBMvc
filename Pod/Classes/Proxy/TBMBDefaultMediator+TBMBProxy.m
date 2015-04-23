//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-4-23 上午11:32.
//


#import "TBMBDefaultMediator+TBMBProxy.h"
#import "TBMBMessageProxy.h"


@implementation TBMBDefaultMediator (TBMBProxy)
- (id)proxyObject {
    return [[TBMBMessageProxy alloc]
                              initWithClass:[self.realReceiver class]
                                     andKey:self.notificationKey];
}
@end