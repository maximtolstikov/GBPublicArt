//
//  MyMarker.h
//  GBPublicArt
//
//  Created by Maxim Tolstikov on 30/09/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ArtPoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyMarker : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic, strong) ArtPoint* point;

-(instancetype)initWithArtPoint:(ArtPoint*)point;

@end

NS_ASSUME_NONNULL_END
