//
//  RatingsTableViewController.h
//  iSpyChallenge
//
//  Created by Bennett Smith on 6/8/16.
//  Copyright © 2016 Blue Owl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataController.h"
#import "PhotoController.h"

#import "User.h"
#import "User+CoreDataProperties.h"

#import "Challenge.h"
#import "Challenge+CoreDataProperties.h"

@interface RatingsTableViewController : UITableViewController
@property (nonatomic, strong) DataController *dataController;
@property (nonatomic, strong) PhotoController *photoController;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Challenge *challenge;
@end
