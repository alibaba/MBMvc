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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 下午12:20.
//


#import <Foundation/Foundation.h>
#import "TBMBDefaultPage.h"


@protocol TBMBDemoStep3Delegate
- (void)showTime;

@end

@interface TBMBDemoStep3View : TBMBDefaultPage
//注意这里是strong 因为MBMvc的delegate 是一个proxyObject,并不是原来的对象,所以这里需要用strong
@property(nonatomic, strong) id <TBMBDemoStep3Delegate> delegate;

- (void)alert:(NSString *)text;
@end