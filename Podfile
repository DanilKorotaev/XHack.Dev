platform :ios, '12.2'

target 'XHack.Dev' do
  use_frameworks!
  
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SideMenu'
  pod 'Swinject'
  pod 'SwinjectAutoregistration'
  pod 'SwiftLint'

  target 'XHack.DevTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'XHack.DevUITests' do
    # Pods for testing
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.2'
        end
    end
end
