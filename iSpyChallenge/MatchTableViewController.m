//
//  MatchTableViewController.m
//  iSpyChallenge
//
//  Created by Bennett Smith on 6/3/16.
//  Copyright © 2016 Blue Owl. All rights reserved.
//

#import "MatchTableViewController.h"

#import "User.h"
#import "User+CoreDataProperties.h"
#import "Match.h"
#import "Match+CoreDataProperties.h"

#import <CoreData/CoreData.h>

@interface MatchTableViewController () <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation MatchTableViewController

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
    if ([controller respondsToSelector:@selector(setUser:)]) {
        [controller performSelector:@selector(setUser:) withObject:self.match.player];
    }
    if ([controller respondsToSelector:@selector(setChallenge:)]) {
        [controller performSelector:@selector(setChallenge:) withObject:self.match.challenge];
    }
    if ([controller respondsToSelector:@selector(setMatch:)]) {
        [controller performSelector:@selector(setMatch:) withObject:self.match];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showChallenge"]) {
        [self injectPropertiesInController:segue.destinationViewController];
    }
    else if ([[segue identifier] isEqualToString:@"showPlayer"]) {
        [self injectPropertiesInController:segue.destinationViewController];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    else {
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Attributes";
    }
    else if (section == 1) {
        return @"Relationships";
    }
    else {
        return @"";
    }
}

- (void)prepareAttributeCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.match.latitude];
            cell.detailTextLabel.text = @"latitude";
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.match.longitude];
            cell.detailTextLabel.text = @"longitude";
            break;
        case 2:
            cell.textLabel.text = self.match.photoHref;
            cell.detailTextLabel.text = @"photoHref";
            break;
        case 3:
            cell.textLabel.text = ([self.match.verified boolValue] == YES ? @"YES" : @"NO");
            cell.detailTextLabel.text = @"verified";
            break;
        default:
            break;
    }
}

- (void)prepareRelationshipCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Challenge";
            break;
        case 1:
            cell.textLabel.text = @"Player";
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AttributeCell" forIndexPath:indexPath];
        [self prepareAttributeCell:cell forIndexPath:indexPath];
    }
    else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RelationshipCell" forIndexPath:indexPath];
        [self prepareRelationshipCell:cell forIndexPath:indexPath];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                // Challenge
                [self performSegueWithIdentifier:@"showChallenge" sender:self];
                break;
            case 1:
                // Player
                [self performSegueWithIdentifier:@"showPlayer" sender:self];
                break;
            default:
                break;
        }
    }
    else {
        
    }
}

@end
