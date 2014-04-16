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
//  TBMBNavViewController.m
//  MBMvc
//
//

#import "TBMBNavViewController.h"
#import "TBMBBind.h"
#import "TBMBNavViewDO.h"
#import "TBMBNavView.h"
#import "TBMBDemoStep1ViewController.h"
#import "TBMBDemoStep2ViewController.h"
#import "TBMBDemoStep3ViewController.h"
#import "TBMBDemoStep4ViewController.h"
#import "TBMBDemoStep5ViewController.h"
#import "TBMBTestMemoryViewController.h"
#import "TBMBTestInterceptorViewController.h"
#import "TBMBAutoNilDelegateViewController.h"
#import "TBMBDemoStep6ViewController.h"
#import "TBMBDemoStep7ViewController.h"


@interface TBMBNavViewController ()
@property(nonatomic, strong) TBMBNavViewDO *viewDO;
@end

@implementation TBMBNavViewController

//当self.viewDO.demoStep的值改变时 触发的操作
TBMBWhenThisKeyPathChange(viewDO, demoStep)
{
    if (!isInit && old) {   //当初始化和old没有值时不响应   old没有值表示是第一次初始化的时候
        TBMBDemoStep step = (TBMBDemoStep) [new intValue];
        UIViewController *controller = nil;
        switch (step) {
            case TBMB_DEMO_END:
                break;
            case TBMB_DEMO_STEP01:
                controller = [[TBMBDemoStep1ViewController alloc] initWithNibName:nil bundle:nil];
                break;
            case TBMB_DEMO_STEP02:
                controller = [[TBMBDemoStep2ViewController alloc] initWithNibName:nil bundle:nil];
                break;
            case TBMB_DEMO_STEP03:
                controller = [[TBMBDemoStep3ViewController alloc] initWithNibName:nil bundle:nil];
                break;
            case TBMB_DEMO_STEP04:
                controller = [[TBMBDemoStep4ViewController alloc] initWithNibName:nil bundle:nil];
                break;
            case TBMB_DEMO_STEP05:
                controller = [[TBMBDemoStep5ViewController alloc] initWithNibName:nil bundle:nil];
                break;
            case TBMB_DEMO_STEP06:
                controller = [[TBMBDemoStep6ViewController alloc] initWithNibName:nil bundle:nil];
                break;
            case TBMB_DEMO_STEP07:
                controller = [[TBMBDemoStep7ViewController alloc] initWithNibName:nil bundle:nil];
                break;
        }
        if (controller) {
            [self.navigationController pushViewController:controller animated:YES];
        }

    }
}

//当self.viewDO.gotoTestMemory 触发的操作
TBMBWhenThisKeyPathChange(viewDO, gotoTestMemory){
    if (!isInit && old && [new boolValue]) {

        TBMBTestMemoryViewController *controller = [[TBMBTestMemoryViewController alloc]
                                                                                  initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

//当self.viewDO.gotoTestInterceptor 触发的操作
TBMBWhenThisKeyPathChange(viewDO, gotoTestInterceptor){
    if (!isInit && old && [new boolValue]) {

        TBMBTestInterceptorViewController *controller = [[TBMBTestInterceptorViewController alloc]
                                                                                            initWithNibName:nil
                                                                                                     bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


//当self.viewDO.gotoAutoNil 触发的操作
TBMBWhenThisKeyPathChange(viewDO, gotoAutoNil){
    if (!isInit && old && [new boolValue]) {
        TBMBAutoNilDelegateViewController *controller = [[TBMBAutoNilDelegateViewController alloc]
                                                                                            initWithNibName:nil
                                                                                                     bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewDO = [[TBMBNavViewDO alloc] init];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    TBMBNavView *navView = [[TBMBNavView alloc] initWithFrame:self.view.frame withViewDO:self.viewDO];
    [self.view addSubview:navView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

@end