// Для описания метки

#import "MyMarker.h"

@implementation MyMarker

-(instancetype)initWithArtPoint:(ArtPoint*)point  {
    self = [super init];
    if (self) {
        CLLocationCoordinate2D coordinatePoint = CLLocationCoordinate2DMake([point.latitude doubleValue],
                                                                            [point.longitude doubleValue]);
        _coordinate = coordinatePoint;
        _point = point;
    }
    return self;
}

- (NSString *)title {
    return _point.title;
}

- (NSString *)subtitle {
    return _point.location;
}

@end
