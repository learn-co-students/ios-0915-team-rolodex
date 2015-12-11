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
   
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Don-text"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    self.textField.text = content;
}

-(void)mapDescription{
    //self.mapText.text = @"Tap the top-right location icon to view a map containing pins of each available item";
}

#pragma marker cells


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
        NSString * viewItem = @" Click on a category filter to trim down the list of available items.";
        cell.cellLabel.text = viewItem;
        cell.cellimageView.image = [UIImage imageNamed:@"furniture"];
    } else if (indexPath.row == 1) {
        NSString * viewMap = @"You can even view items on a map to see at a glance what’s nearby.\n Viewing an Item Tap on an image to view the listed item’s description and location Verification, When an item is located within 3.5 blocks or 1.5 avenues (1000ft)";
        cell.cellLabel.text = viewMap;
        cell.cellimageView.image = [UIImage imageNamed:@"map"];

    } else if (indexPath.row == 2) {
        NSString * eachItem = @" Claim - Indicate you’re going to pick up an item.\n Verify - Verify that an item nearby is actually there.\n Flag - Flag an item that doesn’t exist";
        
        cell.cellLabel.text = eachItem;
        cell.cellimageView.image = [UIImage imageNamed:@"varify"];

    }else {
        
        NSString * listItem = @"Click the List Item button in the menu to list your items";
        cell.cellLabel.text =listItem;
        cell.cellimageView.image = [UIImage imageNamed:@"ListItem"];
        
        cell.cellLabel.adjustsFontSizeToFitWidth = YES;
//        [cell.cellLabel sizeToFit];
//        
//        
//        
//        UIEdgeInsets insets = UIEdgeInsetsMake(3, 6, 3, 3);
//        cell.cellLabel.frame = UIEdgeInsetsInsetRect(cell.cellLabel.frame, insets);
//        
        

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
    
    //[self.textField addSubview:contentImage];
}

@end
