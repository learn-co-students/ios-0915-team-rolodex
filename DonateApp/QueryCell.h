//
//  QueryCell.h
//  DonateApp
//
//  Created by Guang on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DONFakeThing.h"

@interface QueryCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) DONFakeThing * thing;

@end
