//
//  DONCategory.h
//  DonateApp
//
//  Created by Jon on 11/20/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "DONUser.h"

@interface DONCategory : PFObject <PFSubclassing>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *categoryIcon;
@property (nonatomic, strong, readonly) PFFile *imageFile;
@property (nonatomic, assign) BOOL selected;

+(NSString *)parseClassName;
+(void)categoryWithName:(NSString *)name withCompletion:(void (^)(BOOL success, DONCategory *category))completion;
+(void)allCategoriesWithCompletion:(void (^)(BOOL success, NSArray *categories))completion;
-(UIImage *)categoryIconForCurrentState;
@end
