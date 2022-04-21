//
//  ViewController.m
//  AppDelegateServiceCenter
//
//  Created by 方枪枪 on 2022/4/21.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColor.whiteColor];
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    NSLog(@"%@",window);
    
}


@end
