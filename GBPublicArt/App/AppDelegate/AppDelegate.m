//
//  AppDelegate.m
//  GBPublicArt
//
//  Created by Maxim Tolstikov on 30/09/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [[UINavigationController alloc]
                                      initWithRootViewController:[MapViewController new]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
