//
//  Challenge+CoreDataProperties.h
//  iSpyChallenge
//
//  Created by Bennett Smith on 6/2/16.
//  Copyright © 2016 Blue Owl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Challenge.h"

NS_ASSUME_NONNULL_BEGIN

@interface Challenge (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *hint;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *photoHref;
@property (nullable, nonatomic, retain) NSSet<Match *> *matches;
@property (nullable, nonatomic, retain) User *creator;
@property (nullable, nonatomic, retain) NSSet<Rating *> *ratings;

@end

@interface Challenge (CoreDataGeneratedAccessors)

- (void)addMatchesObject:(Match *)value;
- (void)removeMatchesObject:(Match *)value;
- (void)addMatches:(NSSet<Match *> *)values;
- (void)removeMatches:(NSSet<Match *> *)values;

- (void)addRatingsObject:(Rating *)value;
- (void)removeRatingsObject:(Rating *)value;
- (void)addRatings:(NSSet<Rating *> *)values;
- (void)removeRatings:(NSSet<Rating *> *)values;

@end

NS_ASSUME_NONNULL_END
