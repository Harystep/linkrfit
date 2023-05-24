platform :ios, '9.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] ="arm64"
    end
  end
end

target 'PowerDance' do
	
	  pod 'AFNetworking', '~>4.0.1'
	  pod 'Masonry', '~>1.1.0'
	  pod 'ReactiveObjC', '~>3.1.1'
	  pod 'SDWebImage', '~>5.12.0'
#	  pod 'BRPickerView', '~>2.7.3'
	  pod 'MJExtension', '~>3.3.0'
    pod 'IQKeyboardManager', '~>6.5.6'
    pod 'JXCategoryView'
    pod 'SDCycleScrollView'
    pod 'MBProgressHUD'
    # pod 'MJRefresh'
    pod 'WechatOpenSDK'
    pod 'AlipaySDK-iOS'
    pod 'SocketRocket'
    pod 'lottie-ios', '~> 2.5.0'
#    pod 'FLAnimatedImage', '~> 1.0'
#    pod 'SDWebImage/GIF'
    
end
