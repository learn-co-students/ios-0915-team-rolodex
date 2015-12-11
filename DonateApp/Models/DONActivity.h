//
//  DONActivity.h
//  DonateApp
//
//  Created by Jon on 11/23/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "DONUser.h"
#import "DONItem.h"

static NSString *const kActivityTypeVerification = @"verification";
static NSString *const kActivityTypeFavorite = @"favorite";
static NSString *const kActivityTypeClaim = @"claim";
static NSString *const kActivityTypeView = @"view";

@interface DONActivity : PFObject <PFSubclassing>
@property (nonatomic, strong) DONUser *fromUser;
@property (nonatomic, strong) DONUser *toUser;
@property (nonatomic, strong) DONItem *item;
@property (nonatomic, strong) NSString *type;

+(NSString *)parseClassName;

+(void)activitiesForUser:(DONUser *)user activityType:(NSString *)activityType withCompletion:(void (^)(NSArray *activities))completion;
+(void)activitiesToUser:(DONUser *)user activityType:(NSString *)activityType withCompletion:(void (^)(NSArray *))completion;
+(void)activitiesForUser:(DONUser *)user withCompletion:(void (^)(NSArray *activities))completion;
+(void)activitiesForItem:(DONItem *)item withCompletion:(void (^)(NSArray *activities))completion;
+(void)removeActivityType:(NSString *)activityType forUser:(DONUser *)user onItem:(DONItem *)item withCompletion:(void (^)(BOOL success))completion;
+(void)addActivityType:(NSString *)activityType toItem:(DONItem *)item fromUser:(DONUser *)fromUser toUser:(DONUser *)toUser withCompletion:(void (^)(BOOL success))completion;
+(NSInteger)numberOfActivities:(NSString *)activityType inItemActivities:(NSArray *)allActivities;
+(BOOL)activityExists:(NSString *)activityType forUser:(DONUser *)user inItemActivities:(NSArray *)allActivities;

@end
