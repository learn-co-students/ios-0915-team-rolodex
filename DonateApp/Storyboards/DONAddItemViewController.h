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

@interface DONAddItemViewController : UIViewController


//layout constraints for keybaord



@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic,strong)  UIView *containerView;
//@property (strong, nonatomic) UIImage *background;
//@property (strong, nonatomic)  UIImageView *backGroundView;
@property (strong,nonatomic)  UIImageView *selectedImageView;


@property (strong, nonatomic) UILabel *useCurrentLocationLabel;
@property (strong, nonatomic) UISwitch *useCurrentLocationSwitch;
@property (nonatomic, strong) UIColor *onTintColor;
@property (strong, nonatomic)  UIButton *saveButton;

//scrollview ish
@property (strong, nonatomic)  UIScrollView *categorySelect;
//@property (strong, nonatomic)  UIView *categoryContentView;
@property (strong, nonatomic)  UIStackView *categoryStackView;
@property (strong, nonatomic)  UIImageView *firstTag;
@property (strong, nonatomic)  UIImageView *secondTag;
@property (strong, nonatomic)  UIImageView *thirdTag;
@property (strong, nonatomic)  UIImageView *fourthTag;
@property (strong, nonatomic)  UIImageView *fifthTag;
@property (strong, nonatomic)  UIImageView *sixthTag;
@property (strong, nonatomic)  UIImageView *seventhTag;
@property (strong, nonatomic)  UIImageView *eigthTag;
@property (strong, nonatomic)  UIImageView *ninthTag;
@property (strong, nonatomic)  UIImageView *tenthTag;
@property (strong, nonatomic)  UIImageView *eleventhTag;

@property (strong, nonatomic)  UITextField *itemNameTextField;
@property (strong, nonatomic)  UITextField *itemDescriptionTextField;
@property (strong, nonatomic)  UITextField *pickupInstructionsTextField;
@property (strong, nonatomic)  UITextField *categoriesTextField;



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
@property (strong, nonatomic) NSString *categoryString;
@property (strong, nonatomic) NSMutableArray *categories;

//@property (strong, nonatomic) DONCategory *




-(void)saveButtonTapped;




@end
