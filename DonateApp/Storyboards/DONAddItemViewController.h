//
//  DONAddItemViewController.h
//  DonateApp
//
//  Created by synesthesia on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DONItem.h"
#import "DONUser.h"
#import "SCLAlertView.h"
#import "Masonry.h"
#import "SearchCell.h"
#import "DONCategory.h"

#import <CoreLocation/CoreLocation.h>
#import "DONCollectionViewDataModel.h"

@interface DONAddItemViewController : UIViewController



@property (strong, nonatomic) UIAlertController *alertController;
@property (strong, nonatomic) UIAlertAction *alertAction;

@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic,strong)  UIView *containerView;
@property (nonatomic,strong)  UIView *collectionContainerView;
//@property (strong, nonatomic) UIImage *background;
//@property (strong, nonatomic)  UIImageView *backGroundView;
@property (strong,nonatomic)  UIImageView *selectedImageView;
@property (strong, nonatomic) UILabel *useCurrentLocationLabel;
@property (strong, nonatomic) UISwitch *useCurrentLocationSwitch;
@property (strong, nonatomic)  UIButton *saveButton;

//category ish
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *categoriesImageViews;

@property (strong, nonatomic) NSString *firstTagString;
@property (strong, nonatomic)  UIImageView *firstTag;
@property (strong, nonatomic) NSString *secondTagString;
@property (strong, nonatomic)  UIImageView *secondTag;
@property (strong, nonatomic) NSString *thirdTagString;
@property (strong, nonatomic)  UIImageView *thirdTag;
@property (strong, nonatomic) NSString *fourthTagString;
@property (strong, nonatomic)  UIImageView *fourthTag;
@property (strong, nonatomic) NSString *fifthTagString;
@property (strong, nonatomic)  UIImageView *fifthTag;
@property (strong, nonatomic) NSString *sixthTagString;
@property (strong, nonatomic)  UIImageView *sixthTag;
@property (strong, nonatomic) NSString *seventhTagString;
@property (strong, nonatomic)  UIImageView *seventhTag;
@property (strong, nonatomic) NSString *eighthTagString;
@property (strong, nonatomic)  UIImageView *eighthTag;


@property (strong, nonatomic)  UITextField *itemNameTextField;
@property (strong, nonatomic)  UITextField *itemDescriptionTextField;
@property (strong, nonatomic)  UITextField *pickupInstructionsTextField;




//item properties
@property (strong, nonatomic) NSNumber *views;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSString *pickupInstructions;
@property (strong, nonatomic) DONUser *listedBy;
@property (strong, nonatomic) CLLocation *itemLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) PFGeoPoint *locationPF;
@property (strong, nonatomic) UIImage *itemImage;
@property (strong, nonatomic) PFFile *itemImagePF;
@property (strong, nonatomic) NSMutableArray *categoriesForItem;

//@property (strong, nonatomic) DONCategory *




-(void)saveButtonTapped;




@end
