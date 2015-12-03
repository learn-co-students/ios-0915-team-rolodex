//
//  DONItemStatsView.m
//  DonateApp
//
//  Created by Jon on 11/23/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONItemStatsView.h"
#import "Masonry.h"
#import "DONActivity.h"

@interface DONItemStatsView ()
@property (nonatomic, strong) UILabel *viewsLabel;
@property (nonatomic, strong) UIImageView *viewsImageView;
@property (nonatomic, strong) UILabel *favoritesLabel;
@property (nonatomic, strong) UIImageView *favoritesImageView;
@property (nonatomic, strong) UIView *background;
@end

@implementation DONItemStatsView

-(instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    [self setupViews];
    [self setupViewProperties];
    [self setupConstraints];
    
    return self;
}

-(void)setupViews
{
    self.viewsLabel = [[UILabel alloc] init];
    self.viewsImageView = [[UIImageView alloc] init];
    self.favoritesLabel = [[UILabel alloc] init];
    self.favoritesImageView = [[UIImageView alloc] init];
    self.background =[[UIView alloc] init];

    [self addSubview:self.background];
    [self addSubview:self.viewsLabel];
    [self addSubview:self.viewsImageView];
    [self addSubview:self.favoritesLabel];
    [self addSubview:self.favoritesImageView];
}

-(void)setupViewProperties
{
    self.viewsLabel.font = [UIFont systemFontOfSize:18];
    self.viewsLabel.textColor = [UIColor whiteColor];
    self.viewsLabel.text = @"0";
    
    self.favoritesLabel.font = self.viewsLabel.font;
    self.favoritesLabel.textColor = self.viewsLabel.textColor;
    self.favoritesLabel.text = @"0";
    
    UIImage *viewsImg = [UIImage imageNamed:@"view"];
    viewsImg = [viewsImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.viewsImageView.image = viewsImg;
    [self.viewsImageView setTintColor:[UIColor colorWithRed:0 green:255.0/255.0 blue:171.0/255.0 alpha:1.0f]];
    self.viewsImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.favoritesImageView.image = [UIImage imageNamed:@"favorite-outline"];
    self.favoritesImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.background.layer.cornerRadius = 5.0f;
    self.background.backgroundColor = [UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1];

}

-(void)setupConstraints
{
    [self.viewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
    }];
    
    [self.viewsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewsLabel.mas_right).offset(3);
        make.centerY.equalTo(self);
        make.height.and.width.equalTo(@25);
    }];
    
    [self.favoritesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewsImageView.mas_right).offset(5);
        make.centerY.equalTo(self);
    }];
    
    [self.favoritesImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.favoritesLabel.mas_right).offset(3);
        make.centerY.equalTo(self);
        make.height.and.width.equalTo(@20);

    }];
    
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewsLabel).offset(-5);
        make.right.equalTo(self.favoritesImageView).offset(5);
        make.top.and.bottom.equalTo(self.viewsLabel);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.background);
    }];
}

-(void)setNumberOfViews:(NSString *)numberOfViews
{
    _numberOfViews = numberOfViews;
    self.viewsLabel.text = numberOfViews;
}

-(void)setNumberOfFavorites:(NSString *)numberOfFavorites
{
    _numberOfFavorites = numberOfFavorites;
    self.favoritesLabel.text = numberOfFavorites;
}

@end
