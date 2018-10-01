//
//  ArtPoint.m
//  GBPublicArt
//
//  Created by Maxim Tolstikov on 30/09/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

#import "ArtPoint.h"

@implementation ArtPoint

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        _location = [dictionary valueForKey:@"location"];
        _latitude = [dictionary valueForKey:@"latitude"];
        _longitude = [dictionary valueForKey:@"longitude"];
        _title = [dictionary valueForKey:@"title"];
    }
    
    return self;
}

@end
