#Uncomment the next line to define a global platform for your project

platform :ios, '13.0'

target 'ShopUrFood_Customer' do
  use_frameworks!

  target 'ShopUrFood_CustomerTests' do
    inherit! :search_paths
  end

# Pods básicos
pod 'Bolts'
pod 'RAMAnimatedTabBarController'
pod 'Toast-Swift', '~> 4.0.0'
pod 'NVActivityIndicatorView'

# Facebook SDK - versión compatible con tu proyecto
pod 'FBSDKCoreKit', '~> 9.0'
pod 'FBSDKLoginKit', '~> 9.0'

# Google - ACTUALIZADO
pod 'GoogleSignIn', '~> 7.0'
pod 'JonAlert', :git => 'https://github.com/jonSurrey/JonAlert.git', :branch => 'master'
pod 'GoogleMaps'
pod 'GooglePlaces'   
pod 'GoogleUtilities'

# UI & Utilities
pod 'Kingfisher'
pod 'SWRevealViewController'
pod 'DropDown', :git => 'https://github.com/AssistoLab/DropDown.git', :branch => 'master'
pod 'DateTimePicker'
pod 'BottomPopup'   
pod 'IQKeyboardManager'
pod 'CRRefresh'
pod 'ScrollableSegmentedControl', '~> 1.4.0'
pod 'lottie-ios'
pod 'MarqueeLabel/Swift'
pod 'ListPlaceholder'   
pod 'SCLAlertView'   
pod 'CCValidator' 
pod 'MIBlurPopup'
pod 'CocoaMQTT'  
pod 'SwiftyGif'
pod 'Segmentio', '~> 3.3'
pod 'Popover'
pod 'AMPopTip'
pod 'BetterSegmentedControl', '~> 1.0'

# Networking & Payment
pod 'Alamofire', '~> 5.8'
pod 'PayPalCheckout', '~> 1.0'
pod 'Stripe', '~> 23.0.0'
pod 'StripePaymentSheet', '~> 23.0.0'

# Firebase - versión
pod 'Firebase/Auth'
pod 'Firebase/Core'
pod 'Firebase/Functions'
pod 'Firebase/Messaging'  
pod 'Firebase/Crashlytics'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Minimum deployment target
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      
      # Excluir arm64 para simulador (si usas Mac Intel)
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      
      # ✅ CRÍTICO: Fixes para GoogleSignIn 7.x
      config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end


