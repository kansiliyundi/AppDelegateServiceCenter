
//
//  GGAppServiceManager.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 注册宏
 @param name 服务名
 */
#define GG_IMPORT_SERVICE(name) \
+ (void)load {[[GGAppServiceManager sharedAppServiceManager] registerService:[self new]];} \
- (NSString *)serviceName { return name; }


NS_ASSUME_NONNULL_BEGIN
@protocol GGAppService <UIApplicationDelegate>

@required
//注册服务名
-(NSString *)serviceName;
@end


@interface GGAppServiceManager : NSObject
    
+ (instancetype)sharedAppServiceManager;
// 注册服务
-(void)registerService:(id<GGAppService>)service;
// 获取服务
- (id<GGAppService>)serviceForName:(NSString *)serviceName;
// 代理是否可以响应方法
-(BOOL)proxyCanResponseToSelector:(SEL)aSelector;
// 处理转发
-(void)proxyForwardInvocation:(NSInvocation *)anInvocation;
// 获取方法签名
-(NSMethodSignature *)methodSignatureToSelector:(SEL)aSelector;
@end
NS_ASSUME_NONNULL_END
