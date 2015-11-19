//
//  DONMainViewController.m
//  DonateApp
//
//  Created by Jon on 11/17/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONMainViewController.h"
#import "DONCollectionViewController.h"
#import "DONUser.h"

@interface DONMainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentUserLabel;

@end

@implementation DONMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTestingData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)guangLink:(id)sender
{
    
}

# pragma mark Jon Testing Functionality
-(void)configureTestingData
{
    NSString *currentUserName;
    if ([DONUser currentUser]) {
        currentUserName = [NSString stringWithFormat:@"%@ logged in", [DONUser currentUser].username];
    } else {
        currentUserName = @"No user logged in";
    }
    
    self.currentUserLabel.text = currentUserName;
}

- (IBAction)loginButtonPressed:(id)sender {
    [DONUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        [DONUser testUserWithCompletion:^(DONUser *user, NSError *error) {
            NSLog(@"Test user login complete.");
            [self configureTestingData];
        }];
    }];
}

- (IBAction)loginJonPressed:(id)sender {
    [DONUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        [DONUser logInWithUsernameInBackground:@"jlazar" password:@"12345" block:^(PFUser * _Nullable user, NSError * _Nullable error) {
            NSLog(@"Jon user login complete");
            [self configureTestingData];
        }];
    }];
}
- (IBAction)logOutTapped:(id)sender {
    [DONUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        NSLog(@"Logout complete");
        [self configureTestingData];
    }];
}

- (IBAction)showProfileButtonTapped:(id)sender {
    if (![DONUser currentUser]) {
        NSLog(@"No user detected.");
    } else {
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Jon" bundle:nil];
        UIViewController *theInitialViewController = [secondStoryBoard instantiateInitialViewController];
        [self.navigationController pushViewController:theInitialViewController animated:YES];
    }
}


@end
