//
//  main.m
//  AppDelegateServiceCenter
//
//  Created by 方枪枪 on 2022/4/21.
//

#import <UIKit/UIKit.h>
#import "GGAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([GGAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
