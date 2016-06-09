//
//  UserTableViewController.m
//  iSpyChallenge
//
//  Created by Bennett Smith on 6/3/16.
//  Copyright © 2016 Blue Owl. All rights reserved.
//

#import "UserTableViewController.h"

@interface UserTableViewController ()

@end

@implementation UserTableViewController

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
        [controller performSelector:@selector(setUser:) withObject:self.user];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showChallenges"]) {
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
        return 5;
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
            cell.textLabel.text = self.user.username;
            cell.detailTextLabel.text = @"username";
            break;
        case 1:
            cell.textLabel.text = self.user.email;
            cell.detailTextLabel.text = @"email";
            break;
        case 2:
            cell.textLabel.text = self.user.avatarLargeHref;
            cell.detailTextLabel.text = @"avatarLargeHref";
            break;
        case 3:
            cell.textLabel.text = self.user.avatarMediumHref;
            cell.detailTextLabel.text = @"avatarMediumHref";
            break;
        case 4:
            cell.textLabel.text = self.user.avatarThumbnailHref;
            cell.detailTextLabel.text = @"avatarThumbnailHref";
            break;
        default:
            break;
    }
}

- (void)prepareRelationshipCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Challenges";
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
                // Challenges
                [self performSegueWithIdentifier:@"showChallenges" sender:self];
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
