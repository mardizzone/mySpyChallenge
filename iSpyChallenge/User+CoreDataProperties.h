//
//  User+CoreDataProperties.h
//  iSpyChallenge
//
//  Created by Bennett Smith on 6/2/16.
//  Copyright © 2016 Blue Owl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *avatarLargeHref;
@property (nullable, nonatomic, retain) NSString *avatarMediumHref;
@property (nullable, nonatomic, retain) NSString *avatarThumbnailHref;
@property (nullable, nonatomic, retain) NSSet<Match *> *matches;
@property (nullable, nonatomic, retain) NSSet<Challenge *> *challenges;
@property (nullable, nonatomic, retain) NSSet<Rating *> *ratings;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addMatchesObject:(Match *)value;
- (void)removeMatchesObject:(Match *)value;
- (void)addMatches:(NSSet<Match *> *)values;
- (void)removeMatches:(NSSet<Match *> *)values;

- (void)addChallengesObject:(Challenge *)value;
- (void)removeChallengesObject:(Challenge *)value;
- (void)addChallenges:(NSSet<Challenge *> *)values;
- (void)removeChallenges:(NSSet<Challenge *> *)values;

- (void)addRatingsObject:(Rating *)value;
- (void)removeRatingsObject:(Rating *)value;
- (void)addRatings:(NSSet<Rating *> *)values;
- (void)removeRatings:(NSSet<Rating *> *)values;

@end

NS_ASSUME_NONNULL_END
