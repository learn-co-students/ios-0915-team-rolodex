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
#import "DONViewOtherUserProfileViewController.h"
#import "DONActivity.h"
#import "SCLAlertView.h"
#import "DONViewItemDescriptionView.h"
#import "DONViewItemMapView.h"
#import "Masonry.h"
#define MAS_SHORTHAND

// make default loading state grey out and no actions then add actions and color once loaded

@interface DONItemViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) DONItem *item;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *favoriteButton;
@property (nonatomic, strong) PFImageView *itemImageView;
@property (nonatomic, strong) DONViewItemUserProfileView *userProfileView;
@property (nonatomic, strong) DONItemStatsView *itemStatsView;
@property (nonatomic, strong) DONViewItemButton *claimButton;
@property (nonatomic, strong) DONViewItemButton *numberOfClaimsView;
@property (nonatomic, strong) DONViewItemButton *numberOfVerificationsView;
@property (nonatomic, strong) DONViewItemButton *verifyButton;
@property (nonatomic, strong) DONViewItemDescriptionView *itemDescriptionView;
@property (nonatomic, strong) DONViewItemMapView *mapView;
@property (nonatomic, strong) DONViewItemButton *reportErrorButton;
@property (nonatomic, assign) BOOL isItemOwner;
@end

@implementation DONItemViewController
-(instancetype)initWithItem:(DONItem *)item
{
    self = [super init];
    if (!self) return nil;
    self.item = item;
    
    NSString *itemOwnerID = self.item.listedBy.objectId;
    NSString *currentUserID = [DONUser currentUser].objectId;
    self.isItemOwner = [itemOwnerID isEqualToString:currentUserID];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self instantiateSubviews];
    [self setupViewHierarchy];
    [self setupConstraints];

    self.itemImageView.file = self.item.imageFile;
    [self.itemImageView loadInBackground];
    self.itemImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.itemImageView.clipsToBounds = YES;
    self.userProfileView.user = self.item.listedBy;
   
    [self updateItemData];
    [self setupUIGestures];
    [self incrementItemViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupNavigationBar
{
    self.navigationItem.title = @"Viewing Item";
    
    // Remove "Back" nav bar text next to back arrow
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    if (!self.isItemOwner && [DONUser currentUser]) {
        [self setupRightNavigationBarItem];
    }
}

-(void)setupRightNavigationBarItem
{
    
    // Set right bar favorite button
    UIImage *favImgOutlined = [UIImage imageNamed:@"favorite-outline"];
    favImgOutlined = [favImgOutlined imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favoriteButton setImage:favImgOutlined forState:UIControlStateNormal];
    
    self.favoriteButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.favoriteButton.imageView.tintColor = [UIColor grayColor];
    self.favoriteButton.frame = CGRectMake(0,0,22,22);
    
    [self.favoriteButton addTarget:self action:@selector(favoriteTapped) forControlEvents:UIControlEventTouchUpInside];
    self.favoriteButton.userInteractionEnabled = NO;
    
    UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc] initWithCustomView:self.favoriteButton];
    self.navigationItem.rightBarButtonItem = favoriteButton;
}

#pragma mark View setup
-(void)instantiateSubviews
{
    
    self.scrollView = [[UIScrollView alloc] init];
    self.containerView = [[UIView alloc] init];
    
    self.itemImageView = [[PFImageView alloc] init];
    self.userProfileView = [[DONViewItemUserProfileView alloc] init];
    self.itemStatsView = [[DONItemStatsView alloc] init];
    
    self.claimButton = [[DONViewItemButton alloc] initWithDefaultText:@"CLAIM" toggledText:@"CLAIMED" buttonState:DONViewItemButtonStateDisabled color:DONViewItemButtonTypeBlue];
    
    self.verifyButton = [[DONViewItemButton alloc] initWithDefaultText:@"VERIFY" toggledText:@"VERIFIED" buttonState:DONViewItemButtonStateDisabled color:DONViewItemButtonTypeGreen];
    
    self.numberOfClaimsView = [[DONViewItemButton alloc] initWithText:@"0" color:DONViewItemButtonTypeGray];
    self.numberOfVerificationsView = [[DONViewItemButton alloc] initWithText:@"0" color:DONViewItemButtonTypeGray];
    
    self.itemDescriptionView = [[DONViewItemDescriptionView alloc] initWithItem:self.item];
    
    self.mapView = [[DONViewItemMapView alloc] initWithLocation:self.item.location];
    
    self.reportErrorButton = [[DONViewItemButton alloc] initWithText:@"REPORT ERROR" color:DONViewItemButtonTypeRed];
}

