# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
def shared_pods
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'Firebase/Storage'
pod 'Firebase/Functions'
pod 'IQKeyboardManagerSwift'
pod 'Kingfisher', '~> 4.0'
pod 'CodableFirebase'

end

target 'artable' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
    
  # Pods for artable
  shared_pods
  pod 'Stripe','15.0.1'
  pod 'Alamofire'

end

target 'artableadmin' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for artableadmin
  shared_pods
  pod 'CropViewController'

end
