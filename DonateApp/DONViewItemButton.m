//
//  DONViewItemButton.m
//  DonateApp
//
//  Created by Jon on 11/24/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONViewItemButton.h"
#import "Masonry.h"

@interface DONViewItemButton ()
@property (nonatomic, strong) NSString *defaultText;
@property (nonatomic, strong) NSString *toggledText;
@property (nonatomic, assign) DONViewItemButtonType DONButtonType;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *background;
@end

@implementation DONViewItemButton

-(instancetype)initWithText:(NSString *)text color:(DONViewItemButtonType)buttonType
{
    self = [super init];
    if (!self) return nil;
    
    self.DONButtonType = buttonType;
    
    [self setupViews];
    [self setupViewProperties];
    [self constrainViews];
    
    self.text = text;
    
    return self;
}

-(instancetype)initWithDefaultText:(NSString *)defaultText toggledText:(NSString *)toggledText buttonState:(DONViewItemButtonState)buttonState color:(DONViewItemButtonType)buttonType
{
    self = [super init];
    if (!self) return nil;

    self.DONButtonType = buttonType;
    self.defaultText = defaultText;
    self.toggledText = toggledText;
    
    [self setupViews];
    [self setupViewProperties];
    [self constrainViews];
    
    self.buttonState = buttonState;

    return self;
}


-(void)setupViews
{
    self.textLabel = [[UILabel alloc] init];
    self.background = [[UIView alloc] init];
    
    [self addSubview:self.background];
    [self addSubview:self.textLabel];
}

-(void)setupViewProperties
{
    self.background.layer.cornerRadius = 2.0f;
    
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.textColor = [UIColor whiteColor];
    
    UIColor *color;
    switch (self.DONButtonType) {
        case DONViewItemButtonTypeBlue: {
            color = [UIColor colorWithRed:33.0/255.0 green:60.0/255.0 blue:192.0/255.0 alpha:1];
            break;
        }
        case DONViewItemButtonTypeGreen: {
            color = [UIColor colorWithRed:33.0/255.0 green:192.0/255.0 blue:100.0/255.0 alpha:1];
            break;
        }
        case DONViewItemButtonTypeRed: {
            color = [UIColor colorWithRed:192.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1];
            break;
        }
        case DONViewItemButtonTypeGray: {
            color = [UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1];
            break;
        }
        default: {
            color = [UIColor blackColor];
            break;
        }
    }
    [self.background setBackgroundColor:color];
}

-(void)constrainViews
{
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self);
    }];
    
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel).offset(-15);
        make.right.equalTo(self.textLabel).offset(15);
        make.top.equalTo(self.textLabel).offset(-5);
        make.bottom.equalTo(self.textLabel).offset(5);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.background);
    }];
}

-(void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = text;
}

-(void)setButtonState:(DONViewItemButtonState)buttonState
{
    _buttonState = buttonState;
    
    if (buttonState == DONViewItemButtonStateDefault) {
        self.textLabel.text = self.defaultText;
    } else if (buttonState == DONViewItemButtonStateToggled) {
        self.textLabel.text = self.toggledText;
    } else {
        self.textLabel.text = @"...";
    }
    
    if (buttonState == DONViewItemButtonStateDisabled) {
        self.textLabel.textColor = [UIColor grayColor];
        self.userInteractionEnabled = NO;
    } else {
        self.textLabel.textColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
    }
}
@end
