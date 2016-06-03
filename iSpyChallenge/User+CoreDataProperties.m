//
//  User+CoreDataProperties.m
//  iSpyChallenge
//
//  Created by Bennett Smith on 6/2/16.
//  Copyright © 2016 Blue Owl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

@dynamic email;
@dynamic username;
@dynamic avatarLargeHref;
@dynamic avatarMediumHref;
@dynamic avatarThumbnailHref;
@dynamic matches;
@dynamic challenges;
@dynamic ratings;

@end
