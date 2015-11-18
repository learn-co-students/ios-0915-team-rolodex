//
//  DONItem.h
//  DonateApp
//
//  Created by Jon on 11/17/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "PFObject.h"
#import "PFSubclassing.h"
@class DONUser;

@class CLLocation;

@interface DONItem : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) DONUser *listedBy;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSArray *tags;

+(NSString *)parseClassName;

+(void)fetchItemWithItemId:(NSString *)ID withCompletion:(void (^)(DONItem *item, NSError *error))completion;

// Save the item and associate it with the current user
+(void)listItemForCurrentUser:(DONItem *)item;

// Item creation factories
+(instancetype)createItemWithName:(NSString *)name
                      description:(NSString *)description;
@end
