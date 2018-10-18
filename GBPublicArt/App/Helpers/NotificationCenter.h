//
//  NotificationCenter.h
//  GBPublicArt
//
//  Created by Maxim Tolstikov on 17/10/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct Notification {
    __unsafe_unretained NSString *_Nullable title;
    __unsafe_unretained NSString *_Nullable body;
    __unsafe_unretained NSDate *_Nullable date;
} Notification;

@interface NotificationCenter : NSObject

+ (instancetype _Nonnull)sharedInstance;

- (void)registirService;
- (void)sendNotification;

Notification NotificationMake(NSString *_Nullable title,
                              NSString *_Nullable body,
                              NSDate *_Nullable date);

@end

NS_ASSUME_NONNULL_END
