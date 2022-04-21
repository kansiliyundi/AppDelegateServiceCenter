# AppDelegateServiceCenter
使用ForwardingTarget的为AppDelegate瘦身方案<br><br>
随着业务的增多,一个AppDelegate文件可能达到上千行的代码,不利于维护且耦合性非常强<br><br>
网络上也存在一些解耦方案,比如使用Method Swizzling对AppDelegate做AOP来解耦,但我认为这样的方式略显笨拙,因为Method Swizzling方法转发的使用需要谨慎，并伴随着一些侵入性，为了去掉侵入性的问题又要带来一些不必要开销，比如对一个KVO子类进行AOP。<br><br>
OC的动态绑定特性致使我们可以在运行时再决定方法的派发方案,所以我选择使用ForwardingTarget方式来实现类似多重代理的任务派发效果<br><br>
不同的功能可以分类抽离到不同的service中进行处理，每一个service都可以当做是一个独立的AppDelegate实现系统方法<br><br>

### 使用姿势
objective-C的工程

main.m：

```objc
#import "GGAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        appDelegateClassName = NSStringFromClass([GGAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
```
<br><br>
创建任务Service:

在implementation中使用GG_IMPORT_SERVICE宏注册服务
```objc
@interface xxxService
@end

@implementation xxxService
GG_IMPORT_SERVICE(@"xxxServiceName")

@end
```
<br><br>
因注册顺序不好控制导致多个service实现同一个系统方法顺序无法保证，如果有一定要最先调用的code需要在GGAppDelegate方法转发前调用:

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    /**
      如有在所有服务之前执行的第三方or服务,在这里实现
     */
    TODO
    if ([super proxyToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
        
        [super application:application didFinishLaunchingWithOptions:launchOptions];
    }
    return YES;
}
```
<br><br>
调用服务中的方法或属性 不建议在多个服务中重写同名的非系统方法或属性 会导致获取不准确的问题，只能获取到最后一个servier的返回值:
```objc
    id xxx = nli;
    if ([UIApplication.sharedApplication.delegate proxyToSelector:@selector(xxx)]) {
        xxx = [super performSelector:@selector(xxx)];
    }
    if(xxx){
       TODO
    }
```

