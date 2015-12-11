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
#import "DONUserProfileViewController.h"
#import "DONActivity.h"
#import "SCLAlertView.h"
#import "DONViewItemDescriptionView.h"
#import "DONViewItemMapView.h"
#import "DONLocationController.h"
#import "Masonry.h"
#define MAS_SHORTHAND

// make default loading state grey out and no actions then add actions and color once loaded

@interface DONItemViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) DONItem *item;
@property (nonatomic, strong) DONLocationController *locationController;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *favoriteButton;
@property (nonatomic, strong) PFImageView *itemImageView;
@property (nonatomic, strong) DONViewItemUserProfileView *userProfileView;
@property (nonatomic, strong) DONItemStatsView *itemStatsView;

@property (nonatomic, strong) DONViewItemButton *claimButton;
@property (nonatomic, strong) DONViewItemButton *numberOfClaimsView;
@property (nonatomic, strong) DONViewItemButton *verifyButton;
@property (nonatomic, strong) DONViewItemButton *numberOfVerificationsView;
@property (nonatomic, strong) DONViewItemButton *reportErrorButton;
@property (nonatomic, strong) DONViewItemButton *numberOfErrorsView;
@property (nonatomic, strong) UIStackView *interactionsStackView;
@property (nonatomic, strong) UIView *claimContainer;
@property (nonatomic, strong) UIView *verifyContainer;
@property (nonatomic, strong) UIView *flagContainer;

@property (nonatomic, strong) DONViewItemDescriptionView *itemDescriptionView;
@property (nonatomic, strong) DONViewItemMapView *mapView;
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
    self.locationController = [DONLocationController sharedInstance];
    
    [self setupNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self instantiateSubviews];
    [self setupViewHierarchy];
    [self setupConstraints];

    self.scrollView.showsVerticalScrollIndicator = NO;
    self.itemImageView.file = self.item.imageFile;
    [self.itemImageView loadInBackground];
    self.itemImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.itemImageView.clipsToBounds = YES;
    self.userProfileView.user = self.item.listedBy;
   
    [self updateItemData];
    [self setupLocationBasedViews];
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
    
    if ([self userIsLoggedInAndNotItemOwner]) {
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

#pragma mark UI setup
-(void)instantiateSubviews
{
    
    self.scrollView = [[UIScrollView alloc] init];
    self.containerView = [[UIView alloc] init];
    
    self.itemImageView = [[PFImageView alloc] init];
    self.userProfileView = [[DONViewItemUserProfileView alloc] init];
    self.itemStatsView = [[DONItemStatsView alloc] init];
    
    self.claimButton = [[DONViewItemButton alloc] initWithDefaultText:@"CLAIM" toggledText:@"CLAIMED" toggledState:DONViewItemButtonStateNoData enabledState:DONViewItemButtonStateDisabled color:DONViewItemButtonTypeBlue];
    
    self.verifyButton = [[DONViewItemButton alloc] initWithDefaultText:@"VERIFY" toggledText:@"VERIFIED" toggledState:DONViewItemButtonStateNoData enabledState:DONViewItemButtonStateDisabled color:DONViewItemButtonTypeGreen];
    
    self.numberOfClaimsView = [[DONViewItemButton alloc] initWithText:@"0" color:DONViewItemButtonTypeGray];
    self.numberOfVerificationsView = [[DONViewItemButton alloc] initWithText:@"0" color:DONViewItemButtonTypeGray];
    
    self.itemDescriptionView = [[DONViewItemDescriptionView alloc] initWithItem:self.item];
    
    self.mapView = [[DONViewItemMapView alloc] initWithLocation:self.item.location];
    
    self.reportErrorButton = [[DONViewItemButton alloc] initWithText:@"FLAG" color:DONViewItemButtonTypeRed];
    
    self.numberOfErrorsView = [[DONViewItemButton alloc] initWithText:@"0" color:DONViewItemButtonTypeGray];
    
    self.interactionsStackView = [[UIStackView alloc] init];
    self.interactionsStackView.alignment = UIStackViewAlignmentFill;
    self.interactionsStackView.axis = UILayoutConstraintAxisHorizontal;
    self.interactionsStackView.distribution = UIStackViewDistributionEqualSpacing;
    
    self.claimContainer = [[UIView alloc] init];
    self.verifyContainer = [[UIView alloc] init];
    self.flagContainer = [[UIView alloc] init];
}

-(void)setupViewHierarchy
{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.interactionsStackView];
    
    [self.claimContainer addSubview:self.claimButton];
    [self.claimContainer addSubview:self.numberOfClaimsView];
    
    [self.verifyContainer addSubview:self.verifyButton];
    [self.verifyContainer addSubview:self.numberOfVerificationsView];
    
    [self.flagContainer addSubview:self.reportErrorButton];
    [self.flagContainer addSubview:self.numberOfErrorsView];
   
    [self.interactionsStackView addArrangedSubview:self.claimContainer];
    [self.interactionsStackView addArrangedSubview:self.verifyContainer];
    [self.interactionsStackView addArrangedSubview:self.flagContainer];
    
    [self.containerView addSubview:self.itemImageView];
    [self.containerView addSubview:self.userProfileView];
    [self.containerView addSubview:self.itemStatsView];

    [self.containerView addSubview:self.itemDescriptionView];
    [self.containerView addSubview:self.mapView];
}

