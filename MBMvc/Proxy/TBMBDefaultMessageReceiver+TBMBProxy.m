//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-15 上午8:38.
//


#import "TBMBDefaultMessageReceiver+TBMBProxy.h"
#import "TBMBMessageProxy.h"


@implementation TBMBDefaultMessageReceiver (TBMBProxy)
- (id)proxyObject {
    return [[TBMBMessageProxy alloc] initWithClass:[self class] andKey:self.notificationKey];
}
@end