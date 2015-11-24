//
//  DONItemViewController.m
//  DonateApp
//
//  Created by Jon on 11/23/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONItemViewController.h"
#import "DONViewItemUserProfileView.h"
#import "DONItemStatsView.h"
#import "DONViewItemButton.h"
#import "DONActivity.h"
#import "DONViewOtherUserProfileViewController.h"

#import "Masonry.h"
#define MAS_SHORTHAND

@interface DONItemViewController ()
@property (nonatomic, strong) PFImageView *itemImageView;
@property (nonatomic, strong) DONViewItemUserProfileView *userProfileView;
@property (nonatomic, strong) DONItemStatsView *itemStatsView;
@property (nonatomic, strong) DONViewItemButton *claimButton;
@property (nonatomic, strong) DONViewItemButton *numberOfClaimsView;
@property (nonatomic, strong) DONViewItemButton *numberOfVerificationsView;
@property (nonatomic, strong) DONViewItemButton *verifyButton;
@property (nonatomic, strong) UIView *itemDescriptionView;
@property (nonatomic, strong) UIView *itemMapView;
@property (nonatomic, strong) DONViewItemButton *reportErrorButton;
@end

@implementation DONItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Viewing Item";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.itemImageView = [[PFImageView alloc] init];
    self.userProfileView = [[DONViewItemUserProfileView alloc] init];
    self.itemStatsView = [[DONItemStatsView alloc] init];
    
    self.claimButton = [[DONViewItemButton alloc] initWithEnabledText:@"CLAIM" disabledText:@"CLAIMED" enabled:NO color:DONViewItemButtonTypeBlue];
    
    self.verifyButton = [[DONViewItemButton alloc] initWithEnabledText:@"VERIFY" disabledText:@"VERIFIED" enabled:NO color:DONViewItemButtonTypeGreen];
    
    self.numberOfClaimsView = [[DONViewItemButton alloc] initWithText:@"0" color:DONViewItemButtonTypeGray];
    self.numberOfVerificationsView = [[DONViewItemButton alloc] initWithText:@"0" color:DONViewItemButtonTypeGray];
    self.itemDescriptionView = [[UIView alloc] init];
    self.itemMapView = [[UIView alloc] init];
    self.reportErrorButton = [[DONViewItemButton alloc] initWithText:@"REPORT ERROR" color:DONViewItemButtonTypeRed];
    
    [self.view addSubview:self.itemImageView];
    [self.view addSubview:self.userProfileView];
    [self.view addSubview:self.itemStatsView];
    [self.view addSubview:self.claimButton];
    [self.view addSubview:self.verifyButton];
    [self.view addSubview:self.numberOfClaimsView];
    [self.view addSubview:self.numberOfVerificationsView];
    [self.view addSubview:self.itemDescriptionView];
    [self.view addSubview:self.itemMapView];
    [self.view addSubview:self.reportErrorButton];
    
    self.itemImageView.file = self.item.imageFile;
    [self.itemImageView loadInBackground];
    self.itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.userProfileView.user = self.item.listedBy;
    
    self.itemDescriptionView.backgroundColor = [UIColor orangeColor];
    self.itemMapView.backgroundColor = [UIColor grayColor];
    
    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self.view);
        make.height.equalTo(@300);
    }];
    
    [self.userProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.bottom.equalTo(self.itemImageView.mas_bottom).offset(-20);
        make.height.equalTo(@40);
    }];
    
    [self.itemStatsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemImageView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.width.equalTo(@100);
    }];
    
    [self.claimButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.itemStatsView.mas_right).offset(20);
        make.top.equalTo(self.itemImageView.mas_bottom).offset(5);
    }];
    
    [self.numberOfClaimsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.claimButton.mas_right).offset(1);
        make.top.equalTo(self.claimButton);
    }];
    
    [self.verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberOfClaimsView.mas_right).offset(5);
        make.top.equalTo(self.itemImageView.mas_bottom).offset(5);
    }];
    
    [self.numberOfVerificationsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verifyButton.mas_right).offset(1);
        make.top.equalTo(self.claimButton);
    }];
    
    [self.itemDescriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.claimButton.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.equalTo(@150);
    }];
    
    [self.itemMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemDescriptionView.mas_bottom).offset(5);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@200);
    }];
    
    [self.reportErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemMapView.mas_bottom).offset(5);
        make.height.equalTo(self.claimButton);
        make.centerX.equalTo(self.view);
    }];
    
    [self updateItemData];
    
    UITapGestureRecognizer *tappedUserProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userProfileTapped)];
    [self.userProfileView addGestureRecognizer:tappedUserProfile];
    self.userProfileView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tappedClaimButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(claimButtonTapped)];
    [self.claimButton addGestureRecognizer:tappedClaimButton];
    
    UITapGestureRecognizer *tappedVerifyButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(verifyButtonTapped)];
    [self.verifyButton addGestureRecognizer:tappedVerifyButton];
    
}

