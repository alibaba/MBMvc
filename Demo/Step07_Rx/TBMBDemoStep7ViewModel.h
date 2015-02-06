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
// Created by Wentong on 15/2/6.
//

#import <Foundation/Foundation.h>

@class RACCommand;


@interface TBMBDemoStep7ViewModel : NSObject

@property(nonatomic, strong) NSDate *time;

@property(nonatomic, strong) RACCommand *timeCommand;

@end