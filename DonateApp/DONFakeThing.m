//
//  DONFakeThing.m
//  DonateApp
//
//  Created by Guang on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONFakeThing.h"

@implementation DONFakeThing



-(instancetype)initWithName:(NSString *)name image:(NSString *)image{
    self = [super self];
    
    if (self) {
        _name = name;
        _image = image;
    }
    
    return self;
}

@end
