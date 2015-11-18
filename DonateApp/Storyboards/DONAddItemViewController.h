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


@interface DONAddItemViewController : UIViewController

//image shown to user for item
@property (weak,nonatomic)IBOutlet UIImageView *selectedImageView;

//
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) DONUser *listedBy;
@property (strong, nonatomic) CLLocation *locationCL;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) UIImage *itemImage;
@property (strong, nonatomic) UIImage *itemThumbnailImage;


//-(void)
@end
