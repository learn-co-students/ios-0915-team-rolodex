//
//  DONMainViewController.m
//  DonateApp
//
//  Created by Jon on 11/17/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONMainViewController.h"
//#import "DONCollectionViewController.h"
#import "DONUser.h"
#import "DONViewOtherUserProfileViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "DONItem.h"
#import "DONItemViewController.h"

@interface DONMainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentUserLabel;

@end

@implementation DONMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupLeftMenuButton];
    
    self.view.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1.0];
    UIColor * barColor = [UIColor whiteColor];
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
        [self.navigationController.navigationBar setBarTintColor:barColor];
    }
    else {
        [self.navigationController.navigationBar setTintColor:barColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configureTestingData];
}
//
//-(void)setupLeftMenuButton{
//    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
//    leftDrawerButton.tintColor = [UIColor blackColor];
//    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
//}
//
//-(void)leftDrawerButtonPress:(id)sender{
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//}
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
        [DONUser loginTestUserWithCompletion:^(DONUser *user, NSError *error) {
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
- (IBAction)showOtherUserProfileTapped:(id)sender {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Jon" bundle:nil];
    DONViewOtherUserProfileViewController *otherUserProfileVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"viewOtherUserProfile"];
    [DONUser testUserWithCompletion:^(DONUser *user, NSError *error) {
        otherUserProfileVC.user = user;
        [self.navigationController pushViewController:otherUserProfileVC animated:YES];
    }];
}

- (IBAction)viewItemTapped:(id)sender {
    [DONItem fetchItemWithItemId:@"3UpAq8hj0Q" withCompletion:^(DONItem *item, NSError *error) {
        DONItemViewController *vc = [[DONItemViewController alloc] initWithItem:item];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}



@end
