//
//  DonHelpViewController.m
//  DonateApp
//
//  Created by Guang on 12/10/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DonHelpViewController.h"
#import "DonHelpCustomCell.h"
//#import <APParallaxHeader/APParallaxHeader.h>
//#import "UIScrollView+APParallaxHeader.h"


@interface DonHelpViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (strong, nonatomic) IBOutlet UIView *backView;


@property (strong, nonatomic) NSMutableArray * allTexts;

@end

@implementation DonHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self textView];
    [self mapDescription];
    
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    
    [self contentViewVisual];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)textView{
   
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"Don-text"
//                                                     ofType:@"txt"];
//    NSString* content = [NSString stringWithContentsOfFile:path
//                                                  encoding:NSUTF8StringEncoding
//                                                     error:NULL];
    //self.textField.textColor = [UIColor whiteColor];
    self.textField.text = @"\nCurb Alert was built by a team of special nerds hailing from the Flatiron School: Jon, Guang, Micky, and Laurent. Special thanks to Jim, Tim, Tom (oh, what a song).\nOpen source contributions from Cocoapods, Noun project, GoogleMaps, and the wild city of New York!";
    
}

-(void)mapDescription{
    //self.mapText.text = @"Tap the top-right location icon to view a map containing pins of each available item";
}

#pragma marker cells


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString *cellIdentifier = @"cell";
    //DonHelpCustomCell *cell = (DonHelpCustomCell *)[self.infoTableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    cell.cellLabel.text = [self textInfo:indexPath];
//    cell.cellimageView.image = [UIImage imageNamed:@"books.png"];

    return [self textInfo:indexPath];
}

-(DonHelpCustomCell *)textInfo: (NSIndexPath *)indexPath {
    
    //self.allTexts = [NSMutableArray new];
    //[self.allTexts addObject:viewItem];
    //[self.allTexts addObject:vieMap];
    
    
    DonHelpCustomCell *cell = (DonHelpCustomCell *)[self.infoTableView dequeueReusableCellWithIdentifier:@"cell"];
   // [self cellStyle:cell.cellLabel];
    

    if (indexPath.row == 0) {
        NSString * viewItem = @"Categories - Filter through different kinds of items by selecting one or more categories";
        cell.cellLabel.text = viewItem;
        cell.cellimageView.image = [UIImage imageNamed:@"funie"];
        //cell.cellimageView.image = [self cellImage:[UIImage imageNamed:@"furniture"]];
    } else if (indexPath.row == 1) {
        NSString * viewMap = @"Nearby - Browse what’s near you on a map";
        cell.cellLabel.text = viewMap;
        cell.cellimageView.image = [UIImage imageNamed:@"mappie"];
        //cell.cellimageView.image = [self cellImage: [UIImage imageNamed:@"map"]];

    } else if (indexPath.row == 2) {
        NSString * eachItem = @"Claim - Acknowledge you’re on your way to pick up an item. Verify - Corroborate that the item is indeed ready for pickup.";
        cell.cellLabel.text = eachItem;
        cell.cellimageView.image = [UIImage imageNamed:@"claim"];

    }else if (indexPath.row == 3) {
        NSString * eachItem = @"Flag - Went to pick up an item and it wasn’t there? Flag it for removal from the app";
        cell.cellLabel.text = eachItem;
        cell.cellimageView.image = [UIImage imageNamed:@"flagie"];

    }
    else {
        
        NSString * listItem = @"List Item - Getting rid of something or happen to see something interesting on the curb? Tap List Item from the menu.";
        cell.cellLabel.text =listItem;
        cell.cellimageView.image = [UIImage imageNamed:@"Listie"];
        
        cell.cellLabel.adjustsFontSizeToFitWidth = YES;
//        [cell.cellLabel sizeToFit];
//        
//        
//        
//        UIEdgeInsets insets = UIEdgeInsetsMake(3, 6, 3, 3);
//        cell.cellLabel.frame = UIEdgeInsetsInsetRect(cell.cellLabel.frame, insets);
        }

    return cell;
}

//-(void)cellStyle :(UILabel *)cellLabel{
//    
//    cellLabel.adjustsFontSizeToFitWidth = YES;
//    [cellLabel sizeToFit];
//    UIEdgeInsets insets = UIEdgeInsetsMake(3, 6, 3, 3);
//    cellLabel.frame = UIEdgeInsetsInsetRect(cellLabel.frame, insets);
//}

-(void)contentViewVisual{

    UIImageView * contentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"monet"]];
    contentImage.alpha = 0.6;
    contentImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.backView addSubview: contentImage];
    [self.backView sendSubviewToBack:contentImage];
    
}

-(UIImage *)cellImage: (UIImage*)cellImage{
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, cellImage.size.width, cellImage.size.height)];
    circlePath.lineWidth = 1;
    UIGraphicsBeginImageContextWithOptions(cellImage.size, NO, 0);
    [[UIColor whiteColor] setFill];
    [circlePath fill];
    [UIColor colorWithWhite:0.2 alpha:0.5];

    
    //
    //    [[UIColor colorWithWhite:0.2 alpha:0.7] setStroke];
    //    [circlePath stroke];
    //
    [cellImage drawInRect:CGRectMake(0, 0, cellImage.size.width, cellImage.size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