-(void)setupViewHierarchy
{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    
    [self.containerView addSubview:self.itemImageView];
    [self.containerView addSubview:self.userProfileView];
    [self.containerView addSubview:self.itemStatsView];
    
    if (!self.isItemOwner && [DONUser currentUser]) {
        [self.containerView addSubview:self.claimButton];
        [self.containerView addSubview:self.verifyButton];
        [self.containerView addSubview:self.numberOfClaimsView];
        [self.containerView addSubview:self.numberOfVerificationsView];
    }
    
    [self.containerView addSubview:self.itemDescriptionView];
    [self.containerView addSubview:self.mapView];
    [self.containerView addSubview:self.reportErrorButton];
}

-(void)setupConstraints
{
    NSInteger topPadding = 15;
    NSInteger sidePadding = 15;
    // Scroll view and scroll view container
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.top.equalTo(self.itemImageView);
        make.bottom.equalTo(self.reportErrorButton);
        make.width.equalTo(self.view);
    }];
    
    // Item data views
    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self.containerView);
        make.height.equalTo(@300);
    }];
    
    [self.userProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(sidePadding);
        make.bottom.equalTo(self.itemImageView.mas_bottom).offset(-sidePadding);
        make.height.equalTo(@40);
    }];
    
    if (!self.isItemOwner && [DONUser currentUser] ) {
        [self.claimButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView).offset(sidePadding);
            make.top.equalTo(self.itemImageView.mas_bottom).offset(topPadding);
        }];
        
        [self.numberOfClaimsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.claimButton.mas_right).offset(1);
            make.top.equalTo(self.claimButton);
        }];
        
        [self.verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.numberOfClaimsView.mas_right).offset(5);
            make.top.equalTo(self.itemImageView.mas_bottom).offset(topPadding);
        }];
        
        [self.numberOfVerificationsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.verifyButton.mas_right).offset(1);
            make.top.equalTo(self.claimButton);
        }];
    }
    
    [self.itemStatsView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!self.isItemOwner && [DONUser currentUser]) {
            make.top.equalTo(self.claimButton.mas_bottom).offset(5);
        } else {
            make.top.equalTo(self.itemImageView.mas_bottom).offset(topPadding);
        }
        make.left.equalTo(self.containerView).offset(sidePadding);
    }];
    
    [self.itemDescriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemStatsView.mas_bottom).offset(5);
        make.left.equalTo(self.containerView).offset(sidePadding);
        make.right.equalTo(self.containerView).offset(-sidePadding);
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemDescriptionView.mas_bottom).offset(topPadding);
        make.left.and.right.equalTo(self.containerView);
        make.height.equalTo(@200);
    }];
    
    [self.reportErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom).offset(topPadding);
        make.height.equalTo(@35);
        make.centerX.equalTo(self.containerView);
    }];
    
}

#pragma mark UI Gestures
-(void)setupUIGestures
{
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
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor =  [UIColor colorWithRed:33.0/255.0 green:60.0/255.0 blue:192.0/255.0 alpha:1];
    alert.showAnimationType = FadeIn;
    alert.hideAnimationType = FadeOut;
    
   self.claimButton.enabled = NO;
    if (self.claimButton.buttonState == DONViewItemButtonStateDefault) {
        [DONActivity addActivityType:kActivityTypeClaim toItem:self.item fromUser:[DONUser currentUser] toUser:self.item.listedBy withCompletion:^(BOOL success) {
            [self updateItemData];
            self.claimButton.enabled = YES;
            
            [alert showSuccess:self title:@"Claimed!" subTitle:@"Congrats! You claimed this item." closeButtonTitle:@"OK" duration:2.0f];

        }];
    } else {
        [DONActivity removeActivityType:kActivityTypeClaim forUser:[DONUser currentUser] onItem:self.item withCompletion:^(BOOL success) {
            [self updateItemData];
            self.claimButton.enabled = YES;
            
            [alert showSuccess:self title:@"Unclaimed!" subTitle:@"Thanks for the update! You unclaimed this item." closeButtonTitle:@"OK" duration:2.0f];

        }];
    }
}

