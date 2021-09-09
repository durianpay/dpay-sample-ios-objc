platform :ios, '13.0'

target 'ShoppingCart' do
	use_frameworks!
	pod 'AFNetworking', '~> 2.0'
	pod 'RNCryptor', '~> 3.0'
  pod 'DpaySDK', '1.0.3'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
        puts target.name
    end
  end
end
