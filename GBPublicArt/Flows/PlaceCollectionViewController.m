// Для отображения объектов полученых от API

#import "PlaceCollectionViewController.h"
#import "DataProvider.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ArtPoint.h"
#import <MapKit/MapKit.h>
#import "MyMarker.h"
#import "MyMarkerAnnotation.h"

@interface PlaceCollectionViewController () <UISearchResultsUpdating>

@property (strong, nonatomic) NSArray *artObjects;
@property (strong, nonatomic) NSArray *searchArray;
@property (strong, nonatomic) UIImageView *mapImage;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation PlaceCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSearchControllerInNavigationBar];
    [self addCollectionView];
    [self getData];
    
}

#pragma mark setting Controller

-(void)setSearchControllerInNavigationBar {
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchArray = [NSArray new];
    _searchController.definesPresentationContext = YES;
    self.navigationItem.searchController = _searchController;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.title = @"Search";
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

-(void)getData {
    DataProvider *dataProvider = [DataProvider new];
    [dataProvider getPoints:^(NSArray * _Nonnull points) {
        self->_artObjects = points;
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_searchController.isActive && [_searchArray count] > 0) {
        return [_searchArray count];
    }
    return _artObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = UIColor.whiteColor;
    
    ArtPoint *point = _artObjects[indexPath.row];
    
    _mapView = [[MKMapView alloc] initWithFrame:cell.contentView.frame];
    //_mapView.layer.cornerRadius = 10;
    _mapView.scrollEnabled = NO;

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

#pragma mark searchResulrUpdate

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    if (searchController.searchBar.text) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title CONTAINS[cd]%@", searchController.searchBar.text];
        _searchArray = [_artObjects filteredArrayUsingPredicate:predicate];
        [_collectionView reloadData];
    }
    
}

@end
