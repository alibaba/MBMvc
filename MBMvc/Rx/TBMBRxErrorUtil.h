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
// Created by Wentong on 15/2/3.
//

#import <Foundation/Foundation.h>


extern NSString *const NSRxErrorDomain;

extern NSString *const NSRxExceptionKey;

extern const NSInteger NSRxErrorCode;


@interface TBMBRxErrorUtil : NSObject

+ (NSError *)convertNSException:(NSException *)exception;
@end