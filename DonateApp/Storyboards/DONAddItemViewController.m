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
		

		
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTappedImageView)];
		self.selectedImageView.userInteractionEnabled = YES;
		[self.selectedImageView addGestureRecognizer:tapGesture];
		self.selectedImageView.backgroundColor = [UIColor blackColor];
		
		self.navigationItem.title = @"Donate Item";
		
		UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelClicked)];
		[stopButton setTintColor:[UIColor blackColor]];
		self.navigationItem.leftBarButtonItem = stopButton;
		self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
		
		
		self.saveButton.backgroundColor = [UIColor colorWithRed:0.133 green:0.752 blue:0.392 alpha:1.0];
		
		
    // Do any additional setup after loading the view.
}

-(void)cancelClicked{
		[self dismissViewControllerAnimated:YES completion:nil];
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
		self.listedBy = [DONUser currentUser];
		self.views = @0;

		
		NSData *imageData = UIImageJPEGRepresentation(self.itemImage, 0.8);
		self.itemImagePF = [PFFile fileWithName:@"photo.jpg" data:imageData];
		
				// create DONitem
		DONItem *item = (DONItem*)[PFObject objectWithClassName:@"DONItem"];
		
		
				//[item addCategory:self.category withCompletion:^(BOOL success) {
				//		NSLog(@" added category %@ to item", self.category);
				//}];
		
		
		item[@"name"] = self.name;
		item[@"image"] = self.itemImagePF;
		item[@"pickupInstructions"] = self.pickupInstructions;
		item[@"itemDescription"] = self.itemDescription;
		item[@"listedBy"] = self.listedBy;
		item[@"location"] = self.locationPF;
		item[@"views"] = self.views;
		
				//save it!
		
		
		
		



		
				
		
		
		
		
		

		SCLAlertView *alert = [[SCLAlertView alloc]init];
		alert.customViewColor =  [UIColor colorWithRed:33.0/255.0 green:192.0/255.0 blue:100.0/255.0 alpha:1];
		alert.showAnimationType = FadeIn;
		alert.hideAnimationType = FadeOut;
		
		if (self.name.length< 3) {
    [alert showWarning:self title:@"Incomplete Name" subTitle:@"Please finish entering name" closeButtonTitle:@"OK" duration:0.0f];
				
		}
		
		if (self.itemDescription.length <3) {
				[alert showWarning:self title:@"Incomplete Description" subTitle:@"Please complete description" closeButtonTitle:@"OK" duration:0.0f];
		}
		if (self.pickupInstructions.length <3) {
				[alert showWarning:self title:@"Incomplete Instructions" subTitle:@"Please complete pickup instructions" closeButtonTitle:@"OK" duration:0.0f];
		}
		
		[alert alertIsDismissed:^{
				NSLog(@"SCLAlertView dismissed!");
		}];
		
				//throw error if user doesn't selected category
				//if(self.categories.count <1||self.categories = nil)
		

		
		
		
		
		
		
		
		//save stuff
		
		if (self.name.length>=3 & self.itemDescription.length>=3 & self.pickupInstructions.length>=3) {
		
		
						//spinning uploading alert
				[alert showWaiting:self title:@"Please Wait" subTitle:@"hold your horses" closeButtonTitle:nil duration:3.0f];
				
		
		[item saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
				NSLog(@"succeeded? %d, with error: %@", succeeded, error.localizedDescription);
				if (succeeded) {
//						[alert showNotice:self title:@"Success" subTitle:@"Item Uploaded" closeButtonTitle:@"Done" duration:0.2f];

						[self dismissViewControllerAnimated:YES completion:^{
						
								NSLog(@"VC dismissed");
						}];


								// dismiss view controller
				} else {
								// present error alert
				}
		}];
		
		}
		
		
}

/*
 #pragma mark - imageUpload
 */


-(void)userTappedImageView{
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
		self.addPhotoPlaceholder.alpha = 0;
		
				//add in progress bar using random-64 ??
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
		
		NSLog(@"user canceled image pick");
		[self dismissViewControllerAnimated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




- (IBAction)useCurrentLocationSwitchTapped:(id)sender {

		if (self.useCurrentLocationSwitch.isOn) {
				[PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
						if (!error) {
								self.locationPF = geoPoint;
						}
				}];
				
		} else {
				PFGeoPoint *nilGeoPoint = [PFGeoPoint geoPointWithLatitude:10.0 longitude:-10.0];
				NSLog(@"nilGeoPoint is %@", nilGeoPoint);
				self.locationPF = nilGeoPoint;
		}
}




@end
