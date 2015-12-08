# Uncomment this line to define a global platform for your project
# platform :ios, '6.0'
 use_frameworks!

target 'DonateApp' do
pod 'Parse'
pod 'ParseUI'
pod 'ChameleonFramework'
pod 'MBProgressHUD'
pod 'MMDrawerController'
pod 'Masonry'
pod 'GoogleMaps'
pod 'DateTools'
pod 'ParseFacebookUtilsV4'
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
pod 'FBSDKShareKit'
pod 'SCLAlertView-Objective-C'
pod 'SCLAlertView'

# disable bitcode in every sub-target
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end

end

end