//
//  DONWelcomeScreenViewController.swift
//  DonateAppLaurent
//
//  Created by Laurent Farci on 19/11/15.
//  Copyright © 2015 Laurent Farci. All rights reserved.
//

import UIKit
import Parse
import SCLAlertView
import AVFoundation
import AVKit
import MBProgressHUD
//import DONAppDelegate


class DONWelcomeScreenViewController: UIViewController {

    
    // Variables for video background
    var player      = AVPlayer()
    var movietitle  = "video"
    var movietype   = "mp4"

    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var appiconOutlet: UIImageView!
    
    @IBOutlet weak var skipButton: UIButton!
    // Make the status bar White
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    // Dismiss Keyboard when tapped out of the text fields
    func screenTapped()
    {
        for subview in view.subviews
        {
            if(subview.isFirstResponder())
            {
                subview.resignFirstResponder()
            }
        }
    }
    
    @IBAction func skipButtonTapped(sender: UIButton) {
			
			NSLog("skip buttontapped")
				// Navigate to Protected page
        let appDelegate:DONAppDelegate = UIApplication.sharedApplication().delegate as! DONAppDelegate
        appDelegate.buildUserInterface()
        
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Video Background
    func playVideo() ->Bool
    {
        // Defining the path to the video file - change name here
        let path    = NSBundle.mainBundle().pathForResource(movietitle, ofType:movietype)
        let url     = NSURL.fileURLWithPath(path!)
        player      = AVPlayer(URL: url)
        
        let avPlayerLayer = AVPlayerLayer(player: player)
        
        avPlayerLayer.frame = self.view.bounds
        avPlayerLayer.videoGravity = "AVLayerVideoGravityResizeAspectFill"
        
        self.view.layer.insertSublayer(avPlayerLayer, atIndex: 0)
        
        player.volume   = 0
        player.play()
        
        print("should play")
        
        // Invoke after player is created and AVPlayerItem is specified
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "playerItemDidReachEnd:",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: player.currentItem)
        
        return true
    }
    
    func playerItemDidReachEnd(notification: NSNotification)
    {
        player.seekToTime(kCMTimeZero)
        player.play()
    }
    
    
    // Declaration for the text entry fields
    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    

    // Login Button
    @IBAction func signInButtonTapped(sender: AnyObject)
    {
        view.endEditing(true)
        
        let userEmail = userEmailAddressTextField.text?.lowercaseString
        let userPassword = userPasswordTextField.text?.lowercaseString
        
        if(userEmail!.isEmpty || userPassword!.isEmpty)
        {
            return
        }
        
        // Display activity animation
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Sending"
        spiningActivity.detailsLabelText = "Please wait"
        spiningActivity.userInteractionEnabled = false
        
        
        PFUser.logInWithUsernameInBackground(userEmail!, password: userPassword!) { (user:PFUser?, error:NSError?) -> Void in
            
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            if(user != nil)
            {
                
                // Remember the sign in state
                let userName:String? = user?.username
                
                NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "user_name")
                NSUserDefaults.standardUserDefaults().synchronize()
                print("Login Successful")
                
                // Navigate to Protected page
                let appDelegate:DONAppDelegate = UIApplication.sharedApplication().delegate as! DONAppDelegate
                appDelegate.buildUserInterface()
                
            } else {
                
                // Display error message
                SCLAlertView().showNotice("Oopss", subTitle: error!.localizedDescription)
            }
        }
    }
    
    // Keyboard 'Next' (Return key) behavior
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == userEmailAddressTextField) {
            userPasswordTextField.becomeFirstResponder()
        } else if (textField == userPasswordTextField) {
            userPasswordTextField.resignFirstResponder()
            signInButtonTapped(true)
        }
        return true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
   
        // Change the color of the placeholder in the text fields
        let attributedEmailPlaceholder = NSAttributedString(string: "EMAIL ADDRESS", attributes: [ NSForegroundColorAttributeName: UIColor.whiteColor() ])
        userEmailAddressTextField.attributedPlaceholder = attributedEmailPlaceholder
        
        let attributedPasswordPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [ NSForegroundColorAttributeName: UIColor.whiteColor() ])
        userPasswordTextField.attributedPlaceholder = attributedPasswordPlaceholder
        
        // Login Button Format
        loginButtonOutlet.layer.cornerRadius = 3
        loginButtonOutlet.clipsToBounds          = true
        appiconOutlet.layer.cornerRadius = 5
        appiconOutlet.clipsToBounds          = true
        
        let myColor : UIColor = UIColor( red: 0, green: 0, blue:0, alpha: 1.0 )
        
        userEmailAddressTextField.layer.borderColor = myColor.CGColor
        userPasswordTextField.layer.borderColor = myColor.CGColor
        
        // Recognize tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("screenTapped"))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        //firstResponderDelay()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        //Timer to show keyboard
        //NSThread.sleepForTimeInterval(0.5)
        //userEmailAddressTextField.becomeFirstResponder()
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.playVideo()
    }
}
