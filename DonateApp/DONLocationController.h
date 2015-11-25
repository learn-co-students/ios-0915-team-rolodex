//
//  DONLocationController.h
//  DonateApp
//
//  Created by Jon on 11/25/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFGeoPoint.h"

@interface DONLocationController : NSObject
+(instancetype)sharedInstance;
+(void)cityAndStateForGeoPoint:(PFGeoPoint *)geoPoint withCompletion:(void (^)(NSString *string))completion;
@end
