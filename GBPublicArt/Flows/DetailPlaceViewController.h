//
//  DetailPlaceViewController.h
//  GBPublicArt
//
//  Created by Maxim Tolstikov on 01/10/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtPoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailPlaceViewController : UIViewController

-(instancetype)initWithArtPoint:(ArtPoint*)point;

@end

NS_ASSUME_NONNULL_END
