//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 13-1-16 下午12:35.
//


#import <Foundation/Foundation.h>


@interface TBMBDemoStep4ViewDO : NSObject
//记录需要被Alert的文字
@property(nonatomic, copy) NSString *alertText;
//用来触发showTime的操作
@property(nonatomic) BOOL showTime;

@end