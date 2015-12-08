//
//  QueryCell.m
//  DonateApp
//
//  Created by Guang on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "QueryCell.h"

@interface QueryCell ()

@end

@implementation QueryCell

-(void)setUser:(DONUser *)pageUser{
    _pageUser = pageUser; // ? why the property has to be in the h file.
}

-(void)updateThing{
    self.cellTitle.text = self.pageUser.username;
}

@end
