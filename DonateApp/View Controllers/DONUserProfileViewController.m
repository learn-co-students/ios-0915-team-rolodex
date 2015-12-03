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
    self.donatedItemsLabel = [[UILabel alloc] init];
    self.donatedItemsCaptionLabel = [[UILabel alloc] init];
    self.itemViewSection = [[UIView alloc] init];
    
    [self.view addSubview:self.userPhotoImageView];
    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.donatedItemsLabel];
    [self.view addSubview:self.donatedItemsCaptionLabel];
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
    
    [self.donatedItemsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
    }];
    
    [self.donatedItemsCaptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.donatedItemsLabel.mas_bottom);
        make.centerX.equalTo(self.view);
    }];
    
    [self.itemViewSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.donatedItemsCaptionLabel.mas_bottom).offset(10);
    }];
}

-(void)setupViewData
{
    self.userPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.userPhotoImageView.clipsToBounds = YES;
    self.userPhotoImageView.layer.borderWidth = 1.0f;
    self.userPhotoImageView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.userPhotoImageView.file = self.currentUser.photoFile;
    [self.userPhotoImageView loadInBackground];
    
    UIColor *textColor = [UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1];
    
    self.userNameLabel.text = self.currentUser.username;
    self.userNameLabel.font = [UIFont systemFontOfSize:28];
    self.userNameLabel.textColor = textColor;
    
    self.donatedItemsLabel.font = [UIFont systemFontOfSize:36];
    self.donatedItemsLabel.textColor = textColor;

    [DONUser allItemsForCurrentUserWithCompletion:^(NSArray *items, BOOL success) {
        self.donatedItemsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)items.count];
    }];
    
    self.donatedItemsCaptionLabel.font = [UIFont systemFontOfSize:14];
    self.donatedItemsCaptionLabel.textColor = textColor;
    self.donatedItemsCaptionLabel.text = @"donated";
    
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
    [self.donatedItemsLabel addGestureRecognizer:tapDonatedItems];
    [self.donatedItemsCaptionLabel addGestureRecognizer:tapDonatedItems];
    self.donatedItemsLabel.userInteractionEnabled = YES;
    self.donatedItemsCaptionLabel.userInteractionEnabled = YES;
}

-(void)tappedDonatedItems
{
    [DONUser allItemsForCurrentUserWithCompletion:^(NSArray *items, BOOL success) {
        NSLog(@"%@",items);
        self.collectionViewController.items = items;
    }];
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
