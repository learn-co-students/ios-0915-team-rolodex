//
//  DONSelectedCategoryViewModel.h
//  DonateApp
//
//  Created by Jon on 12/7/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DONCategory.h"

/**
 These notifications handle the item updating lifecycle
*/
static NSString *const kWillUpdateItemsNotification = @"DONWillUpdateItemsNotification";
static NSString *const kDidUpdateItemsNotification = @"DONDidUpdateItemsNotification";
static NSString *const kDidUpdateCategoriesNotification = @"DONDidUpdateCategoriesNotification";

@interface DONCollectionViewDataModel : NSObject
@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, strong, readonly) NSArray *allCategories;
@property (nonatomic, strong) UIView *viewToUpdateHUD;

+(instancetype)sharedInstance;
-(void)loadAllItems;
-(void)toggleCategory:(DONCategory *)category;

@end

