//
//  DONActivity.h
//  DonateApp
//
//  Created by Jon on 11/23/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "PFObject.h"
#import "PFSubclassing.h"
#import <ParseUI/ParseUI.h>
#import "DONUser.h"
#import "DONItem.h"

NSString *const kActivityTypeVerification = @"verification";
NSString *const kActivityTypeFavorite = @"favorite";
NSString *const kActivityTypeClaim = @"claim";

@interface DONActivity : PFObject <PFSubclassing>
@property (nonatomic, strong) DONUser *fromUser;
@property (nonatomic, strong) DONUser *toUser;
@property (nonatomic, strong) DONItem *item;
@property (nonatomic, strong) NSString *type;

+(NSString *)parseClassName;

+(void)activitiesForItem:(DONItem *)item withCompletion:(void (^)(NSArray *items))completion;

+(void)addActivityType:(NSString *)activityType toItem:(DONItem *)item fromUser:(DONUser *)fromUser toUser:(DONUser *)toUser withCompletion:(void (^)(BOOL success))completion;

+(NSInteger)numberOfActivities:(NSString *)activityType inItemActivities:(NSArray *)allActivities;

@end
