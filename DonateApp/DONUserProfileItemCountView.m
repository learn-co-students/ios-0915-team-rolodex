//
//  DONUserProfileItemCountView.m
//  DonateApp
//
//  Created by Jon on 12/3/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONUserProfileItemCountView.h"
#import <Masonry/Masonry.h>

@interface DONUserProfileItemCountView ()
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *captionLabel;
@property (nonatomic, strong) NSString *caption;
@end
@implementation DONUserProfileItemCountView

-(instancetype)initWithCaption:(NSString *)caption
{
    self = [super init];
    if (!self) return nil;
    self.caption = caption;
    
    [self setupViews];
    [self constrainViews];
    [self setupViewProperties];
    return self;
}

-(void)setupViews
{
    self.amountLabel = [[UILabel alloc] init];
    self.captionLabel = [[UILabel alloc] init];

    [self addSubview:self.amountLabel];
    [self addSubview:self.captionLabel];
}

-(void)constrainViews
{
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.captionLabel.mas_top).offset(-2);
    }];
    
    [self.captionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
    
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//
//    }];
}

-(void)setupViewProperties
{
    
    UIColor *textColor = [UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1];
    
    self.amountLabel.font = [UIFont systemFontOfSize:36];
    self.captionLabel.font = [UIFont systemFontOfSize:14];
    self.amountLabel.textColor = textColor;
    self.captionLabel.textColor = textColor;
    
    self.amountLabel.textAlignment = NSTextAlignmentCenter;
    self.captionLabel.textAlignment = NSTextAlignmentCenter;
    
    self.captionLabel.text = self.caption;
    self.amountLabel.text = @"...";
}

-(void)setAmount:(NSInteger)amount{
    self.amountLabel.text = [NSString stringWithFormat:@"%lu", amount];
}

@end
