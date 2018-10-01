// Для описания контроллера карты

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "DataProvider.h"
#import "ArtPoint.h"
#import "MyMarker.h"
#import "MyMarkerAnnotation.h"
#import "DetailPlaceViewController.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) DataProvider *dataProvider;
@property (strong, nonatomic) NSArray *artPoints;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _coordinate = CLLocationCoordinate2DMake(21.290824, -157.85131);
    _dataProvider = [DataProvider new];
    [_dataProvider getPoints:^(NSArray * _Nonnull points) {
        self->_artPoints = points;
        for (ArtPoint *point in self->_artPoints) {
            dispatch_async(dispatch_get_main_queue(),^{
                [self setMarkersFor:point];
            });
            
        }
    }];
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_mapView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_coordinate, 10000, 10000);
    [_mapView setRegion:region animated:YES];
    [self startLocation];
}

-(void)startLocation {
    _locationManager = [[CLLocationManager alloc] init];
    
    if (!CLLocationManager.locationServicesEnabled) {
        return;
    }
    _locationManager.delegate = self;
    if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    } else {
        _mapView.showsUserLocation = YES;
    }
    
    [_locationManager startMonitoringSignificantLocationChanges];
}

-(void)setMarkersFor: (ArtPoint*)point {

    MyMarker *marker = [[MyMarker alloc] initWithArtPoint:point];
    
    [_mapView addAnnotation:marker];
    _mapView.delegate = self;
    [_mapView registerClass:[MyMarkerAnnotation class] forAnnotationViewWithReuseIdentifier:
     MKMapViewDefaultAnnotationViewReuseIdentifier];
}

#pragma mark Anatation methods

- (void)mapView:(MKMapView *)mapView
        annotationView:(MKAnnotationView *)view
        calloutAccessoryControlTapped:(UIControl *)control {
    [self findArtPoint:view.annotation.title];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"did select");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"New location = %@", locations);
}

- (void)findArtPoint:(NSString*)title {
    for (ArtPoint* point in _artPoints) {
        if (point.title == title) {
            [self goToDetail:point];
        }
    }
}

-(void)goToDetail:(ArtPoint*)point {
    DetailPlaceViewController* detailPlace = [[DetailPlaceViewController alloc] initWithArtPoint:point];
    [self.navigationController pushViewController:detailPlace animated:true];
}

@end
