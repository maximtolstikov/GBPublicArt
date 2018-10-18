//
//  NotificationCenter.m
//  GBPublicArt
//
//  Created by Maxim Tolstikov on 17/10/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

#import "NotificationCenter.h"
#import <UserNotifications/UserNotifications.h>

@interface NotificationCenter() <UNUserNotificationCenterDelegate>
@end

@implementation NotificationCenter

+ (instancetype)sharedInstance {
    
    static NotificationCenter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NotificationCenter alloc] init];
    });
    return instance;
}

@end
