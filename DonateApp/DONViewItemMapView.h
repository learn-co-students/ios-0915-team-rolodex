//
//  DONViewItemMapView.h
//  DonateApp
//
//  Created by Jon on 11/25/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface DONViewItemMapView : UIView
-(instancetype)initWithLocation:(PFGeoPoint *)location;
@end
