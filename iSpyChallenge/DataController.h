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

// Use this to access the managed object context for Core Data. By the time
// you have a reference to a DataController, this pointer has already been initialized.
@property (strong) NSManagedObjectContext *managedObjectContext;

// This provides you with access to a fictious "authenticated" user. This is useful
// when adding new challenges to the data set.
- (User *)authenticatedUser;

// Use this method to persist any changes to the sample data set.
- (void)saveContext;

// Ignore the following methods. They are used in the App Delegate to setup the
// Core Data stack.
- (instancetype)initWithCompletion:(void(^)(void))block;
- (instancetype)initWithPersistentStoreURL:(NSURL *)storeUrl completion:(void(^)(void))block;
- (BOOL)isPersistenceInitialized;
@end
