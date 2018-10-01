// Для описания синглтона по работе с API

#import "ApiManager.h"

@implementation ApiManager

// констурктор синглтона
+(instancetype)sharedInstance {
    static ApiManager* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ApiManager new];
    });
    return instance;
}

// загрузкa NSData с помощью URLSession
-(void) loadWith: (NSURL*)url completionHandler: (void(^)(NSData* data))completion {
    [[[NSURLSession sharedSession]
      dataTaskWithURL:url completionHandler:^(NSData * _Nullable data,
                                                        NSURLResponse * _Nullable response,
                                                        NSError * _Nullable error) {
          completion([NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers
                                                       error:nil]);
      }]resume];
}

@end
