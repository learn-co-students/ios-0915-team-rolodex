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



@interface DONAddItemViewController : UIViewController
@property (nonatomic, strong) UIColor *onTintColor;
//image shown to user for item
@property (weak, nonatomic) IBOutlet UIImageView *addPhotoPlaceholder;

@property (weak, nonatomic) UISwitch *useCurrentLocationSwitch;

@property (weak,nonatomic) IBOutlet UIImageView *selectedImageView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

//VC properties
@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemDescriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *pickupInstructionsTextField;



//item properties
@property (strong, nonatomic) NSNumber *views;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSString *pickupInstructions;
@property (strong, nonatomic) DONUser *listedBy;
@property (strong, nonatomic) PFGeoPoint *locationPF;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) UIImage *itemImage;
@property (strong, nonatomic) PFFile *itemImagePF;
@property (strong, nonatomic) NSString *category;


-(IBAction)saveButtonTapped:(id)sender;




@end
