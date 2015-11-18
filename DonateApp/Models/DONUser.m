//
//  User.m
//  DonateApp
//
//  Created by Jon on 11/17/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONUser.h"
#import <Parse/Parse.h>
#import "PFObject+Subclass.h"
#import "DONItem.h"

@implementation DONUser

@dynamic username;
@dynamic password;
@dynamic emailVerified;
@dynamic email;
@dynamic user_phone;
@dynamic createdAt;
@dynamic updatedAt;

+ (void)load {
    [self registerSubclass];
}

+ (void)testUserWithCompletion:(void (^)(DONUser *user, NSError *error))completion
{
    if ([DONUser currentUser] && [[DONUser currentUser].username isEqualToString:@"jdoe"]) {
        completion([DONUser currentUser], nil);
    } else {
        [DONUser logInWithUsernameInBackground:@"jdoe" password:@"1234" block:^(PFUser * _Nullable user, NSError * _Nullable error) {
           completion((DONUser *)user, error);
        }];
    }
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

@end
