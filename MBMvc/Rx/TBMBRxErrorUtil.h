//
// Created by Wentong on 15/2/3.
//

#import <Foundation/Foundation.h>


extern NSString *const NSRxErrorDomain;

extern NSInteger NSRxErrorCode;


@interface TBMBRxErrorUtil : NSObject

+ (NSError *)convertNSException:(NSException *)exception;
@end