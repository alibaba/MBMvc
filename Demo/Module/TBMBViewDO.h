//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-11 上午10:25.
//


#import <Foundation/Foundation.h>

//用来做Bind的viewDO
@interface TBMBViewDO : NSObject
@property(nonatomic, assign) BOOL requestInstance;
@property(nonatomic, assign) BOOL requestStatic;

@property(nonatomic, copy) NSString *text;

@property(nonatomic, copy) NSString *buttonTitle1;
@property(nonatomic, copy) NSString *buttonTitle2;

@property(nonatomic, copy) NSString *log;
@end