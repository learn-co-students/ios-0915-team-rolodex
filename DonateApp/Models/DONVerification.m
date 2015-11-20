//
//  DONVerification.m
//  DonateApp
//
//  Created by Jon on 11/20/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONVerification.h"

@implementation DONVerification
@dynamic verifier;
@dynamic verifiee;

+ (void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName
{
    return @"Verification";
}


@end
