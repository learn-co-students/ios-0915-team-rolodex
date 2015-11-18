//
//  QueryCell.m
//  DonateApp
//
//  Created by Guang on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "QueryCell.h"

@implementation QueryCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return  self;
}

/*
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"initWithFrame: is getting called.");
        [self commonInit];
    }
    return  self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"initWithCoder: is getting called.");
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.image];
}
*/
-(void)setThing:(DONFakeThing *)thing{
    _thing = thing; // ? why the property has to be in the h file.
}

-(void)updateThing{
    self.cellTitle.text = self.thing.name;
    self.image.image = [UIImage imageNamed:self.thing.image];
}


@end
