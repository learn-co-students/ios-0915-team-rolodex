//
//  DONViewItemButton.h
//  DonateApp
//
//  Created by Jon on 11/24/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DONViewItemButtonToggleState)
{
    DONViewItemButtonStateDefault,
    DONViewItemButtonStateToggled,
    DONViewItemButtonStateNoData
};

typedef NS_ENUM(NSInteger, DONViewItemButtonEnabledState)
{
    DONViewItemButtonStateDisabled,
    DONViewItemButtonStateEnabled
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
@property (nonatomic, assign) DONViewItemButtonToggleState toggledState;
@property (nonatomic, assign) DONViewItemButtonEnabledState enabledState;

-(instancetype)initWithText:(NSString *)text color:(DONViewItemButtonType)buttonType;
-(instancetype)initWithDefaultText:(NSString *)defaultText
                       toggledText:(NSString *)toggledText
                      toggledState:(DONViewItemButtonToggleState)toggledState
                      enabledState:(DONViewItemButtonEnabledState)enabledState
                             color:(DONViewItemButtonType)buttonType;

@end
