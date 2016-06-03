//
//  Rating+CoreDataProperties.h
//  iSpyChallenge
//
//  Created by Bennett Smith on 6/2/16.
//  Copyright © 2016 Blue Owl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Rating.h"

NS_ASSUME_NONNULL_BEGIN

@interface Rating (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *stars;
@property (nullable, nonatomic, retain) Challenge *challenge;
@property (nullable, nonatomic, retain) User *player;

@end

NS_ASSUME_NONNULL_END
