//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-2 下午10:47.
//


@protocol TBMBCommandInvocation;

@protocol TBMBCommandInterceptor <NSObject>
//拦截
- (id)intercept:(id <TBMBCommandInvocation>)invocation;
@end