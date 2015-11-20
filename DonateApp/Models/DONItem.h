//
//  DONItem.h
//  DonateApp
//
//  Created by Jon on 11/17/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "PFObject.h"
#import "PFSubclassing.h"
#import <ParseUI/ParseUI.h>
@class DONUser;

@class CLLocation;

@interface DONItem : PFObject <PFSubclassing>

//created automatically by parse
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

//created ourselves
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) DONUser *listedBy;
//@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) UIImage *itemImage;
@property (nonatomic, strong) UIImage *itemThumbnailImage;
@property (nonatomic, strong, readonly) PFFile *imageFile;

//@property (nonatomic, strong)

+(NSString *)parseClassName;

+(void)fetchItemWithItemId:(NSString *)ID withCompletion:(void (^)(DONItem *item, NSError *error))completion;

// Save the item and associate it with the current user
+(void)listItemForCurrentUser:(DONItem *)item;

// Item creation factories
+(instancetype)createItemWithName:(NSString *)name
											description:(NSString *)description
											listedBy:(DONUser *)
//											location:(PFGeoPoint *)location
														 tags:(NSArray *)tags
										    itemImage:(UIImage *)itemImage
							 itemThumbnailImage:(UIImage *)itemThumbnailImage;

//											listedBy:(DONUser *)currentUser

-(void)itemPhotoWithCompletion:(void (^)(UIImage *image))completion;

/**
 Adds a category to an item based on a string representation
 Make sure to check the Parse table names under 'Category' first!
 */
-(void)addCategory:(NSString *)category withCompletion:(void (^)(BOOL success))completion;

/**
 Adds multiple categories to a single item 
*/
-(void)addCategories:(NSArray *)categories withCompletion:(void (^)(BOOL success))completion;

/**
 Returns an array of items for the given category
*/
+(void)itemsWithCategory:(NSString *)category withCompletion:(void (^)(BOOL success, NSArray *items))completion;

@end