-(void)verifyButtonTapped
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor =  [UIColor colorWithRed:33.0/255.0 green:192.0/255.0 blue:100.0/255.0 alpha:1];
    alert.showAnimationType = FadeIn;
    alert.hideAnimationType = FadeOut;

    self.verifyButton.enabled = NO;
    if (self.verifyButton.buttonState == DONViewItemButtonStateDefault) {
        [DONActivity addActivityType:kActivityTypeVerification toItem:self.item fromUser:[DONUser currentUser] toUser:self.item.listedBy withCompletion:^(BOOL success) {
            [self updateItemData];
            self.verifyButton.enabled = YES;
            [alert showSuccess:self title:@"Verified!" subTitle:@"Thanks for being awesome. You verified this item." closeButtonTitle:@"OK" duration:2.0f];

        }];
    } else {
        [DONActivity removeActivityType:kActivityTypeVerification forUser:[DONUser currentUser] onItem:self.item withCompletion:^(BOOL success) {
            [self updateItemData];
            self.verifyButton.enabled = YES;
        }];
        [alert showSuccess:self title:@"Unverified!" subTitle:@"Thanks for the update. You unverified this item." closeButtonTitle:@"OK" duration:2.0f];
    }
}

-(void)favoriteTapped
{
    [DONActivity activitiesForItem:self.item withCompletion:^(NSArray *activities) {
        BOOL itemIsFavorite = [DONActivity activityExists:kActivityTypeFavorite forUser:[DONUser currentUser] inItemActivities:activities];
        
        if (itemIsFavorite) {
            [DONActivity removeActivityType:kActivityTypeFavorite forUser:[DONUser currentUser] onItem:self.item withCompletion:^(BOOL success) {
                [self updateItemData];
            }];
 
        } else {
            [DONActivity addActivityType:kActivityTypeFavorite toItem:self.item fromUser:[DONUser currentUser] toUser:self.item.listedBy withCompletion:^(BOOL success) {
                [self updateItemData];
            }];
        }
    }];

}

#pragma mark UI Update for Item
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
        
        BOOL userHasFavoritedItem = [DONActivity activityExists:kActivityTypeFavorite forUser:[DONUser currentUser] inItemActivities:activities];
        
        self.claimButton.buttonState = userHasClaimedItem ? DONViewItemButtonStateToggled : DONViewItemButtonStateDefault;
        self.verifyButton.buttonState = userHasVerifiedItem ? DONViewItemButtonStateToggled : DONViewItemButtonStateDefault;
        NSString *imgName = userHasFavoritedItem ? @"favorite-filled" : @"favorite-outline";
        UIImage *favImg = [UIImage imageNamed:imgName];
        [self.favoriteButton setImage:favImg forState:UIControlStateNormal];
        self.favoriteButton.userInteractionEnabled = YES;
    }];
}

-(void)incrementItemViews
{
    [self.item incrementViewForCurrentUserWithCompletion:^(BOOL success) {
        if (success) {
            NSLog(@"Incremented views");
        } else {
            NSLog(@"Views already incremented for %@", [DONUser currentUser].username);
        }
    }];
    
}

-(void)toggleFavoriteButtonImages
{
    UIImage *imageForNormalState = [self.favoriteButton imageForState:UIControlStateNormal];
    UIImage *imageForHighlightedState = [self.favoriteButton imageForState:UIControlStateHighlighted];
    [self.favoriteButton setImage:imageForNormalState forState:UIControlStateHighlighted];
    [self.favoriteButton setImage:imageForHighlightedState forState:UIControlStateNormal];

}

@end