//
//  PPRootUIService.h
//  TestAppDelegateService
//
//  Created by yuemei on 2017/9/21.
//  Copyright © 2017年 yuemei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGMainAppDelegate.h"

@interface GGRootUIService : NSObject <GGAppService>

@property (nonatomic, strong) UIWindow *window;
@property(nonatomic,assign) BOOL allowsRotation;

@end
