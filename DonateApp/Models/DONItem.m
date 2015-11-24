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

@implementation DONItem

@dynamic name;
@dynamic description;
@dynamic listedBy;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic tags;
@dynamic itemImage;
@dynamic itemThumbnailImage;
@dynamic location;


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

+(instancetype)createItemWithName:(NSString *)name
                description:(NSString *)description
								tags:(NSArray *)tags
								itemImage:(UIImage *)itemImage
								itemThumbnailImage:(UIImage *)itemThumbnailImage
{
    DONItem *item = [[DONItem alloc] init];
    item.name = name;
    item.description = description;
		item.tags = tags;
		item.itemImage = itemImage;
		item.itemThumbnailImage = itemThumbnailImage;
    return item;
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
@end
