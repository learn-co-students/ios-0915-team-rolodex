//
//  User.m
//  DonateApp
//
//  Created by Jon on 11/17/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONUser.h"
#import <Parse/Parse.h>
#import "DONItem.h"
#import "DONVerification.h"

@interface DONUser ()

@end

@implementation DONUser

@dynamic username;
@dynamic password;
@dynamic emailVerified;
@dynamic email;
@dynamic user_phone;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic photo;

+ (void)load {
    [self registerSubclass];
}

+ (void)loginTestUserWithCompletion:(void (^)(DONUser *user, NSError *error))completion
{
    if ([DONUser currentUser] && [[DONUser currentUser].username isEqualToString:@"jdoe"]) {
        completion([DONUser currentUser], nil);
    } else {
        [DONUser logInWithUsernameInBackground:@"jdoe" password:@"1234" block:^(PFUser * _Nullable user, NSError * _Nullable error) {
           completion((DONUser *)user, error);
        }];
    }
}

+ (void)testUserWithCompletion:(void (^)(DONUser *user, NSError *error))completion
{
    DONUser *userToLoad = [DONUser objectWithoutDataWithClassName:[self parseClassName] objectId:@"wvBL77sPZ1"];
    [userToLoad fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        DONUser *user = (DONUser *)object;
        completion(user, error);
    }];
}

+ (void)allItemsForCurrentUserWithCompletion:(void (^)(NSArray *items, BOOL success))completion
{
    // Get the current user
    if (![DONUser currentUser]) {
        NSLog(@"Failed loading items. No current user found");
        return;
    }
    
    PFQuery *itemsQuery = [PFQuery queryWithClassName:[DONItem parseClassName]];
    [itemsQuery whereKey:@"listedBy" equalTo:[DONUser currentUser]];
    
    [itemsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error fetching listedItems for current user: %@", error);
            completion(nil,NO);
        } else {
            NSLog(@"Successfully fetched and loaded listedItems for current user");
            completion(objects,YES);
        }
    }];
}

+ (void)allItemsForUser:(DONUser *)user withCompletion:(void (^)(NSArray *items, BOOL success))completion
{
    PFQuery *itemsQuery = [PFQuery queryWithClassName:[DONItem parseClassName]];
    [itemsQuery whereKey:@"listedBy" equalTo:user];
    
    [itemsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error fetching listedItems for specific user: %@", error);
            completion(nil,NO);
        } else {
            NSLog(@"Successfully fetched and loaded listedItems for specific user");
            completion(objects,YES);
        }
    }];
}


+ (void)allVerificationsForCurrentUserWithCompletion:(void (^)(NSArray *items, BOOL success))completion
{
    // Get the current user
    if (![DONUser currentUser]) {
        NSLog(@"Failed loading verifications. No current user found");
        return;
    }
    
    PFQuery *verificationsQuery = [PFQuery queryWithClassName:[DONVerification parseClassName]];
    [verificationsQuery whereKey:@"verifiee" equalTo:[DONUser currentUser]];
    
    [verificationsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error fetching verifications for current user: %@", error);
            completion(nil,NO);
        } else {
            NSLog(@"Successfully fetched and loaded verifications for current user");
            completion(objects,YES);
        }
    }];
}

+ (void)allVerificationsForUser:(DONUser *)user withCompletion:(void (^)(NSArray *items, BOOL success))completion
{
    PFQuery *verificationsQuery = [PFQuery queryWithClassName:[DONVerification parseClassName]];
    [verificationsQuery whereKey:@"verifiee" equalTo:user];
    
    [verificationsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error fetching verifications for specific user: %@", error);
            completion(nil,NO);
        } else {
            NSLog(@"Successfully fetched and loaded verifications for specific user");
            completion(objects,YES);
        }
    }];
}

@end
