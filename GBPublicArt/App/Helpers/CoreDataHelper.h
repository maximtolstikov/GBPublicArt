//
//  CoreDataHelper.h
//  GBPublicArt
//
//  Created by Maxim Tolstikov on 09/10/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+(instancetype)shared;

-(NSManagedObjectContext*)context;
-(NSManagedObject*)insertNewObjectToEntity:(NSString*)name;
-(void)save;

@end

NS_ASSUME_NONNULL_END
