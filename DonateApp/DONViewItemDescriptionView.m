//
//  DONViewItemDescriptionView.m
//  DonateApp
//
//  Created by Jon on 11/25/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONViewItemDescriptionView.h"
#import "DONLocationController.h"
#import "DateTools.h"
#import "Masonry.h"

@interface DONViewItemDescriptionView ()
@property (nonatomic, strong) DONItem *item;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *itemDescription;
@property (nonatomic, strong) UILabel *location;
@property (nonatomic, strong) UILabel *pickupLocation;
@property (nonatomic, strong) UILabel *expiration;
@property (nonatomic, strong) UILabel *expires;

@end
@implementation DONViewItemDescriptionView
-(instancetype)initWithItem:(DONItem *)item
{
    self = [super initWithFrame:CGRectZero];
    if (!self) return nil;
    self.item = item;
    [self setupViews];
    [self setupViewProperties];
    [self constrainViews];
    return self;
}

-(void)setupViews
{
    self.title = [self setupTitleLabel];
    self.itemDescription = [self setupSubtitleLabel];
    
    self.location = [self setupTitleLabel];
    self.pickupLocation = [self setupSubtitleLabel];
    self.expiration = [self setupTitleLabel];
    self.expires = [self setupSubtitleLabel];
}

-(UILabel *)setupTitleLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1];
    [self addSubview:label];
    return label;
}

-(UILabel *)setupSubtitleLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor colorWithRed:125.0/255.0 green:125.0/255.0 blue:125.0/255.0 alpha:1];
    [self addSubview:label];
    return label;
}

-(void)setupViewProperties
{
    // Text values
    self.backgroundColor = [UIColor whiteColor];
    self.title.text = self.item.name;
    self.itemDescription.text = self.item.itemDescription;
    self.location.text = @"Location";
    
    [DONLocationController cityAndStateForGeoPoint:self.item.location withCompletion:^(NSString *string) {
        if (![string isEqualToString:@"(null), (null)"])
        {
            self.location.text = string;
        }
    }];
    
    self.pickupLocation.text = self.item.pickupInstructions;
    self.expiration.text = @"Listed";
    self.expires.text = self.item.createdAt.timeAgoSinceNow;
    
    //Text display properties
    self.itemDescription.lineBreakMode = NSLineBreakByWordWrapping;
    self.itemDescription.numberOfLines = 10;
    
    self.pickupLocation.lineBreakMode = NSLineBreakByWordWrapping;
    self.pickupLocation.numberOfLines = 10;

    self.expiration.textAlignment = NSTextAlignmentRight;
    self.expires.textAlignment = NSTextAlignmentRight;
    
}
    

-(void)constrainViews
{
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self);
    }];
    
    [self.itemDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(1);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.itemDescription.mas_bottom).offset(10);
    }];
    
    [self.pickupLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.location);
        make.top.equalTo(self.location.mas_bottom).offset(1);
        make.right.equalTo(self.expires.mas_left).offset(-15);
    }];
    
    [self.expiration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.location);
    }];
    
    [self.pickupLocation setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.expires setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.expires mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.expiration.mas_bottom).offset(1);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.title);
        make.right.equalTo(self.expiration);
        make.bottom.equalTo(self.pickupLocation);
    }];
    
}
@end
