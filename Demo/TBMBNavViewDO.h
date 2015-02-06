/*
 * (C) 2007-2013 Alibaba Group Holding Limited
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 */
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
    TBMB_DEMO_STEP06,
    TBMB_DEMO_STEP07,
    TBMB_DEMO_END
} TBMBDemoStep;

@interface TBMBNavViewDO : NSObject

@property(nonatomic) TBMBDemoStep demoStep;

@property(nonatomic) BOOL gotoTestMemory;

@property(nonatomic) BOOL gotoTestInterceptor;

@property(nonatomic) BOOL gotoAutoNil;

@end