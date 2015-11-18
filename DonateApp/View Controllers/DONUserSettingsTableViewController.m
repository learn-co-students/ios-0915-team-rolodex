//
//  DONUserSettingsTableViewController.m
//  DonateApp
//
//  Created by Jon on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONUserSettingsTableViewController.h"
#import <Parse/Parse.h>
#import "DONUser.h"

@interface DONUserSettingsTableViewController ()
@property (nonatomic, strong) DONUser *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *usernameDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberDetailLabel;
@end

@implementation DONUserSettingsTableViewController

-(void)viewDidLoad
{
    self.currentUser = [DONUser currentUser];
    self.navigationItem.title = @"Settings";
    
    self.tableView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    [self loadSettingsData];
}

-(void)loadSettingsData
{
    self.usernameDetailLabel.text = self.currentUser.username;
    self.passwordDetailLabel.text = @"••••••••";
    self.emailDetailLabel.text = self.currentUser.email;
    self.phoneNumberDetailLabel.text = self.currentUser.user_phone;
}

#pragma mark - UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView
// numberOfRowsInSection:(NSInteger)section
//{
//    return 2;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    
//    [self configureCell:cell forRowAtIndexPath:indexPath];
//    
//    return cell;
//}
//
//- (void)configureCell:(UITableViewCell *)cell
//    forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.textLabel.text = @"Setting";
//    cell.detailTextLabel.text = @"jdoe";
//}
@end
