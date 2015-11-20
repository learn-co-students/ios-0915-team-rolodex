//
//  DONAddItemViewController.m
//  DonateApp
//
//  Created by synesthesia on 11/18/15.
//  Copyright © 2015 Rolodex. All rights reserved.
//

#import "DONAddItemViewController.h"

@interface DONAddItemViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

@end

@implementation DONAddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
		
		//create location manager object

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - textfields
 */

-(IBAction)saveButtonTapped:(id)sender
{

		self.name = self.itemNameTextField.text;
		self.itemDescription = self.itemDescriptionTextField.text;
		self.pickupInstructions = self.pickupInstructionsTextField.text;

		// ^check to make sure none of the things are nil..

		NSData *imageData = UIImageJPEGRepresentation(self.itemImage, 0.8);
		self.itemImagePF = [PFFile fileWithName:@"photo.jpg" data:imageData];
	
		// create DONitem
		DONItem *item = (DONItem*)[PFObject objectWithClassName:@"DONItem"];
		item[@"name"] = @"testName";
		item[@"image"] = self.itemImagePF;
		item[@"pickupInstructions"] = self.pickupInstructions;
		item[@"itemDescription"] = self.itemDescription;
//		item[@"location"] = self.locationPF;
		//save it!
		[item saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
				NSLog(@"succeeded? %d, with error: %@", succeeded, error.localizedDescription);
				if (succeeded) {
						// dismiss view controller
				} else {
						// present error alert
				}
		}];
}




/*
 #pragma mark - imageUpload
 */


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
				//for PNG
				//		NSData *imageData = UIImagePNGRepresentation(image);
				//    PFFile *imageFile = [PFFile fileWithName:@"photo.png" data:imageData];

//dismiss
		[self dismissViewControllerAnimated:YES completion:nil];
		

		
				//add in progress bar using random-64 ??
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
		
		NSLog(@"user canceled image pick");
		[self dismissViewControllerAnimated:YES completion:nil];
		
		
		//cancels GPS request

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
