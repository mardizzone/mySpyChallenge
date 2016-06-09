//
//  DataController.m
//  iSpyChallenge
//
//  Created by Bennett Smith on 6/2/16.
//  Copyright © 2016 Blue Owl. All rights reserved.
//

#import "DataController.h"
#import "PhotoController.h"

#import "User.h"
#import "User+CoreDataProperties.h"
#import "Challenge.h"
#import "Challenge+CoreDataProperties.h"
#import "Rating.h"
#import "Rating+CoreDataProperties.h"
#import "Match.h"
#import "Match+CoreDataProperties.h"

#import "NSArray+RandomElement.h"

@interface DataController()
@property (nonatomic, copy) void (^initBlock)(void);
@property (strong) NSManagedObjectContext *writerContext;
@property BOOL persistenceInitialized;
- (void)initializeCoreDataStackUsingPersistentStoreURL:(NSURL *)storeURL;
+ (NSURL *)persistentStoreURL;
@end

@implementation DataController

- (instancetype)init {
    return [self initWithCompletion:NULL];
}

- (instancetype)initWithCompletion:(void(^)(void))block {
    return [self initWithPersistentStoreURL:[DataController persistentStoreURL] completion:block];
}

- (instancetype)initWithPersistentStoreURL:(NSURL *)storeUrl completion:(void (^)(void))block {
    self = [super init];
    if (self) {
        _authenticatedUser = nil;
        [self setPersistenceInitialized:NO];
        [self setInitBlock:block];
        [self initializeCoreDataStackUsingPersistentStoreURL:storeUrl];
    }
    return self;
}

- (BOOL)isPersistenceInitialized {
    return [self persistenceInitialized];
}

- (void)saveContext {
    NSManagedObjectContext *moc = [self managedObjectContext];
    [moc performBlockAndWait:^{
        if (![moc hasChanges]) {
            return;
        }
        
        NSError *error = nil;
        if (![moc save:&error]) {
            NSLog(@"Failed to save: %@\n%@", [error localizedDescription],
                  [error userInfo]);
            abort();
        }
    }];
    
    moc = [self writerContext];
    [moc performBlock:^{
        if (![moc hasChanges]) {
            return;
        }
        
        NSError *error = nil;
        if (![moc save:&error]) {
            NSLog(@"Failed to save: %@\n%@", [error localizedDescription],
                  [error userInfo]);
            abort();
        }
    }];
}

