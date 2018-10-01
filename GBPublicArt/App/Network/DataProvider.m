// Для запроса и предоставления готовых данных

#define API_TOKEN @"$$app_token=npc8l86jSCGB4CbRA6V2WTxC2"
#define HOST @"https://data.honolulu.gov/resource/csir-pcj2.json?"

#import "DataProvider.h"
#import "ApiManager.h"
#import "ArtPoint.h"


@implementation DataProvider

- (void)getPoints:(void (^)(NSArray* points))completion {
    [[ApiManager sharedInstance] loadWith:[self getUrl] completionHandler:^(NSData * _Nonnull data) {
        NSDictionary* response = data;
        NSMutableArray* array = [NSMutableArray new];
        if (response) {
            for (NSDictionary* dictionary in response){
                ArtPoint* artPoint = [[ArtPoint alloc] initWithDictionary:dictionary];
                [array addObject:artPoint];
            }
        }
        completion(array);
        
       // NSDictionary* json = [response valueForKey:@"articles"];
                
    }];
}

-(NSURL*)getUrl {
    NSString* urlString = [NSString
                           stringWithFormat:@"%@%@",
                           HOST,
                           API_TOKEN];
    return [NSURL URLWithString:urlString];
}


@end
