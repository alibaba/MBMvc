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
//  TBMBAppDelegate.m
//  MBMvc
//
//

#import "TBMBAppDelegate.h"

#import "TBMBNavViewController.h"
#import "TBMBGlobalFacade.h"
#import "TBMBLogInterceptor.h"
#import "TBMBBind.h"

@implementation TBMBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//当TBMBSetBindableRunThreadIsBindingThread 设为YES时 ,bind触发的执行是异步的,那么可能导致弱引用的changeBlock执行时
//外部参数已经被dealloc 这个策略就是对这个情况下的处理做分离 ,默认策略是 TBMBBindableRunSafeThreadStrategy_Retain
// TBMBBindableRunSafeThreadStrategy_Retain 在异步执行前对bindable retain一把,执行完后在release,并发高时占会用很多内存,
//      因为会在异步执行阶段bindable对象不会被dealloc
// TBMBBindableRunSafeThreadStrategy_Ignore 在异步执行前判断bindable是否dealloc 已经dealloc就不执行了 ,对内存友好
    TBMBSetBindableRunSafeThreadStrategy(TBMBBindableRunSafeThreadStrategy_Retain);
    //设定绑定执行的线程是不是绑定时的线程,默认是NO
//如果你想把ViewDO直接传到Model层请把这个设为YES,防止在非主线程修改UI
    TBMBSetBindableRunThreadIsBindingThread(YES);
//直接使用registerCommandAutoAsync 来注册了 ,不再需要单个来注册
//    [[TBMBGlobalFacade instance] registerCommand:[TBMBStaticHelloCommand class]];
//    [[TBMBGlobalFacade instance] registerCommand:[TBMBSingletonHelloCommand class]];
    //设置拦截器
    [[TBMBGlobalFacade instance] setInterceptors:[NSArray arrayWithObjects:[[TBMBLogInterceptor alloc] init], nil]];
    //可以直接自动扫描全部Command进行自动异步的Command注册
    [[TBMBGlobalFacade instance] registerCommandAutoAsync];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc]
                                                              initWithRootViewController:
                                                                      [[TBMBNavViewController alloc]
                                                                                              initWithNibName:nil
                                                                                                       bundle:nil]];
    [self.window makeKeyAndVisible];


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

@end