//
//  ArtObject+CoreDataProperties.m
//  GBPublicArt
//
//  Created by Maxim Tolstikov on 11/10/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//
//

#import "ArtObject+CoreDataProperties.h"

@implementation ArtObject (CoreDataProperties)

+ (NSFetchRequest<ArtObject *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ArtObject"];
}

@dynamic title;
@dynamic longitude;
@dynamic latitude;
@dynamic location;

@end
