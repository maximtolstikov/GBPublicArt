//
//  ApiManager.h
//  GBPublicArt
//
//  Created by Maxim Tolstikov on 30/09/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApiManager : NSObject

+(instancetype) sharedInstance;
-(void) loadWith: (NSURL*)url completionHandler: (void(^)(NSData* data))completion;

@end

NS_ASSUME_NONNULL_END
