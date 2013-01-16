//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 上午11:48.
//


#import <Foundation/Foundation.h>
#import "TBMBDefaultPage.h"


@protocol TBMBDemoStep2Delegate
- (void)showTime;

@end

@interface TBMBDemoStep2View : TBMBDefaultPage
//注意这里是strong 因为MBMvc的delegate 是一个proxyObject,并不是原来的对象,所以这里需要用strong
@property(nonatomic, strong) id <TBMBDemoStep2Delegate> delegate;

- (void)alert:(NSString *)text;
@end