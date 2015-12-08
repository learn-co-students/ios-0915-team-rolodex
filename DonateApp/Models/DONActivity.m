//
//  DONActivity.m
//  DonateApp
//
//  Created by Jon on 11/23/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONActivity.h"

@implementation DONActivity
@dynamic fromUser;
@dynamic toUser;
@dynamic item;
@dynamic type;

+ (void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName
{
    return @"Activity";
}

+(void)activitiesForUser:(DONUser *)user activityType:(NSString *)activityType withCompletion:(void (^)(NSArray *))completion
{
    PFQuery *query = [self.class query];
    [query whereKey:@"type" equalTo:activityType];
    [query whereKey:@"fromUser" equalTo:user];
    [query includeKey:@"item"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects);
    }];
}


+(void)activitiesForUser:(DONUser *)user withCompletion:(void (^)(NSArray *))completion
{
    PFQuery *query = [self.class query];
    [query whereKey:@"fromUser" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects);
    }];
}

+(void)activitiesForItem:(DONItem *)item withCompletion:(void (^)(NSArray *activities))completion
{
    PFQuery *query = [self.class query];
    [query whereKey:@"item" equalTo:item];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects);
    }];
}

+(void)addActivityType:(NSString *)activityType toItem:(DONItem *)item fromUser:(DONUser *)fromUser toUser:(DONUser *)toUser withCompletion:(void (^)(BOOL success))completion
{
    DONActivity *activity = [DONActivity object];
    activity.fromUser = fromUser;
    activity.toUser = toUser;
    activity.type = activityType;
    activity.item = item;
    
    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(succeeded);
    }];
}

+(void)removeActivityType:(NSString *)activityType forUser:(DONUser *)user onItem:(DONItem *)item withCompletion:(void (^)(BOOL success))completion
{
    [DONActivity activitiesForItem:item withCompletion:^(NSArray *activities) {
        for (DONActivity *activity in activities) {
            if ([activity.type isEqualToString:activityType] && [activity.fromUser.objectId isEqualToString:user.objectId]) {
                [DONActivity deleteAllInBackground:@[activity] block:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        completion(succeeded);
                    }
                }];
            }
        }
    }];
}

+(NSInteger)numberOfActivities:(NSString *)activityType inItemActivities:(NSArray *)allActivities
{
    NSInteger activities = 0;
    for (DONActivity *activity in allActivities) {
        if ([activity.type isEqualToString:activityType]) {
            activities++;
        }
    }
    return activities;
}

+(BOOL)activityExists:(NSString *)activityType forUser:(DONUser *)user inItemActivities:(NSArray *)allActivities
{
    for (DONActivity *activity in allActivities) {
        if ([activity.type isEqualToString:activityType] && [activity.fromUser.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    return NO;
}

@end
