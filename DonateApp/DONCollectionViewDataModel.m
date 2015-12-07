//
//  DONSelectedCategoryViewModel.m
//  DonateApp
//
//  Created by Jon on 12/7/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONCollectionViewDataModel.h"
#import "DONItem.h"
#import <MBProgressHUD.h>

@interface DONCollectionViewDataModel ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray *selectedCategories;
@property (nonatomic, strong) NSArray *allCategories;
@end

@implementation DONCollectionViewDataModel
-(instancetype)init
{
    self = [super init];
    if (!self) return nil;
    self.selectedCategories = [[NSMutableArray alloc] init];
    return self;
}

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)loadAllItems
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self postWillUpdateItemsNotification];
        [DONCategory allCategoriesWithCompletion:^(BOOL success, NSArray *categories){
            if (success){
                for (DONCategory *category in categories) {
                    category.selected = NO;
                }
                self.allCategories = categories;
                
                [self postCategoriesUpdateNotification];
                [DONItem allItemsWithCompletion:^(BOOL success, NSArray *allItems) {
                    self.items = allItems;
                    [self postDidUpdateItemsNotification];
                }];
            }
        }];
    });
}
-(void)loadItemsWithCategories:(NSArray *)categories
{
    [self postWillUpdateItemsNotification];
    
    if (categories.count == 0) {
        categories = self.allCategories;
    }
    
    [DONItem itemsWithCategories:categories withCompletion:^(BOOL success, NSArray *items) {
        self.items = items;
        [self postDidUpdateItemsNotification];
    }];
}

-(void)postCategoriesUpdateNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateCategoriesNotification object:nil];
    });
    NSLog(@"Posted Did Change Categories Notification");
}

-(void)postWillUpdateItemsNotification
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewToUpdateHUD animated:YES];
    hud.labelText = @"Loading";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kWillUpdateItemsNotification object:nil];
    });
    NSLog(@"Posted Will Change Items Notification");
}

-(void)postDidUpdateItemsNotification
{
    [MBProgressHUD hideHUDForView:self.viewToUpdateHUD animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateItemsNotification object:nil];
    });
    NSLog(@"Posted Did Change Items Notification");
}

-(void)toggleCategory:(DONCategory *)category
{
    //find category in selected categories
    BOOL currentlySelected = [self.selectedCategories containsObject:category];
    NSUInteger categoriesSelected = self.selectedCategories.count;
    
    if (currentlySelected) {
        [self.selectedCategories removeObject:category];
        category.selected = NO;
        [self postCategoriesUpdateNotification];
        [self loadItemsWithCategories:self.selectedCategories];
        
        return;
    }
    
    if (categoriesSelected >= 3) {
        return;
    }
    
    [self.selectedCategories addObject:category];
    category.selected = YES;
    [self postCategoriesUpdateNotification];
    [self loadItemsWithCategories:self.selectedCategories];
    
    return;
}

@end
