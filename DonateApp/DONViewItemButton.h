//
//  DONViewItemButton.h
//  DonateApp
//
//  Created by Jon on 11/24/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DONViewItemButtonType)
{
    DONViewItemButtonTypeBlue,
    DONViewItemButtonTypeGreen,
    DONViewItemButtonTypeRed,
    DONViewItemButtonTypeGray
};

@interface DONViewItemButton : UIControl
@property (nonatomic, strong) NSString *enabledText;
@property (nonatomic, strong) NSString *disabledText;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL currentState;

-(instancetype)initWithText:(NSString *)text color:(DONViewItemButtonType)buttonType;
-(instancetype)initWithEnabledText:(NSString *)enabledText disabledText:(NSString *)disabledText enabled:(BOOL)enabled color:(DONViewItemButtonType)buttonType;

@end
