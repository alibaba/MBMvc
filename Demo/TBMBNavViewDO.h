//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 上午10:13.
//


#import <Foundation/Foundation.h>

typedef enum {
    TBMB_DEMO_STEP01,
    TBMB_DEMO_STEP02,
    TBMB_DEMO_STEP03,
    TBMB_DEMO_STEP04,
    TBMB_DEMO_STEP05,
    TBMB_DEMO_END
} TBMBDemoStep;

@interface TBMBNavViewDO : NSObject

@property(nonatomic) TBMBDemoStep demoStep;

@end