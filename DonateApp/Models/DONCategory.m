//
//  DONCategory.m
//  DonateApp
//
//  Created by Jon on 11/20/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONCategory.h"

@implementation DONCategory
@dynamic name;

+ (void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName
{
    return @"Category";
}

//-(UIImage*)imageForCategory {
//		if(self.name isEqual: @"Books"){
//				return [UIImage imageNamed: @"bookIcon"];
//		}
//}

+(void)categoryWithName:(NSString *)name withCompletion:(void (^)(BOOL success, DONCategory *category))completion
{
    PFQuery *categoryQuery = [self.class query];
    [categoryQuery whereKey:@"name" equalTo:name];
    [categoryQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            if (objects.count > 1) {
                NSLog(@"WARNING: More than 1 category found. Categories should be unique.");
                completion(NO, nil);
            } else if (objects.count == 0) {
                NSLog(@"No matching category found.");
                completion(NO, nil);
            } else {
                DONCategory *category = objects[0];
                completion(YES, category);
            }
        } else {
            NSLog(@"Error finding a category. Error %@", error);
            completion(NO, nil);
        }
    }];
}


@end
