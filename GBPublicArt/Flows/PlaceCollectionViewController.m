// Для отображения объектов полученых от API

#import "PlaceCollectionViewController.h"
#import "DataProvider.h"
#import "ArtPoint.h"
#import <MapKit/MapKit.h>
#import "MyMarker.h"
#import "MyMarkerAnnotation.h"
#include "CoreDataHelper.h"
#include "ArtObject+CoreDataProperties.h"

@interface PlaceCollectionViewController () <UISearchResultsUpdating, UIGestureRecognizerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) NSArray *artObjects;
@property (strong, nonatomic) NSArray *searchArray;
@property (strong, nonatomic) UIImageView *mapImage;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableDictionary *snapshotsMaps;
@property (strong, nonatomic) NSMutableArray *favoritsTitle;
@property BOOL selectFlag;

@end

@implementation PlaceCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _snapshotsMaps = [NSMutableDictionary new];
    _favoritsTitle = [NSMutableArray new];
    
    [self setSearchControllerInNavigationBar];
    [self addCollectionView];
    [self getData];
    [self addLongPressGestureToCollectionView];
    _selectFlag = NO;
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
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ArtObject"];
    NSError *error = nil;
    NSArray *results = [[CoreDataHelper.shared context] executeFetchRequest:request error:&error];
    
    if (!results) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    _artObjects = results;
    
}

-(void)addButtonAfterSelect {
    
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Save"
                                      style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(tapSaveButton)];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc]
                                        initWithTitle:@"Cancel"
                                        style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(tapCancelButton)];
    
    self.navigationItem.rightBarButtonItem = saveBarButton;
    self.navigationItem.leftBarButtonItem = cancelBarButton;
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                  forIndexPath:indexPath];
    cell.backgroundColor = UIColor.whiteColor;
    
    ArtPoint *point = _artObjects[indexPath.row];
    
    UIView *view = [_snapshotsMaps objectForKey:point.title];
    NSLog(@"view: %@", view);

    if (view) {
        [cell.contentView addSubview:view];
        return cell;
    }
    
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

#pragma mark <UICollectionViewDelegate>

-(void)addLongPressGestureToCollectionView {
    // attach long press gesture to collectionView
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(handleLongPress:)];
    longPressGesture.delegate = self;
    longPressGesture.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:longPressGesture];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTap:)];
    tapGesture.delegate = self;
    tapGesture.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:tapGesture];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint point = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        // get the cell at indexPath (the one you long pressed)
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        // do stuff with the cell
        [self selectCell:cell];
        [self addButtonAfterSelect];
        ArtPoint *artPoint = _artObjects[indexPath.row];
        [_favoritsTitle addObject:artPoint.title];
        NSLog(@"press cell %ld", (long)indexPath.row);
        [self.view snapshotViewAfterScreenUpdates:YES];
        _selectFlag = YES;
    }
}

-(void)handleTap:(UITapGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded || _selectFlag == NO) {
        return;
    }

    CGPoint point = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        ArtPoint *artPoint = _artObjects[indexPath.row];
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell.layer.borderWidth == 5) {
            [self deSelectCell:cell];
            [_favoritsTitle removeObject:artPoint.title];
            NSLog(@"%lu", [_favoritsTitle count]);
        } else {
            [self selectCell:cell];
            
            [_favoritsTitle addObject:artPoint.title];
            NSLog(@"%lu", [_favoritsTitle count]);

        }
    }
}

-(void)selectCell:(UICollectionViewCell*)cell {
    cell.layer.borderWidth = 5;
    cell.layer.borderColor = UIColor.greenColor.CGColor;
    [self.view snapshotViewAfterScreenUpdates:YES];
}

-(void)deSelectCell:(UICollectionViewCell*)cell {
    cell.layer.borderWidth = 0;
    cell.layer.borderColor = UIColor.blueColor.CGColor;
    [self.view snapshotViewAfterScreenUpdates:YES];
}

#pragma mark <MapViewDelegate>

// когда карта загрузилась полностью
- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    
    // ждем немного
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        // получаем название точки
        NSString *titleMyMarker = [mapView.annotations firstObject].title;
        // делаем снапшот карты
        UIView *mapImage = [mapView snapshotViewAfterScreenUpdates:YES];
        // сохраняем в соловарь uiview с ключем названия точки
        [self->_snapshotsMaps setObject:mapImage forKey:titleMyMarker];
        
    });
    
}

#pragma mark searchResulrUpdate

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    if (searchController.searchBar.text) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title CONTAINS[cd]%@",
                                  searchController.searchBar.text];
        _searchArray = [_artObjects filteredArrayUsingPredicate:predicate];
        [_collectionView reloadData];
    }
}

#pragma mark Save/Cancel buttons methods

-(void)tapSaveButton {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_favoritsTitle forKey:@"favorits"];
    [defaults synchronize];
    [self cleanMark];
}

-(void)tapCancelButton {

    [_favoritsTitle removeAllObjects];
    [self cleanMark];

}

-(void)cleanMark {
    for (int i = 0; i < 50; i++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:cellPath];
        [self deSelectCell:cell];
    }
}

@end
