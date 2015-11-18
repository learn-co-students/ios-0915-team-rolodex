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
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) UIImage *itemImage;
@property (nonatomic, strong) UIImage *itemThumbnailImage;
//@property (nonatomic, strong)

+(NSString *)parseClassName;

+(void)fetchItemWithItemId:(NSString *)ID withCompletion:(void (^)(DONItem *item, NSError *error))completion;

// Save the item and associate it with the current user
+(void)listItemForCurrentUser:(DONItem *)item;

// Item creation factories
+(instancetype)createItemWithName:(NSString *)name
											description:(NSString *)description
											listedBy:(DONUser *)
											location:(PFGeoPoint *)location
														 tags:(NSArray *)tags
										    itemImage:(UIImage *)itemImage
							 itemThumbnailImage:(UIImage *)itemThumbnailImage;

//											listedBy:(DONUser *)currentUser

-(void)itemPhotoWithCompletion:(void (^)(UIImage *image))completion;

@end
