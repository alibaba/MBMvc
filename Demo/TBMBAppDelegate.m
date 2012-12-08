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
#import "TBMBMessageProxy.h"
#import "TBMBFake.h"

@implementation TBMBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    [[TBMBGlobalFacade instance] registerCommand:[TBMBStaticHelloCommand class]];
//    [[TBMBGlobalFacade instance] registerCommand:[TBMBInstanceHelloCommand class]];

    [[TBMBGlobalFacade instance] registerCommandAutoAsync];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[TBMBViewController alloc] initWithCoder:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    id proxy = [[TBMBMessageProxy alloc] initWithClass:[TBMBFake class]];
    int ip = 10;
    __union u = {1};
    __struct s = {1, "a"};
    int aa[] = {1, 2, 4};
    [proxy requestChar:'a'
          UnsignedChar:'b'
                  Bool:true Double:12345678
                   Int:123
                 Float:123.123
                  Long:-654321L
          UnsignedLong:654321L
      UnsignedLongLong:6543211
                 Short:2
         UnsignedShort:3
                Struct:s
              Unsigned:10
                  IntP:&ip
                 Block:^{
                 }
                 CharP:"test"
                 Array:aa
                 Point:&s
                 Class:[TBMBFake class]
               Selecor:@selector(application:didChangeStatusBarFrame:)
                   Any:NULL Id:self];
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