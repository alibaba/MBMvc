//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-8 下午3:48.
//


#import <Foundation/Foundation.h>
#import "TBMBDefaultPage.h"
#import "TBMBPage.h"

@class TBMBViewDO;

@interface TBMBDemoView : TBMBDefaultPage <TBMBPage>

@property(nonatomic, retain) TBMBViewDO *viewVO;

@end