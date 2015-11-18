//
//  DONFakeThing.h
//  DonateApp
//
//  Created by Guang on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DONFakeThing : NSObject

@property(nonatomic, strong)NSString * name;
@property(nonatomic, strong)NSString * image;

-(instancetype)initWithName:(NSString *)name
                      image:(NSString *) image;

@end
