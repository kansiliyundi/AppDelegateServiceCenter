
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

#import "GGAppServiceManager.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface GGAppServiceManager()
@property (nonatomic, strong) Class<UIApplicationDelegate> appDelegateClass;
@property (nonatomic, strong) NSMutableDictionary<NSString*, id<GGAppService>> *servicesMap;
@end


@implementation GGAppServiceManager

static GGAppServiceManager *_shareManager = nil;
+(instancetype)sharedAppServiceManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _shareManager = [[GGAppServiceManager alloc] init];
    });
    
    return _shareManager;
}
    
-(instancetype)init{
    if (self = [super init]) {
        self.servicesMap = [NSMutableDictionary dictionary];
    }
    return self;
}
    
-(void)registerService:(id<GGAppService>)service{
    if (!service) {
        return;
    }
    //如果通过类型检查,则将服务注册进ServiceMap待命.
    id<GGAppService> pre = self.servicesMap[[service serviceName]];
    if (pre) {
        if ([service isKindOfClass:[pre class]]) {
            self.servicesMap[[service serviceName]] = service;
        }else{
            NSAssert([pre isKindOfClass:[service class]],
                     @"尝试注册 %@ 和 %@ 作为 %@ 服务的处理程序. \
                     不能确定这两个类的类型正确性",
                     [pre class], [service class], [service serviceName]);
        }
    }else{
        self.servicesMap[[service serviceName]] = service;
    }
}

- (id<GGAppService>)serviceForName:(NSString *)serviceName{
    if (!serviceName) return nil;
    id service = self.servicesMap[serviceName];
    if (!service) return nil;
    return service;
}
#pragma mark - 代理处理
-(NSMethodSignature *)methodSignatureToSelector:(SEL)aSelector{
    
    __block NSMethodSignature *tempSignature = nil;
    [self.servicesMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<GGAppService>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:aSelector]) {
            

            NSMethodSignature *signature = [(id)obj methodSignatureForSelector:aSelector];
            tempSignature = signature;
            *stop = YES;
        }
    }];
    
    return tempSignature;
}

-(BOOL)proxyCanResponseToSelector:(SEL)aSelector{
    
    __block IMP imp = NULL;
    
    [self.servicesMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<GGAppService>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:aSelector]) {
            imp = [(id)obj methodForSelector:aSelector];
            *stop = YES;
        }
    }];
    
    return imp != NULL && imp != _objc_msgForward;
}

    
-(void)proxyForwardInvocation:(NSInvocation *)anInvocation{
    
    NSMethodSignature *signature = anInvocation.methodSignature;
    NSUInteger argCount = signature.numberOfArguments;
    NSUInteger returnLength = signature.methodReturnLength;
    void *returnValueBytes = NULL;

    if (returnLength > 0) {
        returnValueBytes = alloca(returnLength);
    }
    [self.servicesMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<GGAppService>  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if (![obj respondsToSelector:anInvocation.selector]) {
            return;
        }
        
        
        NSAssert([[self objectTypeFromSignature:signature] isEqualToString:[self objectTypeFromSignature:[(id)obj methodSignatureForSelector:anInvocation.selector]]],@"selector-%@的方法签名%@-%@是无效的,请检查返回值类型和参数类型",NSStringFromSelector(anInvocation.selector),obj.serviceName,obj);

        NSInvocation *invok = [NSInvocation invocationWithMethodSignature:signature];
        invok.selector = anInvocation.selector;
        

        for (NSUInteger i = 0; i < argCount; ++i) {
 
            const char * argType = [signature getArgumentTypeAtIndex:i];
 
            NSUInteger argSize = 0;
            NSGetSizeAndAlignment(argType, &argSize, NULL);
    
            void *argValue = alloca(argSize);
            [anInvocation getArgument:&argValue atIndex:i];
            [invok setArgument:&argValue atIndex:i];
    }

        invok.target = obj;

        [invok invoke];

        if (returnValueBytes) {
            [invok getReturnValue:returnValueBytes];
        }
    }];

    if (returnValueBytes) {
        [anInvocation setReturnValue:returnValueBytes];
    }
}
    
    
-(NSString *)objectTypeFromSignature:(NSMethodSignature *)signature{
    
    NSMutableString *types = [NSMutableString stringWithFormat:@"%s",signature.methodReturnType?:"v"];
    
    for (NSUInteger i = 0; i < signature.numberOfArguments;  ++i) {
        [types appendFormat:@"%s",[signature getArgumentTypeAtIndex:i]];
    }
    return [types copy];
}
@end
