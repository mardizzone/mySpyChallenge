//
//  DataController.h
//  iSpyChallenge
//
//  Created by Bennett Smith on 6/2/16.
//  Copyright © 2016 Blue Owl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "User.h"
#import "User+CoreDataProperties.h"
#import "Challenge.h"
#import "Challenge+CoreDataProperties.h"
#import "Rating.h"
#import "Rating+CoreDataProperties.h"
#import "Match.h"
#import "Match+CoreDataProperties.h"

@interface DataController : NSObject
@property (strong) NSManagedObjectContext *managedObjectContext;
- (instancetype)initWithCompletion:(void(^)(void))block;
- (instancetype)initWithPersistentStoreURL:(NSURL *)storeUrl completion:(void(^)(void))block;
- (void)saveContext;
- (BOOL)isPersistenceInitialized;

- (User *)authenticatedUser;

@end
