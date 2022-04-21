
//
//  GGMainAppDelegate.m
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

#import "GGMainAppDelegate.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface GGMainAppDelegate ()

@end

@implementation GGMainAppDelegate

//强制响应方法
-(BOOL)respondsToSelector:(SEL)aSelector{
   
    BOOL canResponds = [self methodForSelector:aSelector] != nil && [self methodForSelector:aSelector] != _objc_msgForward;

//    && [[self appDelegateMethods] containsObject:NSStringFromSelector(aSelector)]
    if (!canResponds) {
        canResponds = [self proxyToSelector:aSelector];
    }
    return canResponds;
}

// 服务是否可以响应方法
- (BOOL)proxyToSelector:(SEL)aSelector{
    return [[GGAppServiceManager sharedAppServiceManager] proxyCanResponseToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return [[GGAppServiceManager sharedAppServiceManager] methodSignatureToSelector:aSelector];
}
//方法转发到相应Service
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    [[GGAppServiceManager sharedAppServiceManager] proxyForwardInvocation:anInvocation];
}
    

-(NSArray<NSString *> *)appDelegateMethods{
    static NSMutableArray *methods = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       unsigned int methodCount = 0;
        struct objc_method_description *methodList = protocol_copyMethodDescriptionList(@protocol(UIApplicationDelegate), NO, YES, &methodCount);
        methods = [NSMutableArray arrayWithCapacity:methodCount];
        
        for (int i = 0; i < methodCount; ++i) {
            struct objc_method_description method = methodList[i];
            [methods addObject:NSStringFromSelector(method.name)];
        }
        free(methodList);
    });
    return methods;
}
@end
