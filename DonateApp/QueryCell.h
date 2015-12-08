//
//  QueryCell.h
//  DonateApp
//
//  Created by Guang on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DONUser.h"

#import <ParseUI/ParseUI.h>


@interface QueryCell : UICollectionViewCell

@property (strong , nonatomic)DONUser * pageUser;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet PFImageView *image;

@end
