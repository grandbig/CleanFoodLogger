# Podfile
use_frameworks!
platform :ios, '10.0'

target "CleanFoodLogger" do
  # Normal libraries
  pod 'RealmSwift'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'Alamofire', '~> 4.5'
  pod 'SwiftyJSON'
  pod 'AlamofireImage', '~> 3.3'

  abstract_target 'Tests' do
    inherit! :search_paths
    target "CleanFoodLoggerTests"
    target "CleanFoodLoggerUITests"
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.1'
    end
  end
end