-(void)setupConstraints
{
    NSInteger topPadding = 15;
    NSInteger sidePadding = 10;
    /// Scroll view and scroll view container
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.top.equalTo(self.itemImageView);
        make.bottom.equalTo(self.mapView).offset(topPadding);
        make.width.equalTo(self.view);
    }];
    
    // Item data views
    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self.containerView);
        make.height.equalTo(@300);
    }];
    
    [self.userProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(sidePadding);
        make.bottom.equalTo(self.itemImageView.mas_bottom).offset(-5);
        make.height.equalTo(@40);
    }];
    
    [self.itemStatsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.right.equalTo(self.containerView).offset(-sidePadding);
        make.centerY.equalTo(self.userProfileView);
    }];
    
    [self.numberOfClaimsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.claimButton.mas_right).offset(1);
        make.top.bottom.equalTo(self.claimButton);
    }];
    
    [self.claimContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.claimButton);
        make.right.equalTo(self.numberOfClaimsView);
    }];
   
    [self.numberOfVerificationsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verifyButton.mas_right).offset(1);
        make.top.bottom.equalTo(self.claimButton);
    }];
    
    [self.verifyContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.verifyButton);
        make.right.equalTo(self.numberOfVerificationsView);
    }];
    
    [self.numberOfErrorsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reportErrorButton.mas_right).offset(1);
        make.top.bottom.equalTo(self.claimButton);
    }];
    
    [self.flagContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.reportErrorButton);
        make.right.equalTo(self.numberOfErrorsView);
    }];
    
    [self.interactionsStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(sidePadding);
        make.right.equalTo(self.containerView).offset(-sidePadding);
        make.top.equalTo(self.itemImageView.mas_bottom).offset(topPadding);
        make.height.equalTo(@30);
    }];
   
    [self.itemDescriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.interactionsStackView.mas_bottom).offset(5);
        make.left.equalTo(self.containerView).offset(sidePadding);
        make.right.equalTo(self.containerView).offset(-sidePadding);
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemDescriptionView.mas_bottom).offset(topPadding);
        make.left.and.right.equalTo(self.containerView);
        make.height.equalTo(@200);
    }];
}

-(void)setupLocationBasedViews
{
    [self shouldEnableLocationBasedInteractionsWithCompletion:^(BOOL shouldDisplay) {
        if (shouldDisplay) {
            self.claimButton.enabledState = DONViewItemButtonStateEnabled;
            self.verifyButton.enabledState = DONViewItemButtonStateEnabled;
        }
    }];
}

#pragma mark UI Logic
-(BOOL)userIsLoggedInAndNotItemOwner
{
    return [DONUser currentUser] && !self.isItemOwner;
}

-(void)shouldEnableLocationBasedInteractionsWithCompletion:(void (^)(BOOL shouldDisplay))completion
{
    [self.locationController getCurrentUserLocationWithCompletion:^(CLLocation *location, BOOL success) {
       if (success) {
           CLLocation *userLocation = location;
           CLLocation *itemLocation = [DONLocationController locationForGeoPoint:self.item.location];
           CGFloat distance = [userLocation distanceFromLocation:itemLocation];
           
           // 1000 feet or 304.8 meters
           // Avg city block (street)   in NYC = 264 feet or 88 meters
           // Avg city block (ave)      in NYC = 750 feet or 246 meters
           // ~3.5 city blocks or ~1.25 avenues
           distance < 304.8 && [self userIsLoggedInAndNotItemOwner] ? completion(YES) : completion(NO);
           NSLog(@"User is %0.5fm from the item", distance);
       } else {
           NSLog(@"Some failure with CLLocationManager");
       }
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
    
    UITapGestureRecognizer *tappedMap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped)];
    [self.mapView addGestureRecognizer:tappedMap];
    
    UITapGestureRecognizer *tappedErrorButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorButtonTapped)];
    [self.reportErrorButton addGestureRecognizer:tappedErrorButton];
    
}

