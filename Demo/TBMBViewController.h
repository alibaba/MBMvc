//
//  TBMBViewController.h
//  MBMvc
//
//  Created by 黄 若慧 on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBMBDefaultRootViewController.h"

@interface TBMBViewDO : NSObject
@property(nonatomic, assign) BOOL clickPrev;
@property(nonatomic, assign) BOOL clickNext;
@property(nonatomic, assign) BOOL requestInstance;
@property(nonatomic, assign) BOOL requestStatic;
@end

@interface TBMBViewController : TBMBDefaultRootViewController
@end