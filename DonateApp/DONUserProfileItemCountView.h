//
//  DONUserProfileItemCountView.h
//  DonateApp
//
//  Created by Jon on 12/3/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DONUserProfileItemCountView : UIView
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) UIColor *textColor;
-(instancetype)initWithCaption:(NSString *)caption;
@end
