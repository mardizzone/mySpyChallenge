//
//  ChallengeTableViewController.m
//  iSpyChallenge
//
//  Created by Bennett Smith on 6/3/16.
//  Copyright © 2016 Blue Owl. All rights reserved.
//

#import "ChallengeTableViewController.h"

#import "User.h"
#import "User+CoreDataProperties.h"
#import "Challenge.h"
#import "Challenge+CoreDataProperties.h"

#import <CoreData/CoreData.h>

@interface ChallengeTableViewController () <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ChallengeTableViewController

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
        [controller performSelector:@selector(setUser:) withObject:self.challenge.creator];
    }
    if ([controller respondsToSelector:@selector(setChallenge:)]) {
        [controller performSelector:@selector(setChallenge:) withObject:self.challenge];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showCreator"]) {
        [self injectPropertiesInController:segue.destinationViewController];
    }
    else if ([[segue identifier] isEqualToString:@"showMatches"]) {
        [self injectPropertiesInController:segue.destinationViewController];
    }
    else if ([[segue identifier] isEqualToString:@"showRatings"]) {
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
        return 3;
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
            cell.textLabel.text = self.challenge.hint;
            cell.detailTextLabel.text = @"hint";
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.challenge.latitude];
            cell.detailTextLabel.text = @"latitude";
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.challenge.longitude];
            cell.detailTextLabel.text = @"longitude";
            break;
        case 3:
            cell.textLabel.text = self.challenge.photoHref;
            cell.detailTextLabel.text = @"photoHref";
            break;
        default:
            break;
    }
}

- (void)prepareRelationshipCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Creator";
            break;
        case 1:
            cell.textLabel.text = @"Matches";
            break;
        case 2:
            cell.textLabel.text = @"Ratings";
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
                // Creator
                [self performSegueWithIdentifier:@"showCreator" sender:self];
                break;
            case 1:
                // Matches
                [self performSegueWithIdentifier:@"showMatches" sender:self];
                break;
            case 2:
                // Ratings
                [self performSegueWithIdentifier:@"showRatings" sender:self];
                break;
            default:
                break;
        }
    }
    else {
        
    }
}

@end
