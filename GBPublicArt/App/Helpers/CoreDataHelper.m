//
//  CoreDataHelper.m
//  GBPublicArt
//
//  Created by Maxim Tolstikov on 09/10/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

#import "CoreDataHelper.h"

@interface CoreDataHelper()

@property(strong, nonatomic) NSPersistentContainer *persistentContainer;

@end

@implementation CoreDataHelper

+(instancetype)shared {
    static CoreDataHelper *stack;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stack = [CoreDataHelper new];
        [stack setUp];
    });
    return stack;
}

-(NSManagedObjectContext*)context {
    return _persistentContainer.viewContext;
}

-(void)setUp {
    self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"GBPublicArt"];
    [self.persistentContainer
     loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
            abort();
        }
    }];
}

-(NSManagedObject*)insertNewObjectToEntity:(NSString*)name {
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.context];
}

-(void)save {
    NSError *error = [NSError new];
    if ([self.context hasChanges] && ![self.context save:&error]) {
        NSLog(@"Failed to save CoreData context! %@", error.localizedDescription);
        abort();
    }
}

@end
