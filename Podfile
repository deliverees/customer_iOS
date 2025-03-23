# Uncomment the next line to define a global platform for your project
platform :ios, '16.6'

target 'ShopUrFood_Customer' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ShopUrFood_Customer

  target 'ShopUrFood_CustomerTests' do
    inherit! :search_paths
    # Pods for testing
  end
pod 'Bolts'
pod 'RAMAnimatedTabBarController'
pod 'Toast-Swift'
pod 'NVActivityIndicatorView'
pod 'Alamofire'
pod 'FacebookCore'
pod 'FacebookLogin'
pod 'FBSDKLoginKit'
pod 'FBSDKCoreKit'
pod 'GoogleSignIn'
pod 'JonAlert', :git => 'https://github.com/jonSurrey/JonAlert.git', :branch => 'master'
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'GoogleUtilities'
pod 'Kingfisher'
pod 'SWRevealViewController'
pod 'DropDown', :git => 'https://github.com/AssistoLab/DropDown.git', :branch => 'master'
pod 'DateTimePicker'
pod 'BottomPopup'
pod 'IQKeyboardManager'
pod 'ScrollableSegmentedControl', '~> 1.4.0'
pod 'lottie-ios'
pod 'MarqueeLabel/Swift'
pod 'ListPlaceholder'
pod 'SCLAlertView'
pod 'PayPal-iOS-SDK', :git => 'https://github.com/paypal/PayPal-iOS-SDK.git'
pod 'CCValidator'
pod 'MIBlurPopup'
pod 'CocoaMQTT'
pod 'SwiftyGif'
pod 'Segmentio', '~> 3.3'
pod 'Popover'
pod 'AMPopTip'
pod 'BetterSegmentedControl', '~> 1.0'
pod 'Firebase/Auth', '11.9.0'
pod 'Firebase/Core', '11.9.0'
pod 'Firebase/Functions', '11.9.0'
pod 'Firebase/Messaging', '11.9.0'
pod 'Firebase/Crashlytics', '11.9.0'

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "x86_64"
  end
  
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "16.6"
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "x86_64"
      end
  end
end

end
