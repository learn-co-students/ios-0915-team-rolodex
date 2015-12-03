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
#import "DONCategory.h"
#import "DONActivity.h"

@implementation DONItem

@dynamic name;
@dynamic itemDescription;
@dynamic pickupInstructions;
@dynamic listedBy;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic itemImage;
@dynamic location;
@dynamic views;
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
    object.itemDescription = description;
		object.pickupInstructions = pickupInstructions;
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

-(PFFile *)imageFile
{
    return [self objectForKey:@"image"];

}

-(void)addCategory:(NSString *)category withCompletion:(void (^)(BOOL success))completion;
{
    [DONCategory categoryWithName:category withCompletion:^(BOOL success, DONCategory *category) {
        [self addUniqueObject:category forKey:@"categories"];
        [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            completion(YES);
        }];
    }];
}

-(void)addCategories:(NSArray *)categories withCompletion:(void (^)(BOOL success))completion;
{
    NSOperationQueue *bgQueue = [[NSOperationQueue alloc] init];
    bgQueue.maxConcurrentOperationCount = 1;

    __block BOOL allSuccessful = YES;
    
    for (NSString *category in categories) {
        [bgQueue addOperationWithBlock:^{
            [self addCategory:category withCompletion:^(BOOL success) {
                if (!success) {
                    allSuccessful = NO;
                }
            }];
        }];
    }
    
    NSBlockOperation *finalOperation = [NSBlockOperation blockOperationWithBlock:^{
        completion(allSuccessful);
    }];
    
    [bgQueue addOperation:finalOperation];
}

+(void)itemsWithCategory:(NSString *)category withCompletion:(void (^)(BOOL success, NSArray *items))completion
{
    [DONCategory categoryWithName:category withCompletion:^(BOOL success, DONCategory *category) {
        PFQuery *itemCategoryQuery = [self query];
        [itemCategoryQuery whereKey:@"categories" equalTo:category];
        [itemCategoryQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                completion(YES,objects);
            } else {
                completion(NO, nil);
            }
        }];
    }];
}

+(void)allItemsWithCompletion:(void (^)(BOOL success, NSArray *allItems))completion{
    
    PFQuery *itemCategoryQuery = [self query];
    [itemCategoryQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            completion(YES,objects);
        } else {
            completion(NO, nil);
        }
    }];
    
}

-(void)incrementViewForCurrentUserWithCompletion:(void (^)(BOOL success))completion
{
    if (![DONUser currentUser]) {
        NSLog(@"Incrementing for guest user once");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *viewedObjects = [defaults objectForKey:@"viewedObjects"];
        for (NSString *objID in viewedObjects) {
            if ([objID isEqualToString:self.objectId]) {
                NSLog(@"Already incremented for guest user - aborting");
                return;
            }
        }
    }
    
    [DONActivity activitiesForItem:self withCompletion:^(NSArray *activities) {
       BOOL activityExists = [DONActivity activityExists:kActivityTypeView forUser:[DONUser currentUser] inItemActivities:activities];
        if (activityExists) {
            completion(NO);
        } else {
            [DONActivity addActivityType:kActivityTypeView toItem:self fromUser:[DONUser currentUser] toUser:nil withCompletion:^(BOOL success) {
                self.views = [NSNumber numberWithInt:[self.views intValue] + 1];
                [self saveEventually];
                
                if (![DONUser currentUser]) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSMutableArray *viewedObjects = [defaults objectForKey:@"viewedObjects"];
                    [viewedObjects addObject:self.objectId];
                    [defaults synchronize];
                }
                completion(YES);
            }];

        }
   }];
}


@end
