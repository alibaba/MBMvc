//
//  TBMBAppDelegate.m
//  MBMvc
//
//  Created by 黄 若慧 on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBMBAppDelegate.h"

#import "TBMBViewController.h"
#import "TBMBGlobalFacade.h"
#import "TBMBLogInterceptor.h"
#import "TBMBBind.h"

#define TBMBTestJoin(...)   metamacro_stringify(__TBMBAutoKeyPathChangeMethodName(__VA_ARGS__))


@implementation TBMBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    TBMBSetBindableRunSafeThreadStrategy(TBMBBindableRunSafeThreadStrategy_Ignore);
    TBMBSetBindableRunThreadIsBindingThread(YES);
    //直接使用registerCommandAutoAsync 来注册了 ,不再需要单个来注册
//    [[TBMBGlobalFacade instance] registerCommand:[TBMBStaticHelloCommand class]];
//    [[TBMBGlobalFacade instance] registerCommand:[TBMBSingletonHelloCommand class]];
    //设置拦截器
    [[TBMBGlobalFacade instance] setInterceptors:[NSArray arrayWithObjects:[[TBMBLogInterceptor alloc] init], nil]];
    //可以直接自动扫描全部Command进行自动异步的Command注册
    [[TBMBGlobalFacade instance] registerCommandAutoAsync];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[TBMBViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    NSLog(@"%s", TBMBTestJoin(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t));
    NSLog(@"%@", __TBMB_get_self_property(window, screen));

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