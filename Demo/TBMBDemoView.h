//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-8 下午3:48.
//


#import <Foundation/Foundation.h>
#import "TBMBDefaultPage.h"
#import "TBMBPage.h"

@class TBMBViewDO;

@protocol TBMBDemoViewProtocol

- (void)next;

- (void)prev;
@end

@interface TBMBDemoView : TBMBDefaultPage <TBMBPage>

@property(nonatomic, retain) TBMBViewDO *viewDO;
//因为这个delegate是NSProxy 所以得是 strong的
@property(nonatomic, strong) id <TBMBDemoViewProtocol> delegate;

@end