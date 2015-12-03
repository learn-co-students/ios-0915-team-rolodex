//
//  DONUserProfileViewController.m
//  DonateApp
//
//  Created by Jon on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONUserProfileViewController.h"
#import "DONUser.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Masonry/Masonry.h>
#define MAS_SHORTHAND

#import "DONUserSettingsTableViewController.h"

@interface DONUserProfileViewController ()
@property (nonatomic, strong) DONUser *currentUser;
@property (nonatomic, strong) PFImageView *userPhotoImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *donatedItemsLabel;
@property (nonatomic, strong) UILabel *donatedItemsCaptionLabel;
@end

@implementation DONUserProfileViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.currentUser = [DONUser currentUser];
    NSLog(@"Current user %@", self.currentUser);
    
    self.navigationItem.title = @"My Profile";

    // Remove "Back" nav bar text next to back arrow
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
    
    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    [settingsButton setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = settingsButton;

    [self setupViews];
    [self constrainViews];
    [self setupViewData];
    
}

-(void)showSettings
{
    [self performSegueWithIdentifier:@"showSettings" sender:self];
}

-(void)setupViews
{
    self.userPhotoImageView = [[PFImageView alloc] init];
    self.userNameLabel = [[UILabel alloc] init];
    self.donatedItemsLabel = [[UILabel alloc] init];
    self.donatedItemsCaptionLabel = [[UILabel alloc] init];
    
    [self.view addSubview:self.userPhotoImageView];
    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.donatedItemsLabel];
    [self.view addSubview:self.donatedItemsCaptionLabel];
}

-(void)constrainViews
{
    [self.userPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(60);
        make.centerX.equalTo(self.view);
        make.height.and.width.equalTo(@128);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userPhotoImageView.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
    }];
    
    [self.donatedItemsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(50);
        make.centerX.equalTo(self.view);
    }];
    
    [self.donatedItemsCaptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.donatedItemsLabel.mas_bottom);
        make.centerX.equalTo(self.view);
    }];
}

-(void)setupViewData
{
    self.userPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.userPhotoImageView.clipsToBounds = YES;
    self.userPhotoImageView.layer.borderWidth = 3.0f;
    self.userPhotoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.userPhotoImageView.file = self.currentUser.photoFile;
    [self.userPhotoImageView loadInBackground];
    
    self.userNameLabel.text = self.currentUser.username;
    self.userNameLabel.font = [UIFont systemFontOfSize:36];
    self.userNameLabel.textColor = [UIColor whiteColor];
    
    self.donatedItemsLabel.font = [UIFont systemFontOfSize:72];
    self.donatedItemsLabel.textColor = [UIColor whiteColor];

    [DONUser allItemsForCurrentUserWithCompletion:^(NSArray *items, BOOL success) {
        self.donatedItemsLabel.text = [NSString stringWithFormat:@"%lu", items.count];
    }];
    
    self.donatedItemsCaptionLabel.font = [UIFont systemFontOfSize:14];
    self.donatedItemsCaptionLabel.textColor = [UIColor whiteColor];
    self.donatedItemsCaptionLabel.text = @"total items donated";
}

-(void)viewDidLayoutSubviews
{
    // Round the corners
    CGFloat width = self.userPhotoImageView.frame.size.width;
    self.userPhotoImageView.layer.cornerRadius = width/2;
    
    // Background gradient
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(id)[UIColor colorWithRed:23.0f/255.0f green:43.0f/255.0f blue:156.0f/255.0f alpha:1].CGColor,
                     (id)[UIColor colorWithRed:11.0f/255.0f green:185.0f/255.0f blue:219.0f/255.0f alpha:1].CGColor];
    layer.frame = CGRectMake(self.view.frame.origin.x,
                             self.view.frame.origin.y + self.navigationController.navigationBar.frame.size.height,
                             self.view.frame.size.width,
                             self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    [self.view.layer insertSublayer:layer atIndex:0];
}
@end
