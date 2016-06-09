//
//  MatchesTableViewController.m
//  iSpyChallenge
//
//  Created by Bennett Smith on 6/3/16.
//  Copyright © 2016 Blue Owl. All rights reserved.
//

#import "MatchesTableViewController.h"

#import "User.h"
#import "User+CoreDataProperties.h"
#import "Match.h"
#import "Match+CoreDataProperties.h"

#import "MatchTableViewController.h"

#import <CoreData/CoreData.h>

@interface MatchesTableViewController () <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation MatchesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)injectPropertiesInController:(UIViewController *)controller {
    if ([controller respondsToSelector:@selector(setDataController:)]) {
        [controller performSelector:@selector(setDataController:) withObject:self.dataController];
    }
    if ([controller respondsToSelector:@selector(setPhotoController:)]) {
        [controller performSelector:@selector(setPhotoController:) withObject:self.photoController];
    }
    if ([controller respondsToSelector:@selector(setChallenge:)]) {
        Challenge *challenge = (Challenge *)[self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        [controller performSelector:@selector(setChallenge:) withObject:challenge];
    }
    if ([controller respondsToSelector:@selector(setMatch:)]) {
        Match *match = (Match *)[self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        [controller performSelector:@selector(setMatch:) withObject:match];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showMatch"]) {
        [self injectPropertiesInController:segue.destinationViewController];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) return;
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showMatch" sender:self];
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Match"];
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"player = %@", self.user];
    [fetchRequest setPredicate:pred];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"verified" ascending:YES]]];
    
    NSManagedObjectContext *moc = [self.dataController managedObjectContext];
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:@"DataBrowserMatch"]];
    [[self fetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    if ([[self fetchedResultsController] performFetch:&error] == NO) {
        NSLog(@"Unresolved error %@\n%@", [error localizedDescription], [error userInfo]);
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[[self tableView] cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
    Match *match = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    NSString *latlon = [NSString stringWithFormat:@"%@, %@", match.latitude, match.longitude];
    
    [[cell textLabel] setText:([match.verified boolValue] == YES ? @"Verified Match!" : @"Match")];
    [[cell detailTextLabel] setText:latlon];
    UIImage *photo = [self.photoController photoWithName:match.photoHref];
    [[cell imageView] setImage:photo];
}

@end
