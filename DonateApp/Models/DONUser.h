//
//  User.h
//  DonateApp
//
//  Created by Jon on 11/17/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "PFUser.h"
#import "PFSubclassing.h"
#import <Parse/Parse.h>

@interface DONUser : PFUser <PFSubclassing>

// Single value properties
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL emailVerified;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *user_phone;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong, readonly) PFFile *photoFile;

-(void)setPhoto:(UIImage *)photo;

/* Use the below to grab a reference to the test user
 __block DONUser *testUser;
 [DONUser testUserWithCompletion:^(DONUser *user, NSError *error) {
     testUser = user;
 }];
 */
+ (void)testUserWithCompletion:(void (^)(DONUser *user, NSError *error))completion;
+ (void)allItemsForCurrentUserWithCompletion:(void (^)(NSArray *items, BOOL success))completion;



@end
