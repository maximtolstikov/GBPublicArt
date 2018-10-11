// Для отображения понравившихся точек

#import "FavoriteCollectionViewController.h"
#import "DataProvider.h"
#import "ArtPoint.h"
#include "CoreDataHelper.h"
#include "ArtObject+CoreDataProperties.h"
#import <MapKit/MapKit.h>
#import "MyMarker.h"
#import "MyMarkerAnnotation.h"

@interface FavoriteCollectionViewController () <MKMapViewDelegate>

@property (strong, nonatomic) NSMutableArray *artObjects;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKMapView *mapView;

@end

@implementation FavoriteCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    _artObjects = [NSMutableArray new];
    [self addCollectionView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self getFavoriteArrayObjects];
}

-(void)addCollectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 10.0;
    layout.itemSize = CGSizeMake(200.0, 200.0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = UIColor.whiteColor;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:_collectionView];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _artObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ArtPoint *point = _artObjects[indexPath.row];
    
    _mapView = [[MKMapView alloc] initWithFrame:cell.contentView.frame];
    _mapView.scrollEnabled = NO;
    _mapView.delegate = self;
    
    [cell.contentView addSubview:_mapView];
    
    [self setMapViewRegionWithLatitude:[point.latitude doubleValue]
                              longiude:[point.longitude doubleValue]];
    [self setMarkersFor:point];
    
    return cell;
}

-(void)setMapViewRegionWithLatitude: (double)latitude longiude: (double)longitude  {
    CLLocationCoordinate2D cordinate = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(cordinate, 200, 200);
    [_mapView setRegion:region animated:NO];
}

-(void)setMarkersFor: (ArtPoint*)point {
    MyMarker *marker = [[MyMarker alloc] initWithArtPoint:point];
    [_mapView addAnnotation:marker];
    [_mapView registerClass:[MyMarkerAnnotation class] forAnnotationViewWithReuseIdentifier:
     MKMapViewDefaultAnnotationViewReuseIdentifier];
}

#pragma mark подготовка массива

-(void)getFavoriteArrayObjects{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrayFavorits = [defaults objectForKey:@"favorits"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ArtObject"];
    NSError *error = nil;
    NSArray *results = [[CoreDataHelper.shared context] executeFetchRequest:request error:&error];
    
    if (!results) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
   
    for (int i = 0; i < 100; i++) {
        ArtPoint *point = [results objectAtIndex:i];
        if ([arrayFavorits containsObject:point.title]) {
            //NSLog(@"%ul", i);
            [self.artObjects addObject:point];
        }
    }

    NSLog(@"%lul", (unsigned long)[_artObjects count]);
    [_collectionView reloadData];
}


@end
