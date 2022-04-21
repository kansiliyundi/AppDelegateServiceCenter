
//
//  GGAppDelegate.h
//  AppDelegateServiceCenter
//
//  Created by gengwk on 2017/8/21.
//  Copyright © 2017年 AppDelegateServiceCenter. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GGAppDelegate.h"
@interface GGAppDelegate ()
@end

@implementation GGAppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    /**
      如有在所有服务之前执行的第三方or服务,在这里实现
     */

    if ([super proxyToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
        
        [super application:application didFinishLaunchingWithOptions:launchOptions];
    }
    return YES;
}


-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    // 调用服务中的方法或属性 不建议在多个服务中重写同名的非系统方法 会导致获取不准确的问题，只能获取到最后一个servier的返回值
//    BOOL allowsRotation = NO;
//    if ([super proxyToSelector:@selector(allowsRotation)]) {
//        allowsRotation = [super performSelector:@selector(allowsRotation)];
//    }
//    if (allowsRotation == YES) {
//        return UIInterfaceOrientationMaskAll;
//    }else{
//
//        return (UIInterfaceOrientationMaskPortrait);
//    }
    
    
    if ([super proxyToSelector:@selector(application:supportedInterfaceOrientationsForWindow:)]) {
        return [super application:application supportedInterfaceOrientationsForWindow:window];
    }
    return (UIInterfaceOrientationMaskPortrait);
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    
    if ([super proxyToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
        
        [super application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{

    if ([super proxyToSelector:@selector(application:didRegisterUserNotificationSettings:)]) {
        
        [super application:application didRegisterUserNotificationSettings:notificationSettings];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    

    if ([super proxyToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
        
        [super application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    
    if ([super proxyToSelector:@selector(applicationWillEnterForeground:)]) {
        
        [super applicationWillEnterForeground:application];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    if ([super proxyToSelector:@selector(application:didReceiveRemoteNotification:)]) {
        
        [super application:application didReceiveRemoteNotification:userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    if ([super proxyToSelector:@selector(application:didReceiveLocalNotification:)]) {
        
        [super application:application didReceiveLocalNotification:notification];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    if ([super proxyToSelector:@selector(applicationDidEnterBackground:)]) {
        
        [super applicationDidEnterBackground:application];
    }
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application{
    
    if ([super proxyToSelector:@selector(applicationDidBecomeActive:)]) {
        
        [super applicationDidBecomeActive:application];
    }
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    if ([super proxyToSelector:@selector(application:openURL:options:)]) {
        
        [super application:app openURL:url options:options];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler{
    if ([super proxyToSelector:@selector(application:continueUserActivity:restorationHandler:)]) {
        [super application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
    }
    return YES;
}


@end

