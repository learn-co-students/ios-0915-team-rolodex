//
//  DonCollectionViewController.m
//  DonateApp
//
//  Created by Guang on 11/30/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DonCollectionViewController.h"

#import "DONUser.h"
#import "DONItem.h"
#import "DONCategory.h"
#import "QueryCell.h"

@interface DonCollectionViewController ()

@property (strong, nonatomic) NSArray * items;
@property (strong, nonatomic) NSMutableArray * allCategory;

@end

@implementation DonCollectionViewController

static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
   //[self.collectionView registerClass:[QueryCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self getAllPdata]; // do you set this as a main Queae ?
    [self activeXibCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItems = collectionView == self.collectionView ? self.items.count : self.allCategory.count;
    return numberOfItems;
}


#pragma mark <UICollectionViewDelegate>


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        QueryCell * cell = (QueryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        DONItem * item = self.items[indexPath.row];

        cell.cellTitle.text = item.name;
        cell.image.file = item.imageFile;
        [cell.image loadInBackground];
       //cell.image.image = [UIImage imageNamed:@"clara.jpg"];

        
        //[self setupTheQueryCell:cell atIndexPath:indexPath];
    
    

        return cell;
}
 

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (collectionView == self.collectionView) {
        
        NSLog(@"I tapped collectionView");
    }

}



#pragma mark cell Style

-(void)activeXibCell{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //flowLayout.itemSize = CGSizeMake(113, 115);
    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width/2), (self.view.frame.size.height/4));
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.headerReferenceSize = CGSizeZero;
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // add vertical
    self.collectionView.collectionViewLayout = flowLayout;
}


#pragma mark data stuff

-(void)getAllPdata{
    
    [self getdataFromParseWithBlock:^(BOOL success)
     {
         if (success)
         {
             //NSLog(@"Get the info %@ with the stuffff %@",self.userOnPage,self.items);
             //self.greeting.text = [NSString stringWithFormat:@" ☞ "];
         } else{
         }
     }];
}

-(NSMutableArray *)testingData:(NSArray *) realData{
    
    NSMutableArray * testData = [NSMutableArray new];
    for (int i = 0 ; i < 5 ; i++)
    {
        [testData addObject:realData[0]];
        [testData addObject:realData[1]];
        [testData addObject:realData[2]];
        [testData addObject:realData[3]];
        [testData addObject:realData[4]];
    }
    
    return testData;
}

-(void)getdataFromParseWithBlock:(void (^)(BOOL success))completationBlock{
    
    [DONItem allItemsWithCompletion:^(BOOL success, NSArray *allItems) {
        if (success) {
            NSLog(@"allItems %@",allItems);
            self.items = [self testingData:allItems];
            [self.collectionView reloadData];
            completationBlock(YES);
            //NSLog(@"allItems %@",allItems);
            
        }else{
            NSLog(@"Error:");
        }
    }];

    
}


@end