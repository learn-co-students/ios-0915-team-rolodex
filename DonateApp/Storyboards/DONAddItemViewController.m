//
//  DONAddItemViewController.m
//  DonateApp
//
//  Created by synesthesia on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONAddItemViewController.h"

@interface DONAddItemViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation DONAddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)addImageButtonTapped:(id)sender{
		
				//initialize picker controller
		
		UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
		
				//set self as delegated
		
		pickerController.delegate = self;
		
				//present picker controller
		
		[self presentViewController:pickerController animated:YES completion:nil];
		
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {


		
				//new image is equal to original formatted image selected
		
		self.itemImage = info[UIImagePickerControllerOriginalImage];
		
		
				//set selected image as image for picker controller
		
		self.selectedImageView.image = self.itemImage;
		
		
		
		
		
		
		
//DONItem createItemWithName:@"testItem" description:@"test"


		
				//for PNG
				//		NSData *imageData = UIImagePNGRepresentation(image);
				//    PFFile *imageFile = [PFFile fileWithName:@"photo.png" data:imageData];
		
		
				//		for JPEG, compression quality varies between 0-1 (least to best compression quality)
		
		
		NSData *imageData = UIImageJPEGRepresentation(self.itemImage, 1);
		PFFile *imageFile = [PFFile fileWithName:@"photo.jpg" data:imageData];
//		item[@"photo"] = imageFile;
//		[item saveInBackground];






		
		
		
				//dismiss
		
		
		[self dismissViewControllerAnimated:YES completion:nil];
		
		
		
		//add in progress bar using random-64 ??
		
				//parse file save
		
//[imageFile saveInBackground];
		

//		DONItem *item = [DONItem currentItem];
		

}










-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
		
		NSLog(@"user canceled image pick");
		
		[self dismissViewControllerAnimated:YES completion:nil];
		
}





-(BOOL)shouldUploadImage:(UIImage *)anImage
{
//resize image

//UIImage *resizedImage = [anImage resizedImageWithContentsMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(250.0f, 250.0f) interpolationQuality:kCGInterpolationHigh];

//		NSLog(@"%@", resizedImage);
//	set thumnail
		
		
		
		return YES;
		
		
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
