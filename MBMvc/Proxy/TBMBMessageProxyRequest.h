//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-8 下午3:38.
//


#import <Foundation/Foundation.h>


@interface TBMBMessageProxyRequest : NSObject

@property(nonatomic) Class targetClass;
@property(nonatomic, strong) NSInvocation *invocation;

- (id)initWithTargetClass:(Class)targetClass invocation:(NSInvocation *)invocation;

+ (id)objectWithTargetClass:(Class)targetClass invocation:(NSInvocation *)invocation;

@end