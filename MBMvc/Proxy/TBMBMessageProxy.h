//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-8 下午12:30.
//


#import <Foundation/Foundation.h>


@interface TBMBMessageProxy : NSProxy
- (id)initWithClass:(Class)proxyClass;
@end