-(void)userProfileTapped
{
    UIStoryboard *userProfileStoryboard = [UIStoryboard storyboardWithName:@"Jon" bundle:[NSBundle mainBundle]];
    if (self.isItemOwner) {
        DONUserProfileViewController *userProfileVC = [userProfileStoryboard instantiateInitialViewController];
        [self.navigationController pushViewController:userProfileVC animated:YES];
    } else {
        DONViewOtherUserProfileViewController *otherUserProfileVC = [userProfileStoryboard instantiateViewControllerWithIdentifier:@"viewOtherUserProfile"];
        otherUserProfileVC.user = self.item.listedBy;
        [self.navigationController pushViewController:otherUserProfileVC animated:YES];
    }
}

-(void)claimButtonTapped
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = FadeIn;
    alert.hideAnimationType = FadeOut;
    
    self.claimButton.enabled = NO;

    if (self.claimButton.toggledState == DONViewItemButtonStateDefault && self.claimButton.enabledState == DONViewItemButtonStateEnabled) {
        alert.customViewColor =  [UIColor colorWithRed:33.0/255.0 green:60.0/255.0 blue:192.0/255.0 alpha:1];
        [DONActivity addActivityType:kActivityTypeClaim toItem:self.item fromUser:[DONUser currentUser] toUser:self.item.listedBy withCompletion:^(BOOL success) {
            [self updateItemData];
            self.claimButton.enabled = YES;
            
            [alert showSuccess:self title:@"Claimed!" subTitle:@"Congrats! You claimed this item." closeButtonTitle:@"OK" duration:2.0f];

        }];
    } else if (self.claimButton.toggledState == DONViewItemButtonStateToggled && self.claimButton.enabledState == DONViewItemButtonStateEnabled) {
        alert.customViewColor =  [UIColor colorWithRed:33.0/255.0 green:60.0/255.0 blue:192.0/255.0 alpha:1];
        [DONActivity removeActivityType:kActivityTypeClaim forUser:[DONUser currentUser] onItem:self.item withCompletion:^(BOOL success) {
            [self updateItemData];
            self.claimButton.enabled = YES;
            
            [alert showSuccess:self title:@"Unclaimed!" subTitle:@"Thanks for the update! You unclaimed this item." closeButtonTitle:@"OK" duration:2.0f];
        }];
    } else if (![self.locationController locationServicesEnabled]) {
        [alert showNotice:self title:@"Notice" subTitle:@"Please enable location services to utilize this feature." closeButtonTitle:@"OK" duration:0.0f];
    } else if (self.isItemOwner) {
        [alert showNotice:self title:@"Notice" subTitle:@"To prevent abuse, you cannot claim your own items." closeButtonTitle:@"OK" duration:0.0f];
    } else if (self.claimButton.enabledState == DONViewItemButtonStateDisabled) {
        [alert showNotice:self title:@"Notice" subTitle:@"To prevent abuse, you can only claim items when you are nearby." closeButtonTitle:@"OK" duration:0.0f];
    }
}

