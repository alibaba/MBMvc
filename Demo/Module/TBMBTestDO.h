//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-8 下午10:16.
//


#import <Foundation/Foundation.h>


@interface TBMBTestDO : NSObject


@property(nonatomic, copy) NSString *name;

- (id)initWithName:(NSString *)name;

+ (id)objectWithName:(NSString *)name;

@end