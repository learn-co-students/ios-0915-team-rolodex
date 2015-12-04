//
//  DonInfowindow.h
//  DonateApp
//
//  Created by Guang on 11/25/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"

#import "DONItem.h"


@interface DonInfowindow : UIView

@property (weak, nonatomic) IBOutlet PFImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic)DONItem * item;
@end
