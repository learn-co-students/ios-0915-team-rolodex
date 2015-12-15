//
//  DonHelpViewController.m
//  DonateApp
//
//  Created by Guang on 12/10/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DonHelpViewController.h"
#import "DonHelpCustomCell.h"
#import "Masonry.h"


@interface DonHelpViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (strong, nonatomic) IBOutlet UIView *backView;


@property (strong, nonatomic) NSMutableArray * allTexts;

@end

@implementation DonHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mapDescription];
    
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    
    [self contentViewVisual];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)mapDescription{
    //self.mapText.text = @"Tap the top-right location icon to view a map containing pins of each available item";
}

#pragma marker cells


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self textInfo:indexPath];
}

-(DonHelpCustomCell *)textInfo: (NSIndexPath *)indexPath {

    DonHelpCustomCell *cell = (DonHelpCustomCell *)[self.infoTableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.row == 0) {
        NSString * viewItem = @"Filter - Browse different categories by selecting one or more categories up to a maximum of three";
        cell.cellLabel.text = viewItem;
        cell.cellimageView.image = [UIImage imageNamed:@"funie"];
    } else if (indexPath.row == 1) {
        NSString * viewMap = @"Nearby - Browse nearby items on a map";
        cell.cellLabel.text = viewMap;
        cell.cellimageView.image = [UIImage imageNamed:@"mappie"];

    } else if (indexPath.row == 2) {
        NSString * eachItem = @"Claim - Let others know you’ve picked up an item. \n\nVerify - Let others know an item exists in good condition.";
        cell.cellLabel.text = eachItem;
        cell.cellimageView.image = [UIImage imageNamed:@"claim"];

    }else if (indexPath.row == 3) {
        NSString * eachItem = @"Flag - Keep your community clean and flag erroneous items for removal";
        cell.cellLabel.text = eachItem;
        cell.cellimageView.image = [UIImage imageNamed:@"flagie"];

    }else if (indexPath.row == 4) {
        
        NSString * listItem = @"List Item - Getting rid of something or happen to see something interesting on the curb? Tap List Item from the menu to let others know about it.";
        cell.cellLabel.text =listItem;
        cell.cellimageView.image = [UIImage imageNamed:@"Listie"];
        cell.cellLabel.adjustsFontSizeToFitWidth = YES;
        
    }
    else {
        if (cell.cellimageView.image == nil ) {
         
            [cell.cellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.mas_right).offset(-25);
                make.left.equalTo(cell.mas_left).offset(20);
                make.bottom.equalTo(cell.mas_bottom).offset(-10);
            }];
            
        }
        NSString * eachItem = @"Curb Alert was built by a team of nerds hailing from the Flatiron School: Jon, Guang, Mickey, and Laurent. Special thanks to Jim, Tim, Tom (oh, what a song). Open source contributions from Cocoapods, Noun project, GoogleMaps, and the wild city of New York!";
        cell.cellLabel.text = eachItem;
      
        }

    return cell;
}


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

    [cellImage drawInRect:CGRectMake(0, 0, cellImage.size.width, cellImage.size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
