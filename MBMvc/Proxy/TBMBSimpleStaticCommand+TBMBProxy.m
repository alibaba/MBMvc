//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-9 下午9:41.
//


#import "TBMBSimpleStaticCommand+TBMBProxy.h"
#import "TBMBMessageProxy.h"


@implementation TBMBSimpleStaticCommand (TBMBProxy)
+ (id)proxyObject {
    return [[TBMBMessageProxy alloc] initWithClass:self andKey:0];
}

@end