platform :ios, '12.0'

target 'Hockey Info' do
  
  use_frameworks!

  # Pods for Hockey Info
pod 'SwifterSwift'
pod 'RealmSwift'
pod 'Kingfisher', '~> 4.0'
pod 'JTAppleCalendar', '~> 7.0'
pod 'SwiftDate', '~> 5.0'
pod "PromiseKit", "~> 6.8"
pod 'Alamofire'
pod 'SVProgressHUD'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'PromiseKit'
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.2'
      end
    end
  end
end

end
