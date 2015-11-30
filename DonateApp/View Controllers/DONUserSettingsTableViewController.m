//
//  DONUserSettingsTableViewController.m
//  DonateApp
//
//  Created by Jon on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONUserSettingsTableViewController.h"
#import "DONUserSettingsUpdateViewController.h"
#import <Parse/Parse.h>
#import "DONUser.h"
#import "DONSettingsEnum.h"
#import "DONMainViewController.h"

@interface DONUserSettingsTableViewController () <UITableViewDelegate>
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
   
    // Remove "Back" nav bar text next to back arrow
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1.0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadSettingsData];
}

-(void)loadSettingsData
{
    self.usernameDetailLabel.text = self.currentUser.username;
    self.passwordDetailLabel.text = @"••••••••";
    self.emailDetailLabel.text = self.currentUser.email;
    self.phoneNumberDetailLabel.text = self.currentUser.user_phone;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section)
    {
        case SettingsSectionUserInformation:
        {
            NSString *fieldStr;
            NSString *valueStr;

            switch(indexPath.row)
            {
                case UserInformationSettingsUsername:
                    fieldStr = @"username";
                    valueStr = self.currentUser.username;
                    break;
                    
                case UserInformationSettingsPassword:
                    fieldStr = @"password";
                    valueStr = @"••••••••";
                    break;
                    
                case UserInformationSettingsEmail:
                    fieldStr = @"email";
                    valueStr = self.currentUser.email;
                    break;
                    
                case UserInformationSettingsPhoneNumber:
                    fieldStr = @"phone number";
                    valueStr = self.currentUser.user_phone;
                    break;
            }
            
            [self displaySettingsUpdateViewControllerWithField:fieldStr value:valueStr validationType:indexPath.row];
            break;
        }
        case SettingsSectionOtherInformation:
            switch(indexPath.row)
            {
                case OtherInformationSettingsAbout:
                    [self displayAboutAlert];
                    break;
                case OtherInformationSettingsSignOut:
                    [DONUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
                        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                        for (UIViewController *aViewController in allViewControllers) {
                            if ([aViewController isKindOfClass:[DONMainViewController class]]) {
                                [self.navigationController popToViewController:aViewController animated:YES];
                            }
                        }
                    }];
                    break;
            }
        break;
    }
}


-(void)displaySettingsUpdateViewControllerWithField:(NSString *)fieldString
                                              value:(NSString *)valueString
                                     validationType:(UserInformationSettings)validationType
{
    DONUserSettingsUpdateViewController *updateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"updateSettingsViewController"];

    updateViewController.fieldToChange = fieldString;
    updateViewController.currentFieldValue = valueString;
    updateViewController.validationType = validationType;
    
    [self.navigationController pushViewController:updateViewController animated:YES];
}

-(void)displayAboutAlert
{
    UIAlertController *display = [UIAlertController alertControllerWithTitle:@"About" message:@"Version 1.0 - Build 1\n\nDesigned at Flatiron School By:\n\nJonathan Lazar\nMichael Singer\nGuang Zhu\nLaurent Farci" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];

    [display addAction:okAction];
    [self presentViewController:display animated:YES completion:nil];
}

@end
