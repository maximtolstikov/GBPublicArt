
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlaceCollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
