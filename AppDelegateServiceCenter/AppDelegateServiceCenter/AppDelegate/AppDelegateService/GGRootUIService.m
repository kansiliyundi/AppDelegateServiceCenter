//
//  PPRootUIService.m
//  TestAppDelegateService
//
//  Created by yuemei on 2017/9/21.
//  Copyright © 2017年 yuemei. All rights reserved.
//

#import "GGRootUIService.h"
#import "ViewController.h"

@interface GGRootUIService()

@end

@implementation GGRootUIService

GG_IMPORT_SERVICE(@"rootUI")

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self.window makeKeyAndVisible];
    self.window.rootViewController = [ViewController new];
    
    return YES;
}


-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (self.allowsRotation == YES) {
        return UIInterfaceOrientationMaskAll;
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}

-(UIWindow *)window{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _window;
}

-(BOOL)allowsRotation{
    return NO;
}
@end
