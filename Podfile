# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'Metra' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'RealmSwift'
  # Pods for restaurantArdyia
pod 'Firebase'
pod 'Firebase/Auth'
pod 'GoogleSignIn'
pod 'FBSDKCoreKit'
pod 'FBSDKShareKit'
pod 'FBSDKLoginKit'
pod 'Firebase/Database'
pod 'Firebase/Core'
 pod 'Firebase/Firestore'

pod 'SVProgressHUD'
pod 'ChameleonFramework'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
    end
  end
end