-(void)userProfileTapped
{
    UIStoryboard *userProfileStoryboard = [UIStoryboard storyboardWithName:@"Jon" bundle:[NSBundle mainBundle]];
    DONViewOtherUserProfileViewController *otherUserProfileVC = [userProfileStoryboard instantiateViewControllerWithIdentifier:@"viewOtherUserProfile"];
    otherUserProfileVC.user = self.item.listedBy;
    [self.navigationController pushViewController:otherUserProfileVC animated:YES];
}

-(void)claimButtonTapped
{
   self.claimButton.enabled = NO;
    if (self.claimButton.currentState == YES) {
        [DONActivity addActivityType:kActivityTypeClaim toItem:self.item fromUser:[DONUser currentUser] toUser:self.item.listedBy withCompletion:^(BOOL success) {
            [self updateItemData];
            self.claimButton.enabled = YES;
        }];
    } else {
        [DONActivity removeActivityType:kActivityTypeClaim forUser:[DONUser currentUser] onItem:self.item withCompletion:^(BOOL success) {
            [self updateItemData];
            self.claimButton.enabled = YES;
        }];
    }
}

-(void)verifyButtonTapped
{
    self.verifyButton.enabled = NO;
    if (self.verifyButton.currentState == YES) {
        [DONActivity addActivityType:kActivityTypeVerification toItem:self.item fromUser:[DONUser currentUser] toUser:self.item.listedBy withCompletion:^(BOOL success) {
            [self updateItemData];
            self.verifyButton.enabled = YES;
        }];
    } else {
        [DONActivity removeActivityType:kActivityTypeVerification forUser:[DONUser currentUser] onItem:self.item withCompletion:^(BOOL success) {
            [self updateItemData];
            self.verifyButton.enabled = YES;
        }];
    }
}


-(void)updateItemData
{
    [DONActivity activitiesForItem:self.item withCompletion:^(NSArray *activities) {

        NSInteger numberOfClaims = [DONActivity numberOfActivities:kActivityTypeClaim inItemActivities:activities];
        NSInteger numberOfFavorites = [DONActivity numberOfActivities:kActivityTypeFavorite inItemActivities:activities];
        NSInteger numberOfVerifications = [DONActivity numberOfActivities:kActivityTypeVerification inItemActivities:activities];
        NSInteger numberOfViews = [self.item.views intValue];
        
        self.itemStatsView.numberOfFavorites = [NSString stringWithFormat:@"%lu", numberOfFavorites];
        self.itemStatsView.numberOfViews = [NSString stringWithFormat:@"%lu", numberOfViews];
        self.numberOfVerificationsView.text = [NSString stringWithFormat:@"%lu", numberOfVerifications];
        self.numberOfClaimsView.text = [NSString stringWithFormat:@"%lu", numberOfClaims];
        
        BOOL userHasClaimedItem = [DONActivity activityExists:kActivityTypeClaim forUser:[DONUser currentUser] inItemActivities:activities];
        
        BOOL userHasVerifiedItem = [DONActivity activityExists:kActivityTypeVerification forUser:[DONUser currentUser] inItemActivities:activities];
        
        self.claimButton.currentState = !userHasClaimedItem;
        self.verifyButton.currentState = !userHasVerifiedItem;
   
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
