//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-3 下午5:47.
//


#import "TBMBInstanceCommand.h"

@protocol TBMBSingletonCommand <TBMBInstanceCommand>

+ (id <TBMBSingletonCommand>)instance;

@end