-(void)verifyButtonTapped
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = FadeIn;
    alert.hideAnimationType = FadeOut;

    self.verifyButton.enabled = NO;

    if (self.verifyButton.toggledState == DONViewItemButtonStateDefault && self.claimButton.enabledState == DONViewItemButtonStateEnabled) {
        alert.customViewColor =  [UIColor colorWithRed:33.0/255.0 green:192.0/255.0 blue:100.0/255.0 alpha:1];
        [DONActivity addActivityType:kActivityTypeVerification toItem:self.item fromUser:[DONUser currentUser] toUser:self.item.listedBy withCompletion:^(BOOL success) {
            [self updateItemData];
            self.verifyButton.enabled = YES;
            [alert showSuccess:self title:@"Verified!" subTitle:@"Thanks for being awesome. You verified this item." closeButtonTitle:@"OK" duration:2.0f];
        }];
    } else if (self.verifyButton.toggledState == DONViewItemButtonStateToggled && self.claimButton.enabledState == DONViewItemButtonStateEnabled) {
        alert.customViewColor =  [UIColor colorWithRed:33.0/255.0 green:192.0/255.0 blue:100.0/255.0 alpha:1];
        [DONActivity removeActivityType:kActivityTypeVerification forUser:[DONUser currentUser] onItem:self.item withCompletion:^(BOOL success) {
            [self updateItemData];
            self.verifyButton.enabled = YES;
        }];
        [alert showSuccess:self title:@"Unverified!" subTitle:@"Thanks for the update. You unverified this item." closeButtonTitle:@"OK" duration:2.0f];
    } else if (![self.locationController locationServicesEnabled]) {
        [alert showNotice:self title:@"Notice" subTitle:@"Please enable location services to utilize this feature." closeButtonTitle:@"OK" duration:0.0f];
    } else if (self.isItemOwner) {
        [alert showNotice:self title:@"Notice" subTitle:@"To prevent abuse, you cannot verify your own items." closeButtonTitle:@"OK" duration:0.0f];
    } else if (self.verifyButton.enabledState == DONViewItemButtonStateDisabled) {
        [alert showNotice:self title:@"Notice" subTitle:@"To prevent abuse, you can only verify items when you are nearby." closeButtonTitle:@"OK" duration:0.0f];
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

-(void)errorButtonTapped
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = FadeIn;
    alert.hideAnimationType = FadeOut;

    alert.customViewColor = [UIColor colorWithRed:192.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1];
    [alert showSuccess:self title:@"Error Reported!" subTitle:@"Thanks for being awesome. You reported an error with this listing.  We will get to the bottom of it." closeButtonTitle:@"OK" duration:0.0f];
   
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
        
        self.claimButton.toggledState = userHasClaimedItem ? DONViewItemButtonStateToggled : DONViewItemButtonStateDefault;
        self.verifyButton.toggledState = userHasVerifiedItem ? DONViewItemButtonStateToggled : DONViewItemButtonStateDefault;

        if (userHasClaimedItem) {
            self.claimButton.enabledState = DONViewItemButtonStateEnabled;
        }
        if (userHasVerifiedItem) {
            self.verifyButton.enabledState = DONViewItemButtonStateEnabled;
        }
        
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

-(NSString *)gmapAppURLWithLocation:(CLLocation *)location
{
    CGFloat latitude = location.coordinate.latitude;
    CGFloat longitude = location.coordinate.longitude;
    CGFloat zoom = self.mapView.mapView.camera.zoom;
    
    NSString *saddr = [NSString stringWithFormat:@"%0.5f,%0.5f", latitude, longitude];
    NSString *eaddr = [NSString stringWithFormat:@"%0.5f,%0.5f", self.item.location.latitude, self.item.location.longitude];
    NSString *googleMapsURLString = [NSString stringWithFormat:@"comgooglemaps://?saddr=%@&daddr=%@&z=%0.5f",saddr,eaddr, zoom];
    return googleMapsURLString;
}
                                                   
-(NSString *)amapAppURLWithLocation:(CLLocation *)location
{
    CGFloat latitude = location.coordinate.latitude;
    CGFloat longitude = location.coordinate.longitude;
    CGFloat zoom = self.mapView.mapView.camera.zoom;
    return [NSString stringWithFormat:@"http://maps.apple.com/?q=%0.6f,%0.6f&z=%0.6f", latitude, longitude, zoom];
}

-(void)mapTapped
{
    BOOL locationEnabled = [[DONLocationController sharedInstance] locationServicesEnabled];
    NSURL * googleCallBack = [ NSURL URLWithString: @"comgooglemaps://" ];
    __block BOOL googleMapsAvailable = [[UIApplication sharedApplication] canOpenURL: googleCallBack];
    
    
    if (locationEnabled) {
       [[DONLocationController sharedInstance] getCurrentUserLocationWithCompletion:^(CLLocation *location, BOOL success) {
           if (googleMapsAvailable) {
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self gmapAppURLWithLocation:location]]];
               NSLog(@"%@", [self gmapAppURLWithLocation:location]);
           } else {
               [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[self amapAppURLWithLocation:location]]];
               NSLog(@"%@",[self amapAppURLWithLocation:location]);
           }
       }];
    }
}

@end