//
//  DONCategory.h
//  DonateApp
//
//  Created by Jon on 11/20/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "PFObject.h"
#import "PFSubclassing.h"
#import <ParseUI/ParseUI.h>
#import "DONUser.h"

@interface DONCategory : PFObject <PFSubclassing>
@property (nonatomic, strong) NSString *name;

+(NSString *)parseClassName;
+(void)categoryWithName:(NSString *)name withCompletion:(void (^)(BOOL success, DONCategory *category))completion;

@end
