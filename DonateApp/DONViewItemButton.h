//
//  DONViewItemButton.h
//  DonateApp
//
//  Created by Jon on 11/24/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DONViewItemButtonState)
{
    DONViewItemButtonStateDefault,
    DONViewItemButtonStateToggled
};

typedef NS_ENUM(NSInteger, DONViewItemButtonType)
{
    DONViewItemButtonTypeBlue,
    DONViewItemButtonTypeGreen,
    DONViewItemButtonTypeRed,
    DONViewItemButtonTypeGray
};

@interface DONViewItemButton : UIControl
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) DONViewItemButtonState buttonState;

-(instancetype)initWithText:(NSString *)text color:(DONViewItemButtonType)buttonType;
-(instancetype)initWithDefaultText:(NSString *)defaultText toggledText:(NSString *)toggledText buttonState:(DONViewItemButtonState)buttonState color:(DONViewItemButtonType)buttonType;

@end
