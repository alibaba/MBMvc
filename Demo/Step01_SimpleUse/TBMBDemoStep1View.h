//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 上午10:55.
//


#import <Foundation/Foundation.h>
#import "TBMBDefaultPage.h"

@protocol TBMBDemoStep1Delegate
- (void)showTime;

- (void)pushNewPage;
@end

@interface TBMBDemoStep1View : TBMBDefaultPage

@property(nonatomic, strong) id <TBMBDemoStep1Delegate> delegate;

- (void)alert:(NSString *)text;
@end