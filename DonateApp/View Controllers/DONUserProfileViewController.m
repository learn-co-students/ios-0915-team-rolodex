//
//  DONUserProfileViewController.m
//  DonateApp
//
//  Created by Jon on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONUserProfileViewController.h"
#import "DONUser.h"
#import "DONProfileItemCollectionViewController.h"
#import "DONUserProfileItemCountView.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Masonry/Masonry.h>
#import "DONActivity.h"
#define MAS_SHORTHAND

#import "DONUserSettingsTableViewController.h"

@interface DONUserProfileViewController ()
@property (nonatomic, strong) DONUser *currentUser;
@property (nonatomic, strong) PFImageView *userPhotoImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIStackView *itemCountStackView;
@property (nonatomic, strong) DONUserProfileItemCountView *donatedItemsView;
@property (nonatomic, strong) DONUserProfileItemCountView *claimedItemsView;
@property (nonatomic, strong) DONUserProfileItemCountView *favoritedItemsView;
@property (nonatomic, strong) NSArray *userProfileItemCountViews;
@property (nonatomic, strong) UIView *itemViewSection;

@property (nonatomic, strong) DONProfileItemCollectionViewController *collectionViewController;
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
    [self setupItemCollectionView];
    [self setupGestures];
}

-(void)showSettings
{
    [self performSegueWithIdentifier:@"showSettings" sender:self];
}

-(void)setupViews
{
    self.userPhotoImageView = [[PFImageView alloc] init];
    self.userNameLabel = [[UILabel alloc] init];
    self.itemCountStackView = [[UIStackView alloc] init];
    self.donatedItemsView = [[DONUserProfileItemCountView alloc] initWithCaption:@"donated"];
    self.claimedItemsView = [[DONUserProfileItemCountView alloc] initWithCaption:@"claimed"];
    self.favoritedItemsView = [[DONUserProfileItemCountView alloc] initWithCaption:@"favorited"];
    self.userProfileItemCountViews = @[self.donatedItemsView,self.claimedItemsView,self.favoritedItemsView];
    
    self.itemViewSection = [[UIView alloc] init];
    
    [self.view addSubview:self.userPhotoImageView];
    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.itemCountStackView];
    [self.itemCountStackView addArrangedSubview:self.donatedItemsView];
    [self.itemCountStackView addArrangedSubview:self.favoritedItemsView];
    [self.itemCountStackView addArrangedSubview:self.claimedItemsView];
    [self.view addSubview:self.itemViewSection];
}

-(void)constrainViews
{
    [self.userPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(40);
        make.centerX.equalTo(self.view);
        make.height.and.width.equalTo(@96);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userPhotoImageView.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
    }];
    
    [self.itemCountStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(30);
    }];
    
    for (UIView *view in _itemCountStackView.arrangedSubviews) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
            
        }];
    }
    
    [self.itemViewSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.itemCountStackView.mas_bottom).offset(10);
    }];
}


-(void)setupViewData
{
    self.userPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.userPhotoImageView.clipsToBounds = YES;
    self.userPhotoImageView.layer.borderWidth = 1.0f;
    self.userPhotoImageView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.userPhotoImageView.file = self.currentUser.photo;
    [self.userPhotoImageView loadInBackground];
    
    UIColor *textColor = [UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1];
    
    self.userNameLabel.text = self.currentUser.username;
    self.userNameLabel.font = [UIFont systemFontOfSize:28];
    self.userNameLabel.textColor = textColor;
   
    self.itemCountStackView.alignment = UIStackViewAlignmentCenter;
    self.itemCountStackView.axis = UILayoutConstraintAxisHorizontal;
    self.itemCountStackView.distribution = UIStackViewDistributionFillEqually;
    self.itemCountStackView.translatesAutoresizingMaskIntoConstraints = NO;

    [DONUser allItemsForCurrentUserWithCompletion:^(NSArray *items, BOOL success) {
        self.donatedItemsView.amount = items.count;
    }];
    
    [DONActivity activitiesForUser:[DONUser currentUser] withCompletion:^(NSArray *activities) {
        self.favoritedItemsView.amount = [DONActivity numberOfActivities:kActivityTypeFavorite inItemActivities:activities];
        self.claimedItemsView.amount = [DONActivity numberOfActivities:kActivityTypeClaim inItemActivities:activities];
    }];
}

-(void)setupItemCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionViewController = [[DONProfileItemCollectionViewController alloc] initWithCollectionViewLayout:layout];

    [self addChildViewController:self.collectionViewController];
    
    [self.itemViewSection addSubview:self.collectionViewController.collectionView];

    [self.collectionViewController.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.itemViewSection);
    }];
    
    [self.collectionViewController didMoveToParentViewController:self];
}

-(void)setupGestures
{
    UITapGestureRecognizer *tapDonatedItems = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedDonatedItems)];
    UITapGestureRecognizer *tapFavoriteItems = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedFavoriteItems)];
    UITapGestureRecognizer *tapClaimedItems = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedClaimedItems)];
    [self.donatedItemsView addGestureRecognizer:tapDonatedItems];
    [self.favoritedItemsView addGestureRecognizer:tapFavoriteItems];
    [self.claimedItemsView addGestureRecognizer:tapClaimedItems];
    
}

-(void)tappedDonatedItems
{
    [DONUser allItemsForCurrentUserWithCompletion:^(NSArray *items, BOOL success) {
        self.collectionViewController.items = items;
    }];
    
    [self swapAlpha:self.donatedItemsView];
}

-(void)tappedFavoriteItems
{
    [DONActivity activitiesForUser:[DONUser currentUser] activityType:kActivityTypeFavorite withCompletion:^(NSArray *activities) {
        NSMutableArray *items = [@[] mutableCopy];
        for (DONActivity *activity in activities) {
            [items addObject:activity.item];
        }
        self.collectionViewController.items = items;
    }];
    [self swapAlpha:self.favoritedItemsView];
}

-(void)tappedClaimedItems
{
    [DONActivity activitiesForUser:[DONUser currentUser] activityType:kActivityTypeClaim withCompletion:^(NSArray *activities) {
        NSMutableArray *items = [@[] mutableCopy];
        for (DONActivity *activity in activities) {
            [items addObject:activity.item];
        }
        self.collectionViewController.items = items;
    }];
    [self swapAlpha:self.claimedItemsView];
}

-(void)swapAlpha:(DONUserProfileItemCountView *)view
{
    for (DONUserProfileItemCountView *view in self.userProfileItemCountViews) {
        view.alpha = 0.74f;
        view.textColor = [UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1];
    }
    
    if (view.alpha == 1.0f) {
        view.alpha = 0.74f;
        view.textColor = [UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1];
    } else {
        view.alpha = 1.0f;
        view.textColor = [UIColor blackColor];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Round the corners
    CGFloat width = self.userPhotoImageView.frame.size.width;
    self.userPhotoImageView.layer.cornerRadius = width/2;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.borderColor = [UIColor lightGrayColor].CGColor;
    topBorder.borderWidth = 1;
    topBorder.frame = CGRectMake(-1, -1, CGRectGetWidth(self.itemViewSection.frame)+2, 1);
    topBorder.shadowColor = [UIColor blackColor].CGColor;
    topBorder.shadowRadius = 1.5f;
    topBorder.shadowOpacity = 0.5f;
    topBorder.shadowOffset = CGSizeMake(0, 0);
    [self.itemViewSection.layer addSublayer:topBorder];
    self.itemViewSection.clipsToBounds = YES;

}
@end
