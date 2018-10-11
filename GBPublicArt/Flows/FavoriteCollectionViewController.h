//
//  FavouriteCollectionViewController.h
//  GBPublicArt
//
//  Created by Maxim Tolstikov on 10/10/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteCollectionViewController : UIViewController <UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
