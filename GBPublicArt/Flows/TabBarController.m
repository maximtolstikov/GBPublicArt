// Для гавной таб бар навигации

#import "TabBarController.h"
#import "MapViewController.h"
#import "PlaceCollectionViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)init {
    self= [super initWithNibName:nil bundle:nil];
    if (self) {
        MapViewController *mapViewController = [MapViewController new];
        mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
        UINavigationController *placeController = [[UINavigationController alloc]
                                                   initWithRootViewController:[PlaceCollectionViewController new]];
        placeController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:1];
        
        self.viewControllers = @[mapViewController, placeController];
        self.selectedIndex = 0;
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
