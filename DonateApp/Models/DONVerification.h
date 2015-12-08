//
//  DONVerification.h
//  DonateApp
//
//  Created by Jon on 11/20/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "DONUser.h"

@interface DONVerification : PFObject <PFSubclassing>
@property (nonatomic, strong) DONUser *verifier;
@property (nonatomic, strong) DONUser *verifiee;

+(NSString *)parseClassName;

@end
