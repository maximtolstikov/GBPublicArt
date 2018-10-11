//
//  ArtObject+CoreDataProperties.h
//  GBPublicArt
//
//  Created by Maxim Tolstikov on 11/10/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
//

#import "ArtObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ArtObject (CoreDataProperties)

+ (NSFetchRequest<ArtObject *> *)fetchRequest;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *location;

@end

NS_ASSUME_NONNULL_END
