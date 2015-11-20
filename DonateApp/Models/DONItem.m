//
//  DONItem.m
//  DonateApp
//
//  Created by Jon on 11/17/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONItem.h"
#import <Parse/Parse.h>
#import "PFObject+Subclass.h"
#import "DONUser.h"

@implementation DONItem

@dynamic name;
@dynamic description;
@dynamic listedBy;
//@dynamic location;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic tags;
@dynamic itemImagePF;


//
//@synthesize itemImage = _itemImage;

+ (void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName
{
    return @"DONItem";
}

+(void)fetchItemWithItemId:(NSString *)ID withCompletion:(void (^)(DONItem *item, NSError *error))completion;
{
    PFQuery *query = [self.class query];
    [query getObjectInBackgroundWithId:ID block:^(PFObject *item, NSError *error) {
        completion((DONItem *)item, error);
    }];
}

+(void)listItemForCurrentUser:(DONItem *)item
{
    if (![DONUser currentUser]) {
        NSLog(@"Error listing item for current user. No current user found");
        return;
    }
    
    item.listedBy = [DONUser currentUser];
    [item saveInBackground];
}

+(void)createItemWithNameForCurrentUserWithCompletionBlock:(NSString *)name
																											 description:(NSString *)description
																								pickupInstructions:(NSString *)pickupInstructions
																															tags:(NSArray *)tags
																												 itemImagePF:(PFFile *)itemImagePF


//																				location:(PFGeoPoint *)location


																						 withCompletion:(void(^)(BOOL success, DONItem *object))completionBlock{
//																							 withCompletion:(void(^)(BOOL success, DONItem *newItem))completionBlock {
//		

		// BIG TODO: DONItem is a sublclass of PFObject.  How can we best handle that and not repeat steps!
		
		
		// TODO: Not sure if this item here is needed.  Might be redunant, end goal seems to be that we need a PFObject.
		
		
		DONItem *object = [DONItem object];

    object.name = name;
    object.description = description;
		object.pickupInstructions = pickupInstructions;
		object.tags = tags;
		object.itemImagePF = itemImagePF;

		
		

		// set properties of newObject.
		
		// THEN YOU SEND UP TO PARSE THIS PFOJBECT!! but it should be done where the method you're calling to send this up to Parse should have a completino Block or something.
		
		[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
				NSLog(@"succeeded? %d, with error: %@", succeeded, error.localizedDescription);
				if (succeeded) {
						
						completionBlock(YES, object);
						
				} else {
				
						completionBlock(NO, nil);
						
				}
		}];
}

//-(void)itemPhotoWithCompletion:(void (^)(UIImage *image))completion{
//		
//		if (!_itemImage) {
//				PFFile *itemImageFile = [self objectForKey:@"itemImage"];
//				[itemImageFile get]
//		}
//		
//		
//}


//-(void)setItemImage

@end
