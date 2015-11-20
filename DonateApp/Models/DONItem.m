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
@dynamic itemImage;
@dynamic itemThumbnailImage;

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


//-(void)itemPhotoWithCompletion:(void (^)(UIImage *image))completion{
//		
//		if (!_itemImage) {
//				PFFile *itemImageFile = [self objectForKey:@"itemImage"];
//				[itemImageFile get]
//		}
//		
//		
//}

//PFFile *userImageFile = anotherPhoto[@"imageFile"];
//[userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//    if (!error) {
//        UIImage *image = [UIImage imageWithData:imageData];
//    }
//}];
//-(void)setItemImage

@end
