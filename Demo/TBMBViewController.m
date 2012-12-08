//
//  TBMBViewController.m
//  MBMvc
//
//  Created by 黄 若慧 on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBMBViewController.h"
#import "TBMBDemoView.h"
#import "TBMBMessageProxy.h"

@interface TBMBViewController ()

@end

@implementation TBMBViewController


- (void)loadView {
    [super loadView];
    TBMBDemoView *view = [[TBMBDemoView alloc] initWithFrame:self.view.frame];
    view.delegate = [[TBMBMessageProxy alloc] initWithClass:[self class] andKey:self.notificationKey];
    [self.view addSubview:view];
}

- (void)prev:(id)prev {
}

- (void)next:(id)next {
    [[TBMBViewController alloc] init];
}

- (void)requestStatic:(UIButton *)sender {
    NSLog(@"Send Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    UITextField *view = (UITextField *) [self.view viewWithTag:3];
    [self sendNotificationForSEL:@selector($$staticHello:name:) body:view.text];
}

- (void)requestInstance:(UIButton *)sender {
    NSLog(@"Send Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    UITextField *view = (UITextField *) [self.view viewWithTag:3];
    [self sendNotificationForSEL:@selector($$instanceHello:) body:view.text];
}


- (void)$$receiveStaticHello:(id <TBMBNotification>)notification title:(NSString *)title {
    NSLog(@"Receive Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    NSLog(@"isSendByMe:%d", notification.key == self.notificationKey);
    UIButton *view = (UIButton *) [self.view viewWithTag:1];
    [view setTitle:title forState:UIControlStateNormal];
}

- (void)$$receiveInstanceHello:(id <TBMBNotification>)notification {
    NSLog(@"Receive Thread:[%@] isMain[%d]", [NSThread currentThread], [NSThread isMainThread]);
    NSLog(@"isSendByMe:%d", notification.key == self.notificationKey);
    UIButton *view = (UIButton *) [self.view viewWithTag:2];
    [view setTitle:notification.body forState:UIControlStateNormal];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"dealloc %@", self);

}


@end