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
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-31 下午4:58.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TBMBPage.h"



@interface TBMBDefaultPage : UIView <TBMBPage>

//初始化一个page
- (id)initWithFrame:(CGRect)frame withViewDO:(id)viewDO;

//Page载入View
- (void)loadView;

- (void)afterAutoBindingLoadView;
@end