- (UIImage *)samplePhotoWithName:(NSString *)photoName {
    NSString *name = [photoName stringByDeletingPathExtension];
    NSString *ext = [photoName pathExtension];
    NSURL *photoURL = [[NSBundle mainBundle] URLForResource:name withExtension:ext subdirectory:@"iSpySampleData"];
    NSData *imageData = [NSData dataWithContentsOfURL:photoURL];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

- (NSData *)sampleUsersJSON {
    NSURL *usersURL = [[NSBundle mainBundle] URLForResource:@"users" withExtension:@"json" subdirectory:@"iSpySampleData"];
    NSData *users = [NSData dataWithContentsOfURL:usersURL];
    return users;
}

- (NSData *)sampleChallengesJSON {
    NSURL *challengesURL = [[NSBundle mainBundle] URLForResource:@"challenges" withExtension:@"json" subdirectory:@"iSpySampleData"];
    NSData *challenges = [NSData dataWithContentsOfURL:challengesURL];
    return challenges;
}

- (void)populateWithSampleData {
    PhotoController *photoController = [[PhotoController alloc] init];
    [photoController removeAllPhotos];
    
    NSManagedObjectContext *moc = nil;
    NSManagedObjectContextConcurrencyType type = NSPrivateQueueConcurrencyType;
    moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
    [moc setParentContext:[self managedObjectContext]];
    
    // Load up the users first.
    
    [moc performBlockAndWait:^{
        id usersJson = [NSJSONSerialization JSONObjectWithData:[self sampleUsersJSON] options:0 error:nil];
        if ([usersJson isKindOfClass:[NSDictionary class]]) {
            NSDictionary *usersDictionary = (NSDictionary *)usersJson;
            NSArray *results = [usersDictionary valueForKey:@"results"];
            for (id element in results) {
                if ([element isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *userDictionary = (NSDictionary *)element;
                    NSDictionary *loginDictionary = (NSDictionary *)[userDictionary objectForKey:@"login"];
                    NSDictionary *pictureDictionary = (NSDictionary *)[userDictionary objectForKey:@"picture"];
                    NSString *email = [userDictionary objectForKey:@"email"];
                    NSString *username = [loginDictionary objectForKey:@"username"];
                    NSString *avatarLargeHref = [pictureDictionary objectForKey:@"large"];
                    NSString *avatarMediumHref = [pictureDictionary objectForKey:@"medium"];
                    NSString *avatarThumbnailHref = [pictureDictionary objectForKey:@"thumbnail"];
                    
                    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc];
                    user.email = email;
                    user.username = username;
                    user.avatarLargeHref = avatarLargeHref;
                    user.avatarMediumHref = avatarMediumHref;
                    user.avatarThumbnailHref = avatarThumbnailHref;
                }
            }
        }
        
        NSError *error = nil;
        if (![moc save:&error]) {
            NSLog(@"Failed to populate the users: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
    }];
    
    // Now load the challenges.
    [moc performBlockAndWait:^{
        
        NSFetchRequest *request = nil;
        request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        NSError *error = nil;
        NSArray *users = [moc executeFetchRequest:request error:&error];
        NSAssert(users != nil, [error localizedDescription]);
        
        id challengesJson = [NSJSONSerialization JSONObjectWithData:[self sampleChallengesJSON] options:0 error:nil];
        if ([challengesJson isKindOfClass:[NSDictionary class]]) {
            NSArray *challenges = [challengesJson valueForKey:@"challenges"];
            for (id element in challenges) {
                if ([element isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *challengeDictionary = (NSDictionary *)element;
                    NSString *hint = [challengeDictionary objectForKey:@"hint"];
                    double latitude = [[challengeDictionary objectForKey:@"latitude"] doubleValue];
                    double longitude = [[challengeDictionary objectForKey:@"longitude"] doubleValue];
                    NSString *photoName = [challengeDictionary objectForKey:@"photo"];
                    UIImage *photo = [self samplePhotoWithName:photoName];
                    [photoController addPhotoWithName:photoName image:photo];
                    
                    Challenge *challenge = [NSEntityDescription insertNewObjectForEntityForName:@"Challenge" inManagedObjectContext:moc];
                    challenge.hint = hint;
                    challenge.photoHref = photoName;
                    challenge.latitude = [NSNumber numberWithDouble:latitude];
                    challenge.longitude = [NSNumber numberWithDouble:longitude];
                    User *creator = (User *)[users randomObject];
                    challenge.creator = creator;
                    
                    for (User *user in users) {
                        NSInteger stars = arc4random_uniform((u_int32_t)5);
                        Rating *rating = [NSEntityDescription insertNewObjectForEntityForName:@"Rating" inManagedObjectContext:moc];
                        rating.stars = [NSNumber numberWithInteger:stars];
                        rating.challenge = challenge;
                        rating.player = user;
                    }
                }
            }
        }
        
        if (![moc save:&error]) {
            NSLog(@"Failed to populate the users: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
    }];
    
    // Now load the wins
    [moc performBlockAndWait:^{
        NSFetchRequest *userRequest = nil;
        userRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        NSError *error = nil;
        NSArray *users = [moc executeFetchRequest:userRequest error:&error];
        NSAssert(users != nil, [error localizedDescription]);
        
        NSFetchRequest *challengeRequest = nil;
        challengeRequest = [NSFetchRequest fetchRequestWithEntityName:@"Challenge"];
        NSArray *challenges = [moc executeFetchRequest:challengeRequest error:&error];
        NSAssert(challenges != nil, [error localizedDescription]);
        
        NSInteger numChallenges = [challenges count];
        for (User *user in users) {
            NSInteger numMatches = arc4random_uniform((u_int32_t)numChallenges);
            for (NSInteger matchNumber = 0; matchNumber < numMatches; matchNumber++) {
                NSInteger challengeIndex = arc4random_uniform((u_int32_t)numChallenges);
                Challenge *challenge = [challenges objectAtIndex:challengeIndex];
                Match *match = [NSEntityDescription insertNewObjectForEntityForName:@"Match" inManagedObjectContext:moc];
                match.photoHref = challenge.photoHref;
                match.longitude = challenge.longitude;
                match.latitude = challenge.latitude;
                match.player = user;
                match.challenge = challenge;
                match.verified =  [NSNumber numberWithBool:NO];
            }
        }
        
        if (![moc save:&error]) {
            NSLog(@"Failed to populate the users: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
    }];
}

- (void)fakeAuthentication {
    NSManagedObjectContext *moc = nil;
    NSManagedObjectContextConcurrencyType type = NSPrivateQueueConcurrencyType;
    moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
    [moc setParentContext:[self managedObjectContext]];
    
    [self willChangeValueForKey:@"authenticatedUser"];
    __block NSManagedObjectID *userId = nil;
    [moc performBlockAndWait:^{
        NSFetchRequest *userRequest = nil;
        userRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        NSError *error = nil;
        NSArray *users = [moc executeFetchRequest:userRequest error:&error];
        NSAssert(users != nil, [error localizedDescription]);
        userId = [[users firstObject] objectID];
    }];
    
    _authenticatedUser = [[self managedObjectContext] objectWithID:userId];
    
    [self didChangeValueForKey:@"authenticatedUser"];
}

#pragma mark - Core Data stack

+ (NSURL *)persistentStoreURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *sURL = nil;
    sURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    sURL = [sURL URLByAppendingPathComponent:@"iSpyData.sqlite"];
    return sURL;
}

- (void)initializeCoreDataStackUsingPersistentStoreURL:(NSURL *)storeURL {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iSpyChallenge"
                                              withExtension:@"momd"];
    NSAssert(modelURL != nil, @"Failed to find model URL");
    
    NSManagedObjectModel *mom = nil;
    mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *psc = nil;
    psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    NSManagedObjectContext *moc = nil;
    NSManagedObjectContext *writer = nil;
    NSUInteger type = NSPrivateQueueConcurrencyType;
    
    writer = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
    [writer setPersistentStoreCoordinator:psc];
    
    type = NSMainQueueConcurrencyType;
    moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
    [moc setParentContext:writer];
    
    [self setWriterContext:writer];
    [self setManagedObjectContext:moc];
    
    dispatch_queue_t queue;
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL persistentStoreExists = NO;
        BOOL isDirectory = NO;
        if ([fileManager fileExistsAtPath:[storeURL path] isDirectory:&isDirectory] == NO) {
            persistentStoreExists = NO;
        }
        else {
            persistentStoreExists = YES;
        }
        
        NSError *error = nil;
        NSPersistentStoreCoordinator *coordinator = nil;
        coordinator = [[self managedObjectContext] persistentStoreCoordinator];
        NSPersistentStore *store = nil;
        store = [coordinator addPersistentStoreWithType:NSInMemoryStoreType
                                          configuration:nil
                                                    URL:storeURL
                                                options:options
                                                  error:&error];
        if (!store) {
            NSLog(@"Error adding persistent store to coordinator %@\n%@",
                  [error localizedDescription], [error userInfo]);
            abort();
            //Present a user facing error
        }
        
        [self populateWithSampleData];
        
        [self setPersistenceInitialized:YES];
        
        [self fakeAuthentication];
        
        if ([self initBlock]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self initBlock]();
            });
        }
    });
}

@end
