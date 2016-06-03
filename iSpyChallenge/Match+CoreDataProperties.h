//
//  Match+CoreDataProperties.h
//  iSpyChallenge
//
//  Created by Bennett Smith on 6/2/16.
//  Copyright © 2016 Blue Owl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Match.h"

NS_ASSUME_NONNULL_BEGIN

@interface Match (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *photoHref;
@property (nullable, nonatomic, retain) NSNumber *verified;
@property (nullable, nonatomic, retain) Challenge *challenge;
@property (nullable, nonatomic, retain) User *player;

@end

NS_ASSUME_NONNULL_END
