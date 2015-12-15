# Uncomment this line to define a global platform for your project
# platform :ios, '6.0'
 use_frameworks!

xcodeproj 'CURB ALERT.xcodeproj'

target 'CURB ALERT' do
pod 'Parse'
pod 'ParseUI'
pod 'MBProgressHUD'
pod 'MMDrawerController'
pod 'Masonry'
pod 'GoogleMaps'
pod 'DateTools